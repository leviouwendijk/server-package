import ArgumentParser

struct ServerPackageApp: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "server-package",
        abstract: "Create new Server-based process",
        subcommands: [
            ServerPackage.self,
        ],
        defaultSubcommand: ServerPackage.self
    )
}
