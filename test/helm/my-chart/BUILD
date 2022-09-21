subinclude("//build/defs:helm")

helm_application(
    name = "my-chart-alternate",
    src_templates = glob(["templates/*"]),
    src_values = "values.yaml",
)

helm_application(
    name = "my-other-chart",
    src_templates = glob(["additional-templates/*"]),
    src_values = "values.yaml"
)
