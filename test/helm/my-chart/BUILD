subinclude("//build/defs:helm")

helm_chart(
    name = "my-chart-alternate",
    images = [":nginx"],
    src_templates = glob(["templates/*"]),
    src_values = "values.yaml",
)

helm_release(
    name = "my-release",
    kube_context = "//test/k3d:example",
    labels = ["foo"],
    src_chart = ":my-chart-alternate",
)

helm_release(
    name = "my-release-cluster-a",
    kube_context = "//test/helm/remote-clusters:cluster_a",
    src_chart = ":my-chart-alternate",
)

helm_chart(
    name = "my-other-chart",
    src_templates = glob(["additional-templates/*"]),
    src_values = "values.yaml",
)

subinclude("///buildkit//build/defs:buildkit")

buildkit_image_mirror(
    name = "nginx",
    digest = "sha256:c79f4fe604e3fe77cb5142e9747da3132d252af21fbb9a9d294fa2128499a8f1",
    repo = "index.docker.io/library/nginx",
)
