subinclude("//build_defs:helm")

helm_package(
    name = "my-chart",
    srcs = glob(["**/*"]),
)

helm_package(
    name = "my-chart-alternate", # this is another way of achieving the :my-chart
    src_chart_yaml = "Chart.yaml",
    src_templates = glob(["templates/*"]),
    src_values = "values.yaml",
)

helm_package(
    name = "my-other-chart",
    src_chart_yaml = "other-chart.yaml",
    src_templates = glob(["additional-templates/*"]),
    src_values = "values.yaml"
)
