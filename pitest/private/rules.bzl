def _pitest_impl(ctx):
    print("inside rule", ctx)
    pass

pitest = rule(
    implemenation = _pitest_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "targetClasses": attr.string_list(),
        "outputFormat": attr.string_list(default=["HTML"]),
        "outputEncoding": attr.string(default = "UTF-8"),
        "target": attr.label(mandatory = True, cfg = "exec"),
        "extraArguments": attr.string_dict(default = {}),
        "_pitest_cli": attr.label(
            default = "//pitest/private:pitest-cli",
            cfg = "exec"
        ),
    }
)
