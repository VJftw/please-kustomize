subinclude("//build/defs:k8s")

kustomized_config(
    name = "k8s",
    srcs = [
        "kustomization.yaml",
    ],
    visibility = ["//test/..."],
    deps = [
        "//test/kustomize/bases/base:k8s",
    ],
)

k8s_deploy(
    name = "k8s",
    srcs = [":k8s"],
    kube_context = "//test/k3d:example",
)
