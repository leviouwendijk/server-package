// replace this with a Package.swift parser
// for intelligent modifications, even after initialization

internal func generatePackageSwift(
    toolsVersionLine: String,
    packageName: String,
    macosVersion: String
) -> String {
    """
    \(toolsVersionLine)

    import PackageDescription

    let package = Package(
        name: "\(packageName)",
        platforms: [
            .macOS(.v\(macosVersion.replacingOccurrences(of: ".", with: "")))
        ],
        dependencies: [
            .package(url: "https://github.com/leviouwendijk/HTTP.git", branch: "master"),
            .package(url: "https://github.com/leviouwendijk/Server.git", branch: "master"),
            .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
            .package(url: "https://github.com/leviouwendijk/Loggers.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Cryptography.git", branch: "master"),

            // .package(url: "https://github.com/leviouwendijk/Primitives.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Methods.git", branch: "master"),

            // .package(url: "https://github.com/leviouwendijk/Variables.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Writers.git", branch: "master"), // SafeFile writer

            // .package(url: "https://github.com/leviouwendijk/plate.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Structures.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Extensions.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Interfaces.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Parsers.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Constructors.git", branch: "master"),

            // .package(url: "https://github.com/leviouwendijk/Surfaces.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Vaporized.git", branch: "master"),

            // .package(url: "https://github.com/apple/pkl-swift", from: "0.2.1"),

            // .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "1.0.0"),
            // .package(url: "https://github.com/smithy-lang/smithy-swift", from: "0.166.0"),
        ],
        targets: [
            .executableTarget(
                name: "\(packageName)",
                dependencies: [
                    .product(name: "HTTP", package: "HTTP"),
                    .product(name: "Server", package: "Server"),
                    .product(name: "Milieu", package: "Milieu"),
                    .product(name: "Loggers", package: "Loggers"),
                    // .product(name: "Cryptography", package: "Cryptography"),

                    // .product(name: "Primitives", package: "Primitives"),
                    // .product(name: "Methods", package: "Methods"),

                    // .product(name: "Variables", package: "Variables"),
                    // .product(name: "Writers", package: "Writers"),

                    // .product(name: "plate", package: "plate"),
                    // .product(name: "Structures", package: "Structures"),
                    // .product(name: "Extensions", package: "Extensions"),
                    // .product(name: "Interfaces", package: "Interfaces"),
                    // .product(name: "Parsers", package: "Parsers"),
                    // .product(name: "Constructors", package: "Constructors"),

                    // .product(name: "Surfaces", package: "Surfaces"),
                    // .product(name: "Vaporized", package: "Vaporized"),

                    // .product(name: "PklSwift", package: "pkl-swift"),

                    // .product(name: "AWSBedrock", package: "aws-sdk-swift"),
                    // .product(name: "AWSBedrockRuntime", package: "aws-sdk-swift"),
                    // .product(name: "Smithy", package: "smithy-swift"),
                    // .product(name: "SmithyJSON", package: "smithy-swift"),

                    // .product(name: "AWSSESv2", package: "aws-sdk-swift"),
                    // .product(name: "AWSClientRuntime", package: "aws-sdk-swift"),
                    // .product(name: "AWSSDKIdentity", package: "aws-sdk-swift"),
                    // .product(name: "AWSSDKHTTPAuth", package: "aws-sdk-swift"),
                    // .product(name: "SmithyHTTPAPI", package: "smithy-swift"),
                    // .product(name: "SmithyHTTPClient", package: "smithy-swift"),
                    // .product(name: "AWSSTS", package: "aws-sdk-swift"),
                ]
            ),
        ]
    )
    """
}
