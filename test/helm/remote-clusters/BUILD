for name in ["cluster_a", "cluster_b", "cluster_c"]:
    sh_cmd(
        name = tag(name, "kube_context"),
        shell = "/usr/bin/env bash",
        cmd = f"""
        >&2 echo "cluster_name: {name}"
        echo "{name}"
        """,
        visibility = ["PUBLIC"],
    )

    sh_cmd(
        name = tag(name, "image_pusher"),
        shell = "/usr/bin/env bash",
        cmd = f"""
        >&2 echo "\"pushing images to: {name}\""
        """,
        visibility = ["PUBLIC"],
    )

    sh_cmd(
        name = tag(name, "helm_post_renderer"),
        shell = "/usr/bin/env bash",
        cmd = """
        >&2 echo "helm post renderer"
        all_yaml=\\\$(mktemp)
        cat <&0 > "\\\$all_yaml"
        cat "\\\$all_yaml"
        rm "\\\$all_yaml"
        """,
        visibility = ["PUBLIC"],
    )
