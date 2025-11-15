import Foundation
import ArgumentParser

struct ServerPackage: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "server-package",
        abstract: "Create new Server-based package"
    )
    
    @Argument(help: "Package name (e.g., 'mailer')")
    var name: String?
    
    @Option(name: .shortAndLong, help: "Package version number (default: 1)")
    var version: Int?
    
    @Flag(name: .shortAndLong, help: "Skip confirmation prompts")
    var yes: Bool = false
    
    mutating func run() async throws {
        // If no args provided, launch wizard
        if name == nil && version == nil {
            let wizard = PackageWizard()
            try await wizard.present()
        } else {
            guard let name else { throw ValidationError("Name required") } 
            let config = PackageConfig(
                name: name,
                version: version ?? 1
            )
            try await createPackage(config: config, skipConfirm: yes)
        }
    }
}
