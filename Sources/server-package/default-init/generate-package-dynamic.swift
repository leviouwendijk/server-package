extension PackageGenerator {
    public enum dynamic {
        internal static let deps_block = """
        enum Deps {
            struct Ref {
                let repo: String
                let package: String
                let product: String

                init(_ name: String) {
                    self.repo = name
                    self.package = name
                    self.product = name
                }

                init(
                    repo: String,
                    package: String? = nil,
                    product: String? = nil
                ) {
                    self.repo = repo
                    self.package = package ?? repo
                    self.product = product ?? package ?? repo
                }
            }

            struct GitHub {
                let owner: String
                let branch: String

                init(
                    owner: String,
                    branch: String = "master"
                ) {
                    self.owner = owner
                    self.branch = branch
                }

                func package(
                    _ ref: Ref
                ) -> Package.Dependency {
                    .package(
                        url: url(for: ref),
                        branch: branch
                    )
                }

                func package(
                    _ ref: Ref,
                    from version: Version
                ) -> Package.Dependency {
                    .package(
                        url: url(for: ref),
                        from: version
                    )
                }

                func package(
                    _ ref: Ref,
                    exact version: Version
                ) -> Package.Dependency {
                    .package(
                        url: url(for: ref),
                        exact: version
                    )
                }

                func package(
                    _ ref: Ref,
                    branch: String
                ) -> Package.Dependency {
                    .package(
                        url: url(for: ref),
                        branch: branch
                    )
                }

                func package(
                    _ ref: Ref,
                    revision: String
                ) -> Package.Dependency {
                    .package(
                        url: url(for: ref),
                        revision: revision
                    )
                }

                func product(
                    _ ref: Ref,
                    condition: TargetDependencyCondition? = nil
                ) -> Target.Dependency {
                    .product(
                        name: ref.product,
                        package: ref.package,
                        condition: condition
                    )
                }

                private func url(
                    for ref: Ref
                ) -> String {
                    "https://github.com/\\(owner)/\\(ref.repo).git"
                }
            }

            @dynamicMemberLookup
            struct Packages<Catalog> {
                let github: GitHub
                let catalog: Catalog

                subscript(
                    dynamicMember keyPath: KeyPath<Catalog, Ref>
                ) -> Package.Dependency {
                    github.package(catalog[keyPath: keyPath])
                }

                func package(
                    _ ref: Ref,
                    from version: Version
                ) -> Package.Dependency {
                    github.package(ref, from: version)
                }

                func package(
                    _ ref: Ref,
                    exact version: Version
                ) -> Package.Dependency {
                    github.package(ref, exact: version)
                }

                func package(
                    _ ref: Ref,
                    branch: String
                ) -> Package.Dependency {
                    github.package(ref, branch: branch)
                }

                func package(
                    _ ref: Ref,
                    revision: String
                ) -> Package.Dependency {
                    github.package(ref, revision: revision)
                }
            }

            @dynamicMemberLookup
            struct Products<Catalog> {
                let github: GitHub
                let catalog: Catalog

                subscript(
                    dynamicMember keyPath: KeyPath<Catalog, Ref>
                ) -> Target.Dependency {
                    github.product(catalog[keyPath: keyPath])
                }

                func product(
                    _ ref: Ref,
                    condition: TargetDependencyCondition? = nil
                ) -> Target.Dependency {
                    github.product(ref, condition: condition)
                }
            }
        }
        """
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
                    .leviouwendijk.HTTP,
                    .leviouwendijk.Server,
                    .leviouwendijk.Milieu,
                    .leviouwendijk.Loggers,
                ],
                targets: [
                    .executableTarget(
                        name: "\(options.packageName)",
                        dependencies: [
                            .leviouwendijk.HTTP,
                            .leviouwendijk.Server,
                            .leviouwendijk.Milieu,
                            .leviouwendijk.Loggers,
                        ]
                    ),
                ]
            )

            \(deps_block)

            enum Libs {
                static let leviouwendijk = LeviOuwendijk()
            }

            struct LeviOuwendijk {
                let HTTP = Deps.Ref("HTTP")
                let Server = Deps.Ref("Server")
                let Milieu = Deps.Ref("Milieu")
                let Loggers = Deps.Ref("Loggers")
            }

            extension Package.Dependency {
                static var leviouwendijk: Deps.Packages<LeviOuwendijk> {
                    .init(
                        github: .init(owner: "leviouwendijk"),
                        catalog: Libs.leviouwendijk
                    )
                }
            }

            extension Target.Dependency {
                static var leviouwendijk: Deps.Products<LeviOuwendijk> {
                    .init(
                        github: .init(owner: "leviouwendijk"),
                        catalog: Libs.leviouwendijk
                    )
                }
            }
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
                    .leviouwendijk.HTTP,
                    .leviouwendijk.Server,
                    .leviouwendijk.Milieu,
                    .leviouwendijk.Loggers,
                    // .leviouwendijk.Cryptography,

                    // .leviouwendijk.Primitives,
                    // .leviouwendijk.Methods,

                    // .leviouwendijk.Variables,
                    // .leviouwendijk.Writers,

                    // .leviouwendijk.Accounting,
                    // .leviouwendijk.Agentic,
                    // .leviouwendijk.AgenticAdapters,
                    // .leviouwendijk.AgenticDomains,
                    // .leviouwendijk.AgenticInterfaces,
                    // .leviouwendijk.Allocators,
                    // .leviouwendijk.ANSI,
                    // .leviouwendijk.Arguments,
                    // .leviouwendijk.AWSConnector,
                    // .leviouwendijk.Capture,
                    // .leviouwendijk.Clipboard,
                    // .leviouwendijk.Commerce,
                    // .leviouwendijk.Compositions,
                    // .leviouwendijk.Concatenation,
                    // .leviouwendijk.Constructors,
                    // .leviouwendijk.CSS,
                    // .leviouwendijk.Cynology,
                    // .leviouwendijk.Difference,
                    // .leviouwendijk.DSL,
                    // .leviouwendijk.Economics,
                    // .leviouwendijk.Executable,
                    // .leviouwendijk.Extensions,
                    // .leviouwendijk.FileParsers,
                    // .leviouwendijk.FileTypes,
                    // .leviouwendijk.Fuzzy,
                    // .leviouwendijk.Graphical,
                    // .leviouwendijk.HTML,
                    // .leviouwendijk.ICS,
                    // .leviouwendijk.Implementations,
                    // .leviouwendijk.Indentation,
                    // .leviouwendijk.Interfaces,
                    // .leviouwendijk.JS,
                    // .leviouwendijk.Mail,
                    // .leviouwendijk.Matching,
                    // .leviouwendijk.Musica,
                    // .leviouwendijk.Parsers,
                    // .leviouwendijk.Parsing,
                    // .leviouwendijk.Partition,
                    // .leviouwendijk.Path,
                    // .leviouwendijk.plate,
                    // .leviouwendijk.Position,
                    // .leviouwendijk.PostgresConnector,
                    // .leviouwendijk.ProtocolComponents,
                    // .leviouwendijk.PSQL,
                    // .leviouwendijk.Ranking,
                    // .leviouwendijk.Readers,
                    // .leviouwendijk.Registry,
                    // .leviouwendijk.Selection,
                    // .leviouwendijk.Storable,
                    // .leviouwendijk.Strings,
                    // .leviouwendijk.Terminal,
                    // .leviouwendijk.TestFlows,
                    // .leviouwendijk.Tokens,
                    // .leviouwendijk.Version,
                    // .leviouwendijk.ViewComponents,
                    // .leviouwendijk.WebComponents,

                    // .apple.package(Libs.apple.PklSwift, from: "0.2.1"),

                    // .awslabs.package(Libs.awslabs.awsSDKSwift, from: "1.0.0"),
                    // .smithyLang.package(Libs.smithyLang.smithySwift, from: "0.166.0"),
                ],
                targets: [
                    .executableTarget(
                        name: "\(options.packageName)",
                        dependencies: [
                            .leviouwendijk.HTTP,
                            .leviouwendijk.Server,
                            .leviouwendijk.Milieu,
                            .leviouwendijk.Loggers,
                            // .leviouwendijk.Cryptography,

                            // .leviouwendijk.Primitives,
                            // .leviouwendijk.Methods,

                            // .leviouwendijk.Variables,
                            // .leviouwendijk.Writers,

                            // .leviouwendijk.Accounting,
                            // .leviouwendijk.Agentic,
                            // .leviouwendijk.AgenticAdapters,
                            // .leviouwendijk.AgenticDomains,
                            // .leviouwendijk.AgenticInterfaces,
                            // .leviouwendijk.Allocators,
                            // .leviouwendijk.ANSI,
                            // .leviouwendijk.Arguments,
                            // .leviouwendijk.AWSConnector,
                            // .leviouwendijk.Capture,
                            // .leviouwendijk.Clipboard,
                            // .leviouwendijk.Commerce,
                            // .leviouwendijk.Compositions,
                            // .leviouwendijk.Concatenation,
                            // .leviouwendijk.Constructors,
                            // .leviouwendijk.CSS,
                            // .leviouwendijk.Cynology,
                            // .leviouwendijk.Difference,
                            // .leviouwendijk.DSL,
                            // .leviouwendijk.Economics,
                            // .leviouwendijk.Executable,
                            // .leviouwendijk.Extensions,
                            // .leviouwendijk.FileParsers,
                            // .leviouwendijk.FileTypes,
                            // .leviouwendijk.Fuzzy,
                            // .leviouwendijk.Graphical,
                            // .leviouwendijk.HTML,
                            // .leviouwendijk.ICS,
                            // .leviouwendijk.Implementations,
                            // .leviouwendijk.Indentation,
                            // .leviouwendijk.Interfaces,
                            // .leviouwendijk.JS,
                            // .leviouwendijk.Mail,
                            // .leviouwendijk.Matching,
                            // .leviouwendijk.Musica,
                            // .leviouwendijk.Parsers,
                            // .leviouwendijk.Parsing,
                            // .leviouwendijk.Partition,
                            // .leviouwendijk.Path,
                            // .leviouwendijk.plate,
                            // .leviouwendijk.Position,
                            // .leviouwendijk.PostgresConnector,
                            // .leviouwendijk.ProtocolComponents,
                            // .leviouwendijk.PSQL,
                            // .leviouwendijk.Ranking,
                            // .leviouwendijk.Readers,
                            // .leviouwendijk.Registry,
                            // .leviouwendijk.Selection,
                            // .leviouwendijk.Storable,
                            // .leviouwendijk.Strings,
                            // .leviouwendijk.Terminal,
                            // .leviouwendijk.TestFlows,
                            // .leviouwendijk.Tokens,
                            // .leviouwendijk.Version,
                            // .leviouwendijk.ViewComponents,
                            // .leviouwendijk.WebComponents,

                            // .apple.PklSwift,

                            // .awslabs.AWSBedrock,
                            // .awslabs.AWSBedrockRuntime,
                            // .smithyLang.Smithy,
                            // .smithyLang.SmithyJSON,

                            // .awslabs.AWSSESv2,
                            // .awslabs.AWSClientRuntime,
                            // .awslabs.AWSSDKIdentity,
                            // .awslabs.AWSSDKHTTPAuth,
                            // .smithyLang.SmithyHTTPAPI,
                            // .smithyLang.SmithyHTTPClient,
                            // .awslabs.AWSSTS,
                        ]
                    ),
                ]
            )

            \(deps_block)

            enum Libs {
                static let leviouwendijk = LeviOuwendijk()
                static let apple = Apple()
                static let awslabs = AWSLabs()
                static let smithyLang = SmithyLang()
            }

            struct LeviOuwendijk {
                let HTTP = Deps.Ref("HTTP")
                let Server = Deps.Ref("Server")
                let Milieu = Deps.Ref("Milieu")
                let Loggers = Deps.Ref("Loggers")
                let Cryptography = Deps.Ref("Cryptography")

                let Primitives = Deps.Ref("Primitives")
                let Methods = Deps.Ref("Methods")

                let Variables = Deps.Ref("Variables")
                let Writers = Deps.Ref("Writers")

                let Accounting = Deps.Ref("Accounting")
                let Agentic = Deps.Ref("Agentic")
                let AgenticAdapters = Deps.Ref("AgenticAdapters")
                let AgenticDomains = Deps.Ref("AgenticDomains")
                let AgenticInterfaces = Deps.Ref("AgenticInterfaces")
                let Allocators = Deps.Ref("Allocators")
                let ANSI = Deps.Ref("ANSI")
                let Arguments = Deps.Ref("Arguments")
                let AWSConnector = Deps.Ref("AWSConnector")
                let Capture = Deps.Ref("Capture")
                let Clipboard = Deps.Ref("Clipboard")
                let Commerce = Deps.Ref("Commerce")
                let Compositions = Deps.Ref("Compositions")
                let Concatenation = Deps.Ref("Concatenation")
                let Constructors = Deps.Ref("Constructors")
                let CSS = Deps.Ref("CSS")
                let Cynology = Deps.Ref("Cynology")
                let Difference = Deps.Ref("Difference")
                let DSL = Deps.Ref("DSL")
                let Economics = Deps.Ref("Economics")
                let Executable = Deps.Ref("Executable")
                let Extensions = Deps.Ref("Extensions")
                let FileParsers = Deps.Ref("FileParsers")
                let FileTypes = Deps.Ref("FileTypes")
                let Fuzzy = Deps.Ref("Fuzzy")
                let Graphical = Deps.Ref("Graphical")
                let HTML = Deps.Ref("HTML")
                let ICS = Deps.Ref("ICS")
                let Implementations = Deps.Ref("Implementations")
                let Indentation = Deps.Ref("Indentation")
                let Interfaces = Deps.Ref("Interfaces")
                let JS = Deps.Ref("JS")
                let Mail = Deps.Ref("Mail")
                let Matching = Deps.Ref("Matching")
                let Musica = Deps.Ref("Musica")
                let Parsers = Deps.Ref("Parsers")
                let Parsing = Deps.Ref("Parsing")
                let Partition = Deps.Ref("Partition")
                let Path = Deps.Ref("Path")
                let plate = Deps.Ref("plate")
                let Position = Deps.Ref("Position")
                let PostgresConnector = Deps.Ref("PostgresConnector")
                let ProtocolComponents = Deps.Ref("ProtocolComponents")
                let PSQL = Deps.Ref("PSQL")
                let Ranking = Deps.Ref("Ranking")
                let Readers = Deps.Ref("Readers")
                let Registry = Deps.Ref("Registry")
                let Selection = Deps.Ref("Selection")
                let Storable = Deps.Ref("Storable")
                let Strings = Deps.Ref("Strings")
                let Terminal = Deps.Ref("Terminal")
                let TestFlows = Deps.Ref("TestFlows")
                let Tokens = Deps.Ref("Tokens")
                let Version = Deps.Ref("Version")
                let ViewComponents = Deps.Ref("ViewComponents")
                let WebComponents = Deps.Ref("WebComponents")
            }

            struct Apple {
                let PklSwift = Deps.Ref(
                    repo: "pkl-swift",
                    package: "pkl-swift",
                    product: "PklSwift"
                )
            }

            struct AWSLabs {
                let awsSDKSwift = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift"
                )

                let AWSBedrock = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift",
                    product: "AWSBedrock"
                )

                let AWSBedrockRuntime = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift",
                    product: "AWSBedrockRuntime"
                )

                let AWSSESv2 = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift",
                    product: "AWSSESv2"
                )

                let AWSClientRuntime = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift",
                    product: "AWSClientRuntime"
                )

                let AWSSDKIdentity = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift",
                    product: "AWSSDKIdentity"
                )

                let AWSSDKHTTPAuth = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift",
                    product: "AWSSDKHTTPAuth"
                )

                let AWSSTS = Deps.Ref(
                    repo: "aws-sdk-swift",
                    package: "aws-sdk-swift",
                    product: "AWSSTS"
                )
            }

            struct SmithyLang {
                let smithySwift = Deps.Ref(
                    repo: "smithy-swift",
                    package: "smithy-swift"
                )

                let Smithy = Deps.Ref(
                    repo: "smithy-swift",
                    package: "smithy-swift",
                    product: "Smithy"
                )

                let SmithyJSON = Deps.Ref(
                    repo: "smithy-swift",
                    package: "smithy-swift",
                    product: "SmithyJSON"
                )

                let SmithyHTTPAPI = Deps.Ref(
                    repo: "smithy-swift",
                    package: "smithy-swift",
                    product: "SmithyHTTPAPI"
                )

                let SmithyHTTPClient = Deps.Ref(
                    repo: "smithy-swift",
                    package: "smithy-swift",
                    product: "SmithyHTTPClient"
                )
            }

            extension Package.Dependency {
                static var leviouwendijk: Deps.Packages<LeviOuwendijk> {
                    .init(
                        github: .init(owner: "leviouwendijk"),
                        catalog: Libs.leviouwendijk
                    )
                }

                static var apple: Deps.Packages<Apple> {
                    .init(
                        github: .init(owner: "apple"),
                        catalog: Libs.apple
                    )
                }

                static var awslabs: Deps.Packages<AWSLabs> {
                    .init(
                        github: .init(owner: "awslabs"),
                        catalog: Libs.awslabs
                    )
                }

                static var smithyLang: Deps.Packages<SmithyLang> {
                    .init(
                        github: .init(owner: "smithy-lang"),
                        catalog: Libs.smithyLang
                    )
                }
            }

            extension Target.Dependency {
                static var leviouwendijk: Deps.Products<LeviOuwendijk> {
                    .init(
                        github: .init(owner: "leviouwendijk"),
                        catalog: Libs.leviouwendijk
                    )
                }

                static var apple: Deps.Products<Apple> {
                    .init(
                        github: .init(owner: "apple"),
                        catalog: Libs.apple
                    )
                }

                static var awslabs: Deps.Products<AWSLabs> {
                    .init(
                        github: .init(owner: "awslabs"),
                        catalog: Libs.awslabs
                    )
                }

                static var smithyLang: Deps.Products<SmithyLang> {
                    .init(
                        github: .init(owner: "smithy-lang"),
                        catalog: Libs.smithyLang
                    )
                }
            }
            """
        }
    }
}
