#!/usr/bin/env bash

set -Eeuo pipefail

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
