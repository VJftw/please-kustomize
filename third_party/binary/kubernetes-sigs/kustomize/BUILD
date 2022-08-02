VERSION = "v4.5.4"

remote_file(
    name = "kustomize",
    binary = True,
    extract = True,
    url = f"https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F{VERSION}/kustomize_{VERSION}_{CONFIG.OS}_{CONFIG.ARCH}.tar.gz",
    visibility = ["PUBLIC"],
)
