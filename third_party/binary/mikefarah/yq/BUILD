VERSION = "v4.6.3"

remote_file(
    name = "_yq_download",
    exported_files = [f"yq_{CONFIG.OS}_{CONFIG.ARCH}"],
    extract = True,
    url = f"https://github.com/mikefarah/yq/releases/download/{VERSION}/yq_{CONFIG.OS}_{CONFIG.ARCH}.tar.gz",
)

genrule(
    name = "yq",
    srcs = [":_yq_download"],
    outs = ["yq"],
    binary = True,
    cmd = "mv $SRCS $OUTS",
    visibility = ["PUBLIC"],
)
