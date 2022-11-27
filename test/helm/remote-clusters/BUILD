for name in [
    "cluster_a",
    "cluster_b",
    "cluster_c",
]:
    sh_cmd(
        name = tag(name, "kube_context"),
        cmd = f"""
        >&2 echo "cluster_name: {name}"
        echo "{name}"
        """,
        shell = "/usr/bin/env bash",
        visibility = ["PUBLIC"],
    )

    sh_cmd(
        name = tag(name, "image_pusher"),
        cmd = f"""
        >&2 echo "\"pushing images to: {name}\""
        """,
        shell = "/usr/bin/env bash",
        visibility = ["PUBLIC"],
    )

    sh_cmd(
        name = tag(name, "helm_post_renderer"),
        cmd = """
        >&2 echo "helm post renderer"
        all_yaml=\\\\$(mktemp)
        cat <&0 > "\\\\$all_yaml"
        cat "\\\\$all_yaml"
        rm "\\\\$all_yaml"
        """,
        shell = "/usr/bin/env bash",
        visibility = ["PUBLIC"],
    )
