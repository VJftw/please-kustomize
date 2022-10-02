#!/usr/bin/env bash
#
set -Eeuo pipefail

main() {
    cmd="$1"
    shift 1

    case "$cmd" in
        setup)
            setup
        ;;
        teardown)
            teardown
        ;;
        load_images)
            load_images "$@"
        ;;
        helm_post_render)
            helm_post_render "$@"
        ;;
        *)
            log::error "Unexpected command '$cmd'."
            exit 1
        ;;
    esac
}

setup() {
    cluster_name="$("$YQ" e '.metadata.name' "$K3D_CONFIG")"

    # check if k3d cluster exists.
    if ! "$K3D" cluster get "$cluster_name" &> /dev/null; then
        log::info "Creating K3d cluster '${cluster_name}'"
        # setup localstorage
        localstorage="$HOME/.please-k8s/k3d/${cluster_name}/storage"
        mkdir -p "$localstorage"
        "$K3D" cluster create --config "$K3D_CONFIG" \
            --network "$cluster_name" \
            --volume "$localstorage:/var/lib/rancher/k3s/storage"
    fi

    log::success "K3d cluster '${cluster_name}' is available"
    kubernetes_context="k3d-${cluster_name}"
    kubectl config use-context "${kubernetes_context}"
}

teardown() {
    cluster_name="$("$YQ" e '.metadata.name' "$K3D_CONFIG")"

    # check if k3d cluster exists.
    if ! "$K3D" cluster get "$cluster_name" &> /dev/null; then
        log::info "K3d cluster ${cluster_name} doesn't exist"
        exit 1
    fi

    "$K3D" cluster delete "$cluster_name"

    # cleanup localstorage
    localstorage="$HOME/.please-k8s/k3d/${cluster_name}/storage"
    rm -rf "$localstorage"
}

load_images() {
    local image_targets=("$@")
    image_targets+=(${IMAGE_TARGETS:-})

    if [ ${#image_targets[@]} -eq 0 ]; then
        log::info "No images to push."
        exit 0
    fi

    # get registry url from config
    local registry_name="$("$YQ" e '.registries.create.name' "$K3D_CONFIG")"
    if [ "$registry_name" == "null" ]; then
        log::warn "'.registries.create.name' not set in $K3D_CONFIG"
        return
    fi
    local registry_port="$("$YQ" e '.registries.create.hostPort' "$K3D_CONFIG")"
    if [ "$registry_port" == "null" ]; then
        log::warn "'.registries.create.hostPort' not set in $K3D_CONFIG"
        return
    fi

    local registry_url="$registry_name:$registry_port"

    push_targets=("${image_targets[@]/%/_push}")

    ./pleasew run parallel -a "$registry_url" "${push_targets[@]}"
}

helm_post_render() {
    if [ -z "${IMAGE_TARGETS:-}" ]; then
        log::warn "no images passed to update references for"
        local all_yaml="$(mktemp)"
        cat <&0 > "$all_yaml"
        # print out the modified yaml
        cat "$all_yaml"
        rm "$all_yaml"
        exit 0
    fi

    image_targets=($IMAGE_TARGETS)
    image_update_refs_in_file_targets=()
    for trgt in "${image_targets[@]}"; do
        pkg="$(echo "$trgt" | cut -f1 -d:)"
        name="$(echo "$trgt" | cut -f2 -d:)"
        image_update_refs_in_file_targets+=("${pkg}:_${name}#update_refs_in_file")
    done

    # get registry url from config
    local registry_name="$("$YQ" e '.registries.create.name' "$K3D_CONFIG")"
    if [ "$registry_name" == "null" ]; then
        log::warn "'.registries.create.name' not set in $K3D_CONFIG"
        return
    fi
    local registry_port="$("$YQ" e '.registries.create.hostPort' "$K3D_CONFIG")"
    if [ "$registry_port" == "null" ]; then
        log::warn "'.registries.create.hostPort' not set in $K3D_CONFIG"
        return
    fi

    local registry_url="$registry_name:$registry_port"

    local all_yaml="$(mktemp)"
    cat <&0 > "$all_yaml"

    for tool in "${image_update_refs_in_file_targets[@]}"; do
        >&2 ./pleasew run "$tool" "$all_yaml" "$registry_url"
    done

    # print out the modified yaml
    cat "$all_yaml"
    rm "$all_yaml"
}

# define utils
log::info() {
    >&2 printf "💡 %s\n" "$@"
}

log::warn() {
    >&2 printf "⚠️ %s\n" "$@"
}

log::error() {
   >&2 printf "❌ %s\n" "$@"
}

log::success() {
   >&2 printf "✅ %s\n" "$@"
}


# exec main
main "$@"
