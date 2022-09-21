sh_cmd(
    name = "setup",
    data = [
        ":_setup",
        ":util",
        "//third_party/binary/mikefarah/yq:yq",
        "//third_party/binary/rancher/k3d:k3d",
    ],
    shell = "/usr/bin/env bash",
    cmd = """
set -Eeuo pipefail
source $(out_location :util)
YQ="$(out_location //third_party/binary/mikefarah/yq:yq)"
K3D="$(out_location //third_party/binary/rancher/k3d:k3d)"

source $(out_location :_setup)
    """,
    visibility = ["PUBLIC"],
)

export_file(
    name = "util",
    src = "util.sh",
    visibility = ["PUBLIC"],
)

export_file(
    name = "_setup",
    src = "setup.sh",
    visibility = ["PUBLIC"],
)

sh_cmd(
    name = "teardown",
    data = [
        ":_teardown",
        ":util",
        "//third_party/binary/mikefarah/yq:yq",
        "//third_party/binary/rancher/k3d:k3d",
    ],
    shell = "/usr/bin/env bash",
    cmd = """
set -Eeuo pipefail
source $(out_location :util)
YQ="$(out_location //third_party/binary/mikefarah/yq:yq)"
K3D="$(out_location //third_party/binary/rancher/k3d:k3d)"

source $(out_location :_teardown)
    """,
    visibility = ["PUBLIC"],
)

export_file(
    name = "_teardown",
    src = "teardown.sh",
    visibility = ["PUBLIC"],
)
