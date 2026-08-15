import Arguments
import Foundation
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
        let style = try promptForStyle()

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

        let confirmed = try promptConfirm()

        guard confirmed else {
            print("Cancelled")
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
              ).isEmpty else {
            throw ArgumentValidationError(
                "Package name required"
            )
        }

        return input
    }

    private func promptForVersion() throws -> Int {
        print(
            "Version number (default \(defaultVersion)): ",
            terminator: ""
        )

        if let input = readLine(),
           !input.isEmpty {
            guard let version = Int(input),
                  version > 0 else {
                throw ArgumentValidationError(
                    "Version must be a positive integer"
                )
            }

            return version
        }

        return defaultVersion
    }

    private func promptForStyle() throws -> PackageGenerationStyle {
        print(
            "Package.swift style (prose/dynamic, default \(defaultStyle.rawValue)): ",
            terminator: ""
        )

        guard let input = readLine() else {
            return defaultStyle
        }

        let value = input
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .lowercased()

        guard !value.isEmpty else {
            return defaultStyle
        }

        guard let style = PackageGenerationStyle(
            rawValue: value
        ) else {
            throw ArgumentValidationError(
                "Style must be either 'prose' or 'dynamic'"
            )
        }

        return style
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
        print("  Package.swift: \(config.manifestPolicy.rawValue)")
        print("  Path: \(config.confirmable)")
    }

    private func promptConfirm() throws -> Bool {
        print(
            "\nProceed? (y/n): ",
            terminator: ""
        )

        guard let input = readLine() else {
            return false
        }

        return input.lowercased() == "y"
            || input.lowercased() == "yes"
    }
}
