subinclude("//build/defs:helm")

helm_chart(
    name = "my-parent-chart",
    src_templates = glob(["templates/*"]) + [
        "//test/kustomize/bases/overlay:k8s",
    ],
    src_values = "values.yaml",
    subcharts = [
        "//test/helm/subcharts/my-sub-chart",
    ]
)

helm_release(
    name = "my-subchart-release",
    kube_context = "//test/k3d:example",
    src_chart = ":my-parent-chart",
    values_files = ["release-values.yaml"],
)
