remote_file(
    name = "traefik_chart_download",
    url = "https://github.com/traefik/traefik-helm-chart/archive/refs/tags/v10.24.2.zip",
    extract = True,
    exported_files = ["traefik-helm-chart-10.24.2/traefik/"]
)

subinclude("//build_defs:helm")

helm_package(
    name = "traefik",
    srcs = [":traefik_chart_download"],
    values_files = ["custom_values.yaml"],
)
