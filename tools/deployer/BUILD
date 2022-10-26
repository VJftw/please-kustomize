genrule(
    name = "deployer",
    srcs = ["deployer.sh"],
    outs = ["deployer.bin.sh"],
    binary = True,
    cmd = "cp $SRCS $OUTS",
    visibility = ["PUBLIC"],
)
