subinclude("//build/defs:k8s")

kustomized_config(
    name = "k8s",
    srcs = [
        "configmap.yaml",
        "kustomization.yaml",
    ],
    images = [":busybox"],
    visibility = [
        "//test/helm/...",
        "//test/kustomize/bases/overlay/...",
    ],
)

subinclude("///buildkit//build/defs:buildkit")

buildkit_image_mirror(
    name = "busybox",
    digest = "sha256:98de1ad411c6d08e50f26f392f3bc6cd65f686469b7c22a85c7b5fb1b820c154",
    repo = "index.docker.io/busybox",
)
