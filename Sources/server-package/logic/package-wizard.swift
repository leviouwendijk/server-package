import Arguments
import Foundation
import Terminal
import plate

struct PackageWizard {
    let defaultVersion: Int
    let defaultStyle: PackageGenerationStyle
    let keepSwiftTests: Bool
    let throwingProcess: Bool
    let manifestPolicy: PackageManifestPolicy

    init(
        defaultVersion: Int = 1,
        defaultStyle: PackageGenerationStyle = .prose,
        keepSwiftTests: Bool = false,
        throwingProcess: Bool = false,
        manifestPolicy: PackageManifestPolicy = .replace
    ) {
        self.defaultVersion = defaultVersion
        self.defaultStyle = defaultStyle
        self.keepSwiftTests = keepSwiftTests
        self.throwingProcess = throwingProcess
        self.manifestPolicy = manifestPolicy
    }

    func present() async throws {
        print(
            "\n"
            + "Server Package Generator".ansi(.bold)
            + "\n"
        )

        let name = try promptForName()
        let version = try promptForVersion()

        guard let style = try promptForStyle() else {
            cancel()
            return
        }

        guard let throwingProcess =
            try promptForThrowingProcess()
        else {
            cancel()
            return
        }

        guard let manifestPolicy =
            try promptForManifestPolicy()
        else {
            cancel()
            return
        }

        let config = PackageConfig(
            name: name,
            version: version,
            style: style,
            keepSwiftTests: keepSwiftTests,
            throwingProcess: throwingProcess,
            manifestPolicy: manifestPolicy
        )

        displaySummary(
            config: config
        )

        guard Terminal.confirm(
            "Proceed?",
            default: .no
        ) else {
            cancel()
            return
        }

        try await createPackage(
            config: config,
            skipConfirm: true
        )
    }

    private func promptForName() throws -> String {
        print(
            "Package name: ",
            terminator: ""
        )

        guard let input = readLine(),
              !input.trimmingCharacters(
                in: .whitespaces
              ).isEmpty
        else {
            throw ArgumentValidationError(
                "Package name required"
            )
        }

        return input
    }

    private func promptForVersion() throws -> Int {
        print(
            "Version number "
            + "(default \(defaultVersion)): ",
            terminator: ""
        )

        if let input = readLine(),
           !input.isEmpty {
            guard let version = Int(input),
                  version > 0
            else {
                throw ArgumentValidationError(
                    "Version must be a positive integer"
                )
            }

            return version
        }

        return defaultVersion
    }

    private func promptForStyle()
        throws -> PackageGenerationStyle?
    {
        try Terminal.choose(
            "Package.swift style",
            choices: [
                TerminalMenuItem(
                    id: PackageGenerationStyle.prose,
                    title: "Prose",
                    caption:
                        "Explicit standard SwiftPM syntax. "
                        + "Recommended default."
                ),
                TerminalMenuItem(
                    id: PackageGenerationStyle.dynamic,
                    title: "Dynamic",
                    caption:
                        "Helper-based dependency catalog syntax. "
                        + "Optional and experimental."
                ),
            ],
            default: defaultStyle
        )
    }

    private func promptForThrowingProcess()
        throws -> Bool?
    {
        try Terminal.choose(
            "Process mode",
            choices: [
                TerminalMenuItem(
                    id: false,
                    title: "Non-throwing",
                    caption:
                        "Generate await process.run(). "
                        + "The process handles and logs "
                        + "runtime failure."
                ),
                TerminalMenuItem(
                    id: true,
                    title: "Throwing",
                    caption:
                        "Generate try await "
                        + "process.throwing.run(). "
                        + "Runtime failure propagates."
                ),
            ],
            default: throwingProcess
        )
    }

    private func promptForManifestPolicy()
        throws -> PackageManifestPolicy?
    {
        try Terminal.choose(
            "Package.swift mutation",
            choices: [
                TerminalMenuItem(
                    id: PackageManifestPolicy.replace,
                    title: "Replace",
                    caption:
                        "Replace SwiftPM's Package.swift "
                        + "with the generated manifest. "
                        + "No backup."
                ),
                TerminalMenuItem(
                    id: PackageManifestPolicy.backup,
                    title: "Backup",
                    caption:
                        "Archive the original manifest at "
                        + ".bak/Package.swift, then replace it."
                ),
                TerminalMenuItem(
                    id: PackageManifestPolicy.preserve,
                    title: "Preserve",
                    caption:
                        "Leave SwiftPM's original "
                        + "Package.swift untouched."
                ),
            ],
            default: manifestPolicy
        )
    }

    private func displaySummary(
        config: PackageConfig
    ) {
        print(
            "\n"
            + "Package Summary:".ansi(.bold)
        )

        print("  Name: \(config.name)")
        print("  Version: v\(config.version)")
        print("  Style: \(config.style.rawValue)")

        print(
            "  Process: "
            + (
                config.throwingProcess
                ? "throwing"
                : "non-throwing"
            )
        )

        print(
            "  Package.swift: "
            + config.manifestPolicy.rawValue
        )

        print(
            "  Path: \(config.confirmable)"
        )

        print("")
    }

    private func cancel() {
        print("Cancelled")
    }
}
