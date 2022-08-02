subinclude("//build_defs:k8s")

kustomized_config(
    name = "k8s",
    srcs = [
        "kustomization.yaml",
    ],
    deps = [
        "//test/bases/base:k8s",
    ],
)
