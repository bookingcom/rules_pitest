load("@rules_java//java:defs.bzl", "java_test")

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

def java_pitest_test(
        name,
        test_class = None,
        package_prefixes = [],
        runtime_deps = [],
        args = [],
        srcs = [],
        src_dirs = [],
        data = [],
        target = None,
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
        **kwargs: Aditional flags to the test
        package_prefixes: List of prefixes for your maven targets
    """
    if test_class:
        clazz = test_class
    else:
        clazz = _get_package_name(package_prefixes) + name

    src_dirs = [native.package_name()] + src_dirs

    args = list(args)
    args += [
        "--reportDir",
        "report-dir",
        "--sourceDirs",
        ",".join(src_dirs),
        "--targetClasses",
        ",".join(target_classes),
    ]

    java_test(
        name = name,
        main_class = "org.pitest.mutationtest.commandline.MutationCoverageReport",
        test_class = clazz,
        runtime_deps = runtime_deps + [
            "@com_bookingcom_rules_pitest//pitest:org_pitest_pitest_command_line",
        ],
        data = srcs + data + [target],
        args = args,
        **kwargs
    )
