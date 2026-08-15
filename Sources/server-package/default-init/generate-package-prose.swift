import Foundation

extension PackageGenerator {
    public enum prose {
        internal static func minimal(
            _ options: PackageGenerationOptions
        ) -> String {
            let packageDependencies = ServerPackageDependencyRenderer.prosePackages(
                ServerPackageDependencyCatalog.minimal,
                indentation: 8
            )

            let targetDependencies = ServerPackageDependencyRenderer.proseProducts(
                ServerPackageDependencyCatalog.minimal,
                indentation: 16
            )

            return """
            \(options.toolsVersionLine)

            import PackageDescription

            let package = Package(
                name: "\(options.packageName)",
                platforms: [
                    .macOS(.v\(options.macosVersion.replacingOccurrences(of: ".", with: "")))
                ],
                dependencies: [
            \(packageDependencies)
                ],
                targets: [
                    .executableTarget(
                        name: "\(options.packageName)",
                        dependencies: [
            \(targetDependencies)
                        ]
                    ),
                ]
            )
            """
        }

        internal static func full(
            _ options: PackageGenerationOptions
        ) -> String {
            let packageDependencies = ServerPackageDependencyRenderer.prosePackages(
                ServerPackageDependencyCatalog.full,
                indentation: 8
            )

            let targetDependencies = ServerPackageDependencyRenderer.proseProducts(
                ServerPackageDependencyCatalog.full,
                indentation: 16
            )

            return """
            \(options.toolsVersionLine)

            import PackageDescription

            let package = Package(
                name: "\(options.packageName)",
                platforms: [
                    .macOS(.v\(options.macosVersion.replacingOccurrences(of: ".", with: "")))
                ],
                products: [
                    // .executable(
                    //     name: "\(options.testExecutableName)",
                    //     targets: ["\(options.testFlowsTargetName)"]
                    // ),
                ],
                dependencies: [
            \(packageDependencies)

                    // .package(url: "https://github.com/apple/pkl-swift", from: "0.2.1"),

                    // .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "1.0.0"),
                    // .package(url: "https://github.com/smithy-lang/smithy-swift", from: "0.166.0"),
                ],
                targets: [
                    .executableTarget(
                        name: "\(options.packageName)",
                        dependencies: [
            \(targetDependencies)

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

                    // .executableTarget(
                    //     name: "\(options.testFlowsTargetName)",
                    //     dependencies: [
                    //         .product(
                    //             name: "TestFlows",
                    //             package: "TestFlows"
                    //         ),
                    //     ]
                    // ),
                ]
            )
            """
        }
    }
}
