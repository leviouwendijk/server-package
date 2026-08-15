import Foundation

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
            let packageDependencies = ServerPackageDependencyRenderer.dynamicPackages(
                ServerPackageDependencyCatalog.minimal,
                indentation: 8
            )

            let targetDependencies = ServerPackageDependencyRenderer.dynamicProducts(
                ServerPackageDependencyCatalog.minimal,
                indentation: 16
            )

            let catalog = ServerPackageDependencyRenderer.dynamicCatalog(
                ServerPackageDependencyCatalog.minimal,
                indentation: 4
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

            \(deps_block)

            enum Libs {
                static let leviouwendijk = LeviOuwendijk()
            }

            struct LeviOuwendijk {
            \(catalog)
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
            let packageDependencies = ServerPackageDependencyRenderer.dynamicPackages(
                ServerPackageDependencyCatalog.full,
                indentation: 8
            )

            let targetDependencies = ServerPackageDependencyRenderer.dynamicProducts(
                ServerPackageDependencyCatalog.full,
                indentation: 16
            )

            let catalog = ServerPackageDependencyRenderer.dynamicCatalog(
                ServerPackageDependencyCatalog.full,
                indentation: 4
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

                    // .apple.package(Libs.apple.PklSwift, from: "0.2.1"),

                    // .awslabs.package(Libs.awslabs.awsSDKSwift, from: "1.0.0"),
                    // .smithyLang.package(Libs.smithyLang.smithySwift, from: "0.166.0"),
                ],
                targets: [
                    .executableTarget(
                        name: "\(options.packageName)",
                        dependencies: [
            \(targetDependencies)

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
            \(options.swiftTestsTarget)

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

            \(deps_block)

            enum Libs {
                static let leviouwendijk = LeviOuwendijk()
                static let apple = Apple()
                static let awslabs = AWSLabs()
                static let smithyLang = SmithyLang()
            }

            struct LeviOuwendijk {
            \(catalog)
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
