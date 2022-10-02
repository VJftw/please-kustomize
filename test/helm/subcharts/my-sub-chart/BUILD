subinclude("//build/defs:helm")

helm_chart(
    name = "my-sub-chart",
    src_templates = glob(["templates/*"]),
    src_values = "values.yaml",
    visibility = ["//test/helm/subcharts/..."],
)
