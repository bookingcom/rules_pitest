"Extra Dependencies to call when using rules_pitest from WORKSPACE"

load("@rules_jvm_external//:defs.bzl", "maven_install")

def maven_dependencies():
    "Import this method and execute it from your WORKSPACE when not using bzlmod"
    maven_install(
        name = "maven_pitest",
        artifacts = [
            "org.pitest:pitest:1.15.8",
            "org.pitest:pitest-entry:1.15.8",
            "org.pitest:pitest-command-line:1.15.8",
            "org.pitest:pitest-junit5-plugin:1.2.1",
        ],
        fetch_sources = False,
        repositories = [
            "https://maven.google.com",
            "https://repo1.maven.org/maven2",
        ],
    )
