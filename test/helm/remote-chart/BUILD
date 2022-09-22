remote_file(
    name = "traefik_chart_download",
    url = "https://helm.traefik.io/traefik/traefik-10.24.3.tgz",
)

subinclude("//build/defs:helm")

helm_release(
    name = "traefik",
    src_chart = ":traefik_chart_download",
    values_files = ["custom_values.yaml"],
)
