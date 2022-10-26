subinclude("//build/defs:helm")

helm_toolchain(
    name = "helm",
    version = "3.10.1",
    plugins = [
        ":helm-diff",
    ],
    visibility = ["PUBLIC"],
)

remote_file(
    name = "helm-diff",
    url = "https://github.com/databus23/helm-diff/releases/download/v3.6.0/helm-diff-linux-amd64.tgz",
    extract = True,
)
