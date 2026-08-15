import Arguments
import Foundation

extension PackageGenerationStyle: ArgumentValue {}

struct ServerPackageOptions:
    Sendable,
    ArgumentParsed
{
    typealias ArgumentPayload = Payload

    let name: String?
    let version: Int
    let style: PackageGenerationStyle
    let keepSwiftTests: Bool
    let yes: Bool

    init(
        arguments: Payload
    ) throws {
        let name = arguments.name
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        self.name = name.isEmpty
            ? nil
            : name

        self.version = arguments.version
        self.style = arguments.style
        self.keepSwiftTests = arguments.keepSwiftTests
        self.yes = arguments.yes
    }

    struct Payload: ArgumentGroup {
        @Arg(
            "name",
            help: "Package name, e.g. mailer.",
            default: ""
        )
        var name: String

        @Opt(
            "version",
            short: "v",
            default: 1,
            help: "Package version number."
        )
        var version: Int

        @Opt(
            "style",
            short: "s",
            default: .prose,
            help: "Package.swift generation style: prose or dynamic."
        )
        var style: PackageGenerationStyle

        @Flag(
            "keep-swift-tests",
            help: "Keep SwiftPM's generated Tests directory and test target."
        )
        var keepSwiftTests: Bool

        @Flag(
            "yes",
            short: "y",
            help: "Skip confirmation prompts."
        )
        var yes: Bool

        init() {}
    }
}

enum ServerPackage:
    ParsedArgumentCommand
{
    typealias Options = ServerPackageOptions

    static let name = "init"

    static func run(
        _ options: ServerPackageOptions,
        invocation: ParsedInvocation
    ) async throws {
        guard let name = options.name else {
            let wizard = PackageWizard(
                defaultVersion: options.version,
                defaultStyle: options.style,
                keepSwiftTests: options.keepSwiftTests
            )

            try await wizard.present()
            return
        }

        let config = PackageConfig(
            name: name,
            version: options.version,
            style: options.style,
            keepSwiftTests: options.keepSwiftTests
        )

        try await createPackage(
            config: config,
            skipConfirm: options.yes
        )
    }
}
