VERSION = "v4.6.3"

remote_file(
    name = "_yq_download",
    extract = True,
    url = f"https://github.com/mikefarah/yq/releases/download/{VERSION}/yq_{CONFIG.OS}_{CONFIG.ARCH}.tar.gz",
    exported_files = [f"yq_{CONFIG.OS}_{CONFIG.ARCH}"],
)

genrule(
    name = "yq",
    binary = True,
    srcs = [":_yq_download"],
    outs = ["yq"],
    cmd = "mv $SRCS $OUTS",
    visibility = ["PUBLIC"],
)
