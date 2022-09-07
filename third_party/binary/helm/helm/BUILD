VERSION = "v3.9.4"

remote_file(
    name = "helm",
    binary = True,
    extract = True,
    url = f"https://get.helm.sh/helm-{VERSION}-{CONFIG.OS}-{CONFIG.ARCH}.tar.gz",
    visibility = ["PUBLIC"],
    exported_files = [f"{CONFIG.OS}-{CONFIG.ARCH}/helm"],
)
