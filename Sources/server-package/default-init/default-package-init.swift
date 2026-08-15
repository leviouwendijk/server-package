// deferred: replace this with a typed Package.swift parser
// for intelligent modifications, even after initialization

public enum PackageGenerationStyle:
    String,
    Sendable,
    Codable,
    CaseIterable,
    Hashable
{
    case prose
    case dynamic
}

internal struct PackageGenerationOptions: Sendable, Codable {
    let style: PackageGenerationStyle 
    let toolsVersionLine: String
    let packageName: String
    let macosVersion: String
    let keepSwiftTests: Bool
    
    init(
        style: PackageGenerationStyle,
        toolsVersionLine: String,
        packageName: String,
        macosVersion: String,
        keepSwiftTests: Bool = false
    ) {
        self.style = style
        self.toolsVersionLine = toolsVersionLine
        self.packageName = packageName
        self.macosVersion = macosVersion
        self.keepSwiftTests = keepSwiftTests
    }

    var swiftTestsTargetName: String {
        packageName
            + "Tests"
    }

    var swiftTestsTarget: String {
        guard keepSwiftTests else {
            return ""
        }

        return [
            "",
            "        .testTarget(",
            "            name: \"\(swiftTestsTargetName)\",",
            "            dependencies: [\"\(packageName)\"]",
            "        ),",
        ]
        .joined(
            separator: "\n"
        )
    }

    var testFlowsTargetName: String {
        let prefix = String(
            packageName.prefix(1)
        ).uppercased()

        let suffix = String(
            packageName.dropFirst()
        )

        return prefix
            + suffix
            + "TestFlows"
    }

    var testExecutableName: String {
        packageName.lowercased()
            + "test"
    }
}

internal func generatePackageSwift(
    _ options: PackageGenerationOptions
) -> String {
    switch options.style {
    case .dynamic:
        return PackageGenerator.dynamic.full(options)
    case .prose:
        return PackageGenerator.prose.full(options)
    }
}
