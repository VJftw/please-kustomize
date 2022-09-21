#!/usr/bin/env bash

set -Eeuo pipefail

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
