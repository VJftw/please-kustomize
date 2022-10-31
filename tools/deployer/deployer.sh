#!/usr/bin/env bash
set -Eeuo pipefail

# Bash version check
if [ -z "${BASH_VERSINFO[*]}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "This script requires Bash version >= 4"
    exit 1
fi

main() {
    cmd="$1"
    shift 1

    case "$cmd" in
        idempotent_deploy)
            idempotent_deploy "$@"
        ;;
        pipeline_deploy)
            pipeline_deploy "$@"
        ;;
        *)
            log::error "Unexpected command '$cmd'."
            exit 1
        ;;
    esac
}

# idempotent_deploy deploys a single Helm package idempotently by utilising the
# exit code from `helm diff ...`. This is for use as a helper in the `_deploy`
# subrules for `helm_release`s.
idempotent_deploy() {
    local helm_diff_upgrade_binary="$(_parse_flag "helm_diff_upgrade_binary" "$@")"
    local helm_push_images_binary="$(_parse_flag "helm_push_images_binary" "$@")"
    local helm_upgrade_binary="$(_parse_flag "helm_upgrade_binary" "$@")"

    if [ -z "$helm_diff_upgrade_binary" ] || \
        [ -z "$helm_push_images_binary" ] || \
        [ -z "$helm_upgrade_binary" ]; then
        log:error "Missing flag(s). Please ensure that these are set:
    - --helm_diff_upgrade_binary
    - --helm_push_images_binary
    - --helm_upgrade_binary
        "
        exit 1
    fi

    set +e
    "$helm_diff_upgrade_binary"
    ec="$?"
    set -e

    case "$ec" in
        0)
            log::success "No changes to deploy. Exiting."
            return
        ;;
        1)
            log::error "Could not determine changes to deploy."
            exit 1
        ;;
        2)
            log::info "Changes found. Deploying..."
            "$helm_push_images_binary"
            "$helm_upgrade_binary"
            log::success "Deployed changes."
        ;;
    esac
}

# pipeline_deploy deploys all Helm packages meeting the given label criteria
# in a given order grouped by the given labels. This is for use outside of
# Please build rules as an executable `plz run ...` command to orchestrate the
# deployment of resources, e.g.
# ```
# $ plz run <pipeline_deploy target> -- \
#     pipeline_deploy \
#     --labels="foo,bar" \
#     --ordered_labels="baz,stage1;qux"
# ```
# will deploy all targets with 'foo' and 'bar' in their labels, deploying those
# targets additionally with 'baz' and 'stage1' labels first, followed by those
# targets additionally with 'qux' labels before deploying the remaining targets
# with 'foo' and 'bar' labels.
pipeline_deploy() {
    local flag_labels="$(_parse_flag "labels" "$@")"
    local flag_ordered_labels="$(_parse_flag "ordered_labels" "$@")"

    deployable_labels="helm_deploy"
    if [ -n "$flag_labels" ]; then
        deployable_labels="$deployable_labels,$flag_labels"
    fi

    mapfile -t remaining_targets < \
        <(./pleasew query alltargets \
            --include "$deployable_labels"
        )

    # add a blank stage to deploy the remainder
    ordered_labels="${flag_ordered_labels};;"
    IFS=';' read -ra stages <<< "$ordered_labels"
    log::info "Deploying in ${#stages[@]} stage(s): ${stages[*]}."
    for stage in "${stages[@]}"; do
        stage_name="$stage"
        if [ -z "$stage" ]; then
            stage_name="remaining"
        fi
        log::info "Stage: $stage_name"
        targets_to_deploy=("${remaining_targets[@]}")
        if [ -n "$stage" ]; then
            mapfile -t targets_to_deploy < \
                <(printf "%s\n" "${remaining_targets[@]}" \
                    | xargs ./pleasew query filter --include "$stage"
                )
        fi

        if [ ${#targets_to_deploy[@]} -ne 0 ]; then
            log::info "Deploying ${#targets_to_deploy[@]} targets:
$(printf "%s\n" "${targets_to_deploy[@]}" | sed 's/^/    /g')
            "
            sleep 1

            plz::run_multi "${targets_to_deploy[@]}"
            mapfile -t remaining_targets < \
                <(comm -3 \
                    <(printf "%s\n" "${remaining_targets[@]}" | sort) \
                    <(printf "%s\n" "${targets_to_deploy[@]}" | sort) \
                    | sort -n
                )
        else
            log::warn "No targets to deploy in '$stage_name'. Continuing..."
        fi
        log::success "Completed Deployment of Stage: $stage_name"
    done
}

plz::run_multi() {
    args=("./pleasew" "run")
    # enable plain output and verbosity on CI builds
    if [[ "${CI:-}" == "true" ]]; then
        args+=("--plain_output" "--verbosity=2")
    fi

    # allow overriding parallel with sequential for slower machines.
    if [ -z "${PLZ_RUN_MODE:-}" ]; then
        PLZ_RUN_MODE="parallel"
    fi
    args+=("$PLZ_RUN_MODE")
    log::info "Executing ${args[*]} $*"
    "${args[@]}" "$@"
}

plz::run() {
    args=("./pleasew" "run")
    # enable plain output and verbosity on CI builds
    if [[ "${CI:-}" == "true" ]]; then
        args+=("--plain_output" "--verbosity=2")
    fi

    log::info "Executing ${args[*]} $*"
    "${args[@]}" "$@"
}

# define utils
log::info() {
    printf "💡 %s\n" "$@"
}

log::warn() {
    printf "⚠️ %s\n" "$@"
}

log::error() {
   printf "❌ %s\n" "$@"
}

log::success() {
   printf "✅ %s\n" "$@"
}

_parse_flag() {
    local name="$1"
    shift
    while test $# -gt 0; do
        case "$1" in
            "--${name}="*)
                value="$(echo "$1" | cut -d= -f2-)"
                echo "$value"
                shift
            ;;
            *)
                shift
            ;;
        esac
    done
}


main "$@"
