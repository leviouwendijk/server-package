import Foundation

/// Central source of truth for the generated server defaults, including older revisions
/// that we are allowed to auto-migrate.
enum ServerPackageDefaults {
    typealias TemplateVersion = Int

    enum State {
        static let previous : [TemplateVersion: String] = [
            1: """
            import Server

            let config = ServerConfig.externallyManagedProcess()
            """,

            2: """
            import Server
            import plate

            let config = ServerConfig.externallyManagedProcess(logLevel: .info)
            let logger = try? StandardLogger(name: config.name, minimumLevel: config.logLevel)
            """,
        ]

        /// Latest state.swift template (current default).
        // moved from import plate -> import Loggers (new lib)
        static let latest: String = """
        import Server
        import Loggers

        let config = ServerConfig.externallyManagedProcess(logLevel: .info)
        let logger = try? StandardLogger(
            name: config.name,
            minimumLevel: config.logLevel,
            writeMode: .reset()
        )
        let activity: HTTPActivityCallback? = try? ServerActivityLog.files(minimumLevel: config.logLevel)
        """

        /// All templates we consider "safe to auto-upgrade from".
        static var upgradeable: [String] {
            previous.map { $1 }
        }
    }

    // enum Runtime {
    enum App {
        static let previous : [TemplateVersion: String] = [
            1: """
            import Server

            @main
            struct AppRuntime {
                static func main() async throws {
                    let process = ServerProcess(
                        config: config,
                        routes: try routes()
                    )
                    await process.run()
                }
            }
            """,

            2: """
            import Server

            @main
            struct AppRuntime {
                static func main() async throws {
                    let process = ServerProcess(
                        config: config,
                        routes: try routes(),
                        logger: logger
                    )
                    await process.run()
                }
            }
            """,

            3: """
            import Server

            @main
            struct AppRuntime {
                static func main() async throws {
                    let process = ServerProcess(
                        config: config,
                        routes: try routes(),
                        logger: logger,
                        activity: activity
                    )
                    await process.run()
                }
            }
            """
        ]

        /// Latest runtime.swift template (the one you showed with `activity` + `logger`).
        static let latest: String = """
        import Server

        @main
        struct App {
            static func main() async throws {
                let process = ServerProcess(
                    config: config,
                    routes: try routes(),
                    logger: logger,
                    activity: activity
                )
                await process.run()
            }
        }
        """

        static var upgradeable: [String] {
            previous.map { $1 }
        }
    }
}
