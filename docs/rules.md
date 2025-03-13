<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Public API re-exports

<a id="java_pitest_test"></a>

## java_pitest_test

<pre>
java_pitest_test(<a href="#java_pitest_test-name">name</a>, <a href="#java_pitest_test-test_class">test_class</a>, <a href="#java_pitest_test-package_prefixes">package_prefixes</a>, <a href="#java_pitest_test-runtime_deps">runtime_deps</a>, <a href="#java_pitest_test-args">args</a>, <a href="#java_pitest_test-srcs">srcs</a>, <a href="#java_pitest_test-src_dirs">src_dirs</a>, <a href="#java_pitest_test-data">data</a>,
                 <a href="#java_pitest_test-test_targets">test_targets</a>, <a href="#java_pitest_test-library_targets">library_targets</a>, <a href="#java_pitest_test-target_classes">target_classes</a>, <a href="#java_pitest_test-rules_pitest">rules_pitest</a>, <a href="#java_pitest_test-kwargs">kwargs</a>)
</pre>

Runs pitest test using Bazel.

This is designed to be a drop-in replacement for `java_test`, but
rather than using a JUnit4 runner it provides support for using
pitest directly. The arguments are the same as used by `java_test`.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="java_pitest_test-name"></a>name |  The name of the test.   |  none |
| <a id="java_pitest_test-test_class"></a>test_class |  The Java class to be loaded by the test runner. If not specified, the class name will be inferred from a combination of the current bazel package and the <code>name</code> attribute.   |  <code>None</code> |
| <a id="java_pitest_test-package_prefixes"></a>package_prefixes |  List of prefixes for your maven targets   |  <code>[]</code> |
| <a id="java_pitest_test-runtime_deps"></a>runtime_deps |  Additional runtime dependencies for the test.   |  <code>[]</code> |
| <a id="java_pitest_test-args"></a>args |  extra args for the pitest cli   |  <code>[]</code> |
| <a id="java_pitest_test-srcs"></a>srcs |  java source files to make available to the mutate tree   |  <code>[]</code> |
| <a id="java_pitest_test-src_dirs"></a>src_dirs |  directories to enable for pitest   |  <code>[]</code> |
| <a id="java_pitest_test-data"></a>data |  extra data to pass into the pitest runfiles   |  <code>[]</code> |
| <a id="java_pitest_test-test_targets"></a>test_targets |  bazel test targets that are used by pitest   |  <code>[]</code> |
| <a id="java_pitest_test-library_targets"></a>library_targets |  bazel libraries that are going to be mutated by pitest   |  <code>[]</code> |
| <a id="java_pitest_test-target_classes"></a>target_classes |  pitest targetClasses cli argument   |  <code>[]</code> |
| <a id="java_pitest_test-rules_pitest"></a>rules_pitest |  Alias for the rules_pitest in case you don't import as rules_pitest   |  <code>"rules_pitest"</code> |
| <a id="java_pitest_test-kwargs"></a>kwargs |  Aditional flags to the test   |  none |


