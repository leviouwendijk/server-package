extension PackageGenerator {
    public enum prose {
        internal static func minimal(
            _ options: PackageGenerationOptions
        ) -> String {
            """
            \(options.toolsVersionLine)

            import PackageDescription

            let package = Package(
                name: "\(options.packageName)",
                platforms: [
                    .macOS(.v\(options.macosVersion.replacingOccurrences(of: ".", with: "")))
                ],
                dependencies: [
                    .package(url: "https://github.com/leviouwendijk/HTTP.git", branch: "master"),
                    .package(url: "https://github.com/leviouwendijk/Server.git", branch: "master"),
                    .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
                    .package(url: "https://github.com/leviouwendijk/Loggers.git", branch: "master"),
                ],
                targets: [
                    .executableTarget(
                        name: "\(options.packageName)",
                        dependencies: [
                            .product(name: "HTTP", package: "HTTP"),
                            .product(name: "Server", package: "Server"),
                            .product(name: "Milieu", package: "Milieu"),
                            .product(name: "Loggers", package: "Loggers"),
                        ]
                    ),
                ]
            )
            """
        }

        internal static func full(
            _ options: PackageGenerationOptions
        ) -> String {
            """
            \(options.toolsVersionLine)

            import PackageDescription

            let package = Package(
                name: "\(options.packageName)",
                platforms: [
                    .macOS(.v\(options.macosVersion.replacingOccurrences(of: ".", with: "")))
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
                    // .package(url: "https://github.com/leviouwendijk/Writers.git", branch: "master"),

                    // .package(url: "https://github.com/leviouwendijk/Accounting.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Agentic.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/AgenticAdapters.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/AgenticDomains.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/AgenticInterfaces.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Allocators.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/ANSI.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Arguments.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/AWSConnector.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Capture.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Clipboard.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Commerce.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Compositions.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Concatenation.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Constructors.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/CSS.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Cynology.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Difference.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/DSL.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Economics.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Executable.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Extensions.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/FileParsers.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/FileTypes.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Fuzzy.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Graphical.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/HTML.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/ICS.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Implementations.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Indentation.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Interfaces.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/JS.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Mail.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Matching.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Musica.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Parsers.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Parsing.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Partition.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Path.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/plate.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Position.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/PostgresConnector.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/ProtocolComponents.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/PSQL.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Ranking.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Readers.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Registry.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Selection.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Storable.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Strings.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Terminal.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/TestFlows.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Tokens.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/Version.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/ViewComponents.git", branch: "master"),
                    // .package(url: "https://github.com/leviouwendijk/WebComponents.git", branch: "master"),

                    // .package(url: "https://github.com/apple/pkl-swift", from: "0.2.1"),

                    // .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "1.0.0"),
                    // .package(url: "https://github.com/smithy-lang/smithy-swift", from: "0.166.0"),
                ],
                targets: [
                    .executableTarget(
                        name: "\(options.packageName)",
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

                            // .product(name: "Accounting", package: "Accounting"),
                            // .product(name: "Agentic", package: "Agentic"),
                            // .product(name: "AgenticAdapters", package: "AgenticAdapters"),
                            // .product(name: "AgenticDomains", package: "AgenticDomains"),
                            // .product(name: "AgenticInterfaces", package: "AgenticInterfaces"),
                            // .product(name: "Allocators", package: "Allocators"),
                            // .product(name: "ANSI", package: "ANSI"),
                            // .product(name: "Arguments", package: "Arguments"),
                            // .product(name: "AWSConnector", package: "AWSConnector"),
                            // .product(name: "Capture", package: "Capture"),
                            // .product(name: "Clipboard", package: "Clipboard"),
                            // .product(name: "Commerce", package: "Commerce"),
                            // .product(name: "Compositions", package: "Compositions"),
                            // .product(name: "Concatenation", package: "Concatenation"),
                            // .product(name: "Constructors", package: "Constructors"),
                            // .product(name: "CSS", package: "CSS"),
                            // .product(name: "Cynology", package: "Cynology"),
                            // .product(name: "Difference", package: "Difference"),
                            // .product(name: "DSL", package: "DSL"),
                            // .product(name: "Economics", package: "Economics"),
                            // .product(name: "Executable", package: "Executable"),
                            // .product(name: "Extensions", package: "Extensions"),
                            // .product(name: "FileParsers", package: "FileParsers"),
                            // .product(name: "FileTypes", package: "FileTypes"),
                            // .product(name: "Fuzzy", package: "Fuzzy"),
                            // .product(name: "Graphical", package: "Graphical"),
                            // .product(name: "HTML", package: "HTML"),
                            // .product(name: "ICS", package: "ICS"),
                            // .product(name: "Implementations", package: "Implementations"),
                            // .product(name: "Indentation", package: "Indentation"),
                            // .product(name: "Interfaces", package: "Interfaces"),
                            // .product(name: "JS", package: "JS"),
                            // .product(name: "Mail", package: "Mail"),
                            // .product(name: "Matching", package: "Matching"),
                            // .product(name: "Musica", package: "Musica"),
                            // .product(name: "Parsers", package: "Parsers"),
                            // .product(name: "Parsing", package: "Parsing"),
                            // .product(name: "Partition", package: "Partition"),
                            // .product(name: "Path", package: "Path"),
                            // .product(name: "plate", package: "plate"),
                            // .product(name: "Position", package: "Position"),
                            // .product(name: "PostgresConnector", package: "PostgresConnector"),
                            // .product(name: "ProtocolComponents", package: "ProtocolComponents"),
                            // .product(name: "PSQL", package: "PSQL"),
                            // .product(name: "Ranking", package: "Ranking"),
                            // .product(name: "Readers", package: "Readers"),
                            // .product(name: "Registry", package: "Registry"),
                            // .product(name: "Selection", package: "Selection"),
                            // .product(name: "Storable", package: "Storable"),
                            // .product(name: "Strings", package: "Strings"),
                            // .product(name: "Terminal", package: "Terminal"),
                            // .product(name: "TestFlows", package: "TestFlows"),
                            // .product(name: "Tokens", package: "Tokens"),
                            // .product(name: "Version", package: "Version"),
                            // .product(name: "ViewComponents", package: "ViewComponents"),
                            // .product(name: "WebComponents", package: "WebComponents"),

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
    }
}
