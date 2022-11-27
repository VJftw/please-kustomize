subinclude("//build/defs:helm")

helm_toolchain(
    name = "helm",
    plugins = [
        ":helm-diff",
    ],
    version = "3.10.1",
    visibility = ["PUBLIC"],
)

remote_file(
    name = "helm-diff",
    extract = True,
    url = "https://github.com/databus23/helm-diff/releases/download/v3.6.0/helm-diff-linux-amd64.tgz",
)
