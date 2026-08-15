struct ServerPackageDependency {
    enum DefaultState {
        case enabled
        case commented
    }

    let symbol: String
    let repo: String
    let package: String
    let product: String
    let state: DefaultState

    init(
        _ name: String,
        state: DefaultState = .commented
    ) {
        self.symbol = name
        self.repo = name
        self.package = name
        self.product = name
        self.state = state
    }

    init(
        symbol: String,
        repo: String,
        package: String? = nil,
        product: String? = nil,
        state: DefaultState = .commented
    ) {
        self.symbol = symbol
        self.repo = repo
        self.package = package ?? repo
        self.product = product ?? package ?? repo
        self.state = state
    }
}

struct ServerPackageDependencyGroup {
    let title: String?
    let dependencies: [ServerPackageDependency]
}

enum ServerPackageDependencyCatalog {
    static let core = ServerPackageDependencyGroup(
        title: nil,
        dependencies: [
            .init("HTTP", state: .enabled),
            .init("Server", state: .enabled),
            .init("Milieu", state: .enabled),
            .init("Loggers", state: .enabled),
        ]
    )

    static let implementationDefaults = ServerPackageDependencyGroup(
        title: "implementation defaults",
        dependencies: [
            .init("Authentication"),
            .init("Cryptography"),
            .init("PostgresConnector"),
            .init("IO"),
            .init("Processes"),
            .init("Assets"),
            .init("Media"),
            .init("Agentic"),
            .init("AgenticAdapters"),
            .init("AgenticDomains"),
            .init("AgenticInterfaces"),
        ]
    )

    static let optional = ServerPackageDependencyGroup(
        title: "other libraries",
        dependencies: [
            .init("Accounting"),
            .init("Allocators"),
            .init("ANSI"),
            .init("Arguments"),
            .init("AWSConnector"),
            .init("Capture"),
            .init("Clipboard"),
            .init("Commerce"),
            .init("Compositions"),
            .init("Concatenation"),
            .init("Constructors"),
            .init("CSS"),
            .init("Cynology"),
            .init("Difference"),
            .init("Drawingboard"),
            .init("DSL"),
            .init("Economics"),
            .init("Executable"),
            .init("Extensions"),
            .init("FileParsers"),
            .init("FileTypes"),
            .init("Fuzzy"),
            .init("Graphical"),
            .init("HTML"),
            .init("ICS"),
            .init("Implementations"),
            .init("Indentation"),
            .init("Interfaces"),
            .init("JS"),
            .init("LanguageModels"),
            .init("MacActor"),
            .init("Mail"),
            .init("Matching"),
            .init("Methods"),
            .init("Musica"),
            .init("Observability"),
            .init("Parsers"),
            .init("Parsing"),
            .init("Partition"),
            .init("Path"),
            .init("plate"),
            .init("Position"),
            .init("Primitives"),
            .init("ProtocolComponents"),
            .init("PSQL"),
            .init("Ranking"),
            .init("Readers"),
            .init("References"),
            .init("Registry"),
            .init("Selection"),
            .init("Storable"),
            .init("Strings"),
            .init("Structures"),
            .init("Surfaces"),
            .init("Terminal"),
            .init("TestFlows"),
            .init("Tokens"),
            .init("Vaporized"),
            .init("Variables"),
            .init("Version"),
            .init("ViewComponents"),
            .init("WebComponents"),
            .init("Writers"),
        ]
    )

    static let minimal = [
        core,
    ]

    static let full = [
        core,
        implementationDefaults,
        optional,
    ]

    static func flattened(
        _ groups: [ServerPackageDependencyGroup]
    ) -> [ServerPackageDependency] {
        groups.flatMap(\.dependencies)
    }
}

enum ServerPackageDependencyRenderer {
    static func dynamicPackages(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        renderGroups(
            groups,
            indentation: indentation
        ) { dependency in
            ".leviouwendijk.\(dependency.symbol),"
        }
    }

    static func dynamicProducts(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        dynamicPackages(
            groups,
            indentation: indentation
        )
    }

    static func prosePackages(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        renderGroups(
            groups,
            indentation: indentation
        ) { dependency in
            ".package(url: \"https://github.com/leviouwendijk/\(dependency.repo).git\", branch: \"master\"),"
        }
    }

    static func proseProducts(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        renderGroups(
            groups,
            indentation: indentation
        ) { dependency in
            ".product(name: \"\(dependency.product)\", package: \"\(dependency.package)\"),"
        }
    }

    static func dynamicCatalog(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        let prefix = String(
            repeating: " ",
            count: indentation
        )

        return ServerPackageDependencyCatalog
            .flattened(groups)
            .map { dependency in
                if dependency.symbol == dependency.repo,
                   dependency.package == dependency.repo,
                   dependency.product == dependency.repo {
                    return "\(prefix)let \(dependency.symbol) = Deps.Ref(\"\(dependency.repo)\")"
                }

                return """
                \(prefix)let \(dependency.symbol) = Deps.Ref(
                \(prefix)    repo: "\(dependency.repo)",
                \(prefix)    package: "\(dependency.package)",
                \(prefix)    product: "\(dependency.product)"
                \(prefix))
                """
            }
            .joined(
                separator: "\n"
            )
    }

    private static func renderGroups(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int,
        line: (ServerPackageDependency) -> String
    ) -> String {
        let prefix = String(
            repeating: " ",
            count: indentation
        )

        return groups
            .map { group in
                var lines: [String] = []

                if let title = group.title {
                    lines.append(
                        "\(prefix)// \(title)"
                    )
                }

                lines.append(
                    contentsOf: group.dependencies.map { dependency in
                        let comment = switch dependency.state {
                        case .enabled:
                            ""
                        case .commented:
                            "// "
                        }

                        return "\(prefix)\(comment)\(line(dependency))"
                    }
                )

                return lines.joined(
                    separator: "\n"
                )
            }
            .joined(
                separator: "\n\n"
            )
    }
}
