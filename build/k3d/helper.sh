#!/usr/bin/env bash
#
set -Eeuo pipefail

main() {
    cmd="$1"

    case "$cmd" in
        setup)
            setup
        ;;
        teardown)
            teardown
        ;;
        *)
            util::error "Unexpected command '$cmd'."
            exit 1
        ;;
    esac
}

setup() {
    cluster_name="$("$YQ" e '.metadata.name' "$K3D_CONFIG")"

    # check if k3d cluster exists.
    if ! "$K3D" cluster get "$cluster_name" &> /dev/null; then
        util::info "Creating K3d cluster '${cluster_name}'"
        # setup localstorage
        localstorage="$HOME/.please-k8s/k3d/${cluster_name}/storage"
        mkdir -p "$localstorage"
        "$K3D" cluster create --config "$K3D_CONFIG" \
            --network "$cluster_name" \
            --volume "$localstorage:/var/lib/rancher/k3s/storage"
    fi

    util::success "K3d cluster '${cluster_name}' is available"
    kubernetes_context="k3d-${cluster_name}"
    kubectl config use-context "${kubernetes_context}"
}

teardown() {
    cluster_name="$("$YQ" e '.metadata.name' "$K3D_CONFIG")"

    # check if k3d cluster exists.
    if ! "$K3D" cluster get "$cluster_name" &> /dev/null; then
        util::info "K3d cluster ${cluster_name} doesn't exist"
        exit 1
    fi

    "$K3D" cluster delete "$cluster_name"

    # cleanup localstorage
    localstorage="$HOME/.please-k8s/k3d/${cluster_name}/storage"
    rm -rf "$localstorage"
}

# define utils
util::info() {
    printf "💡 %s\n" "$@"
}

util::warn() {
    printf "⚠️ %s\n" "$@"
}

util::error() {
    printf "❌ %s\n" "$@"
}

util::success() {
  printf "✅ %s\n" "$@"
}


# exec main
main "$@"
