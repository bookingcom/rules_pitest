"rule implementation for pitest"

load("@rules_java//java:defs.bzl", "java_common", "java_test")

# Common package prefixes, in the order we want to check for them
_PREFIXES = (".com.", ".org.", ".net.", ".io.", ".ai.", ".co.", ".me.")

# By default bazel computes the name of test classes based on the
# standard Maven directory structure, which we may not always use,
# so try to compute the correct package name.
#
# this method is based on: https://github.com/bazel-contrib/rules_jvm/blob/f0a9a36e881f4813f50656eaee81f9988b2b7d29/java/private/package.bzl#L7
def _get_package_name(prefixes = []):
    pkg = native.package_name().replace("/", ".")
    if len(prefixes) == 0:
        prefixes = _PREFIXES

    for prefix in prefixes:
        idx = pkg.find(prefix)
        if idx != -1:
            return pkg[idx + 1:] + "."

    return ""

_EXTRACT_JAR_TMPL = """
set -e;
CWD=$(pwd);
rm -rf {out_path};
mkdir -p {out_path};
cd {out_path};
"""

def _extract_jar_impl(ctx):
    out = ctx.actions.declare_directory(ctx.label.name)

    java_runtime = ctx.attr._jdk[java_common.JavaRuntimeInfo]
    jar_path = "%s/bin/jar" % java_runtime.java_home

    cmd = _EXTRACT_JAR_TMPL.format(
        out_path = out.path,
    )

    for x in ctx.files.target:
        cmd = "{cmd}$CWD/{jar_path} -xf $CWD/{file};\n".format(cmd = cmd, jar_path = jar_path, file = x.path)

    cmd = "%srm -rf META-INF;\n" % cmd

    ctx.actions.run_shell(
        outputs = [out],
        inputs = ctx.files.target + ctx.files._jdk,
        mnemonic = "ExtractJar",
        command = cmd,
        use_default_shell_env = True,
    )

    return DefaultInfo(files = depset([out]))

_extract_jar = rule(
    implementation = _extract_jar_impl,
    attrs = {
        "target": attr.label_list(allow_files = True),
        "_jdk": attr.label(
            default = "@rules_java//toolchains:current_host_java_runtime",
            providers = [java_common.JavaRuntimeInfo],
            cfg = "exec",
        ),
    },
)

def java_pitest_test(
        name,
        test_class = None,
        package_prefixes = [],
        runtime_deps = [],
        args = [],
        srcs = [],
        src_dirs = [],
        data = [],
        test_targets = [],
        library_targets = [],
        target_classes = [],
        **kwargs):
    """Runs pitest test using Bazel.

    This is designed to be a drop-in replacement for `java_test`, but
    rather than using a JUnit4 runner it provides support for using
    pitest directly. The arguments are the same as used by `java_test`.

    Args:
        name: The name of the test.
        test_class: The Java class to be loaded by the test runner. If not
            specified, the class name will be inferred from a combination of
            the current bazel package and the `name` attribute.
        runtime_deps: Additional runtime dependencies for the test.
        args: extra args for the pitest cli
        srcs: java source files to make available to the mutate tree
        src_dirs: directories to enable for pitest
        data: extra data to pass into the pitest runfiles
        test_targets: bazel test targets that are used by pitest
        library_targets: bazel libraries that are going to be mutated by pitest
        target_classes: pitest targetClasses cli argument
        package_prefixes: List of prefixes for your maven targets
        **kwargs: Aditional flags to the test

    """
    if test_class:
        clazz = test_class
    else:
        clazz = _get_package_name(package_prefixes) + name

    src_dirs = [native.package_name()] + src_dirs

    _extract_jar(
        name = "%s-classes" % name,
        target = library_targets,
    )

    _extract_jar(
        name = "%s-test-classes" % name,
        target = ["%s.jar" % x for x in test_targets],
        testonly = True,
    )

    args = list(args)
    args += [
        "--reportDir",
        "$$TEST_UNDECLARED_OUTPUTS_DIR",
        "--sourceDirs",
        ",".join(src_dirs),
        "--targetClasses",
        ",".join(target_classes),
    ]

    runtime_deps = runtime_deps + test_targets + [
        "@com_bookingcom_rules_pitest//pitest:org_pitest_pitest_command_line",
    ]

    java_test(
        name = name,
        main_class = "org.pitest.mutationtest.commandline.MutationCoverageReport",
        test_class = clazz,
        runtime_deps = runtime_deps,
        data = srcs + data + test_targets + library_targets + [
            ":%s-classes" % name,
            ":%s-test-classes" % name,
            "@rules_java//toolchains:current_java_runtime",
        ],
        args = args,
        jvm_flags = [
            "-cp",
            "$$CLASSPATH:$(location :%s-classes):$(location :%s-test-classes)" % (name, name),
        ],
        **kwargs
    )
