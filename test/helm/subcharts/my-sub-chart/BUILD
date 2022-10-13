subinclude("//build/defs:helm")

helm_chart(
    name = "my-sub-chart",
    src_templates = glob(["templates/*"]),
    src_values = "values.yaml",
    visibility = ["//test/helm/subcharts/..."],
    images = [
        ":nginx",
    ],
)


subinclude("///buildkit//build/defs:buildkit")

buildkit_image_mirror(
    name = "nginx",
    repo = "index.docker.io/library/nginx",
    digest = "sha256:c79f4fe604e3fe77cb5142e9747da3132d252af21fbb9a9d294fa2128499a8f1",
)
