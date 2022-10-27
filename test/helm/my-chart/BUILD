subinclude("//build/defs:helm")

helm_chart(
    name = "my-chart-alternate",
    src_templates = glob(["templates/*"]),
    src_values = "values.yaml",
    images = [":nginx"],
)

helm_release(
    name = "my-release",
    kube_context = "//test/k3d:example",
    src_chart = ":my-chart-alternate",
    labels = ["foo"],
)

helm_release(
    name = "my-release-cluster-a",
    kube_context = "//test/helm/remote-clusters:cluster_a",
    src_chart = ":my-chart-alternate",
)

helm_chart(
    name = "my-other-chart",
    src_templates = glob(["additional-templates/*"]),
    src_values = "values.yaml"
)

subinclude("///buildkit//build/defs:buildkit")

buildkit_image_mirror(
    name = "nginx",
    repo = "index.docker.io/library/nginx",
    digest = "sha256:c79f4fe604e3fe77cb5142e9747da3132d252af21fbb9a9d294fa2128499a8f1",
)
