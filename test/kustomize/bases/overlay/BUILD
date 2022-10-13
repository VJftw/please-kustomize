subinclude("//build/defs:k8s")

kustomized_config(
    name = "k8s",
    srcs = [
        "kustomization.yaml",
    ],
    deps = [
        "//test/kustomize/bases/base:k8s",
    ],
    visibility = ["//test/..."]
)

k8s_deploy(
    name = "k8s",
    srcs = [":k8s"],
    kube_context = "//test/k3d:example",
)
