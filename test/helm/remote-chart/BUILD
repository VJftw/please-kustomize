subinclude("//build/defs:helm")

helm_remote_chart(
    name = "traefik_chart_download",
    url = "https://helm.traefik.io/traefik/traefik-10.24.3.tgz",
    images = [
        ":busybox",
    ],
)

subinclude("///buildkit//build/defs:buildkit")

buildkit_image_mirror(
    name = "busybox",
    repo = "index.docker.io/busybox",
    digest = "sha256:98de1ad411c6d08e50f26f392f3bc6cd65f686469b7c22a85c7b5fb1b820c154",
)

helm_release(
    name = "traefik",
    kube_context = "//test/helm/remote-clusters:cluster_c",
    src_chart = ":traefik_chart_download",
    values_files = ["custom_values.yaml"],
)
