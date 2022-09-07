subinclude("//build_defs:helm")

helm_package(
    name = "my-chart",
    srcs = glob(["**/*"]),
    chart_yaml_file = "Chart.yaml",
)

helm_package(
    name = "my-other-chart",
    chart_yaml_file = "other-chart.yaml",
    srcs = glob(["templates/*", "values.yaml"]),
    templates = glob(["additional-templates/*"])
)
