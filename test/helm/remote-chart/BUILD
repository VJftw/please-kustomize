subinclude("//build/defs:helm")

helm_remote_chart(
    name = "traefik_chart_download",
    images = [
        ":busybox",
    ],
    url = "https://traefik.github.io/charts/traefik/traefik-20.5.2.tgz",
)

subinclude("///buildkit//build/defs:buildkit")

buildkit_image_mirror(
    name = "busybox",
    digest = "sha256:98de1ad411c6d08e50f26f392f3bc6cd65f686469b7c22a85c7b5fb1b820c154",
    repo = "index.docker.io/busybox",
)

helm_release(
    name = "traefik",
    kube_context = "//test/helm/remote-clusters:cluster_c",
    src_chart = ":traefik_chart_download",
    values_files = ["custom_values.yaml"],
)
