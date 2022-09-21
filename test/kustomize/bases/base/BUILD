subinclude("//build/defs:k8s")

kustomized_config(
    name = "k8s",
    srcs = [
        "kustomization.yaml",
        "configmap.yaml",
    ],
    visibility = ["//test/kustomize/bases/overlay/..."],
)
