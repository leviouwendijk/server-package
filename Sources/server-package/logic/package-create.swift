import Foundation
import plate
import Interfaces
import ArgumentParser

func createPackage(config: PackageConfig, skipConfirm: Bool) async throws {
    print("\nCreating package structure...\n")
    
    if FileManager.default.fileExists(atPath: config.versionPath.path) {
        print("Package directory already exists: \(config.versionPath.path)")
        if !skipConfirm {
            print("Overwrite? (y/n): ", terminator: "")
            guard let input = readLine(), input.lowercased() == "y" else {
                print("Cancelled")
                return
            }
        }
    }

    // Create version directory structure first
    try FileManager.default.createDirectory(
        at: config.versionPath,
        withIntermediateDirectories: true
    )
    print("✓ Directory structure created".ansi(.green))
    

    print("\nInitializing Swift package...")
    let shell = Shell(.zsh)
    var opts = Shell.Options()
    opts.cwd = config.versionPath
    opts.teeToStdout = true
    opts.teeToStderr = true
    
    let result = try await shell.run(
        "/usr/bin/swift",
        ["package", "init", "--type", "executable", "--name", config.name],
        options: opts
    )
    
    guard result.exitCode == 0 else {
        throw ValidationError("swift package init failed with code \(result.exitCode ?? -1)")
    }
    
    print("✓ Swift package initialized".ansi(.green))

    let defaultFile = config.versionPath
        .appendingPathComponent("Sources")
        .appendingPathComponent(config.name)
        .appendingPathComponent("\(config.name).swift")

    try? FileManager.default.removeItem(at: defaultFile)
    print("✓ Removed default file".ansi(.green))

    // Extract swift-tools-version from generated Package.swift
    let generatedPackagePath = config.versionPath.appendingPathComponent("Package.swift")
    let generatedContent = try String(contentsOf: generatedPackagePath, encoding: .utf8)
    
    guard let toolsVersionLine = generatedContent.split(separator: "\n").first(where: { $0.contains("swift-tools-version") }) else {
        throw ValidationError("Could not find swift-tools-version in generated Package.swift")
    }
    
    print("✓ Extracted swift-tools-version".ansi(.green))
    
    // Generate new Package.swift
    let packageContent = generatePackageSwift(
        toolsVersionLine: String(toolsVersionLine),
        packageName: config.name,
        macosVersion: "13"
    )
    
    let safeFile = SafeFile(generatedPackagePath)
    let package_opts = SafeWriteOptions(
        overrideExisting: true,
        makeBackupOnOverride: true,
        createBackupDirectory: false
    )
    try safeFile.write(packageContent, options: package_opts)
    print("✓ Generated Package.swift".ansi(.green))
    
    let template = PackageTemplate.standard(for: config)
    try template.files.forEach { file in
        let createdURL = try file.create(in: config.versionPath)
        print("✓ \(createdURL.path)".ansi(.green))
    }
    
    print("\nPackage created successfully!".ansi(.green))
    print("cd \(config.versionPath.path)")
    // print("vim Package.swift  (add dependencies)")
    // print("swuild\n")
}

private func generatePackageSwift(
    toolsVersionLine: String,
    packageName: String,
    macosVersion: String
) -> String {
    """
    \(toolsVersionLine)

    import PackageDescription

    let package = Package(
        name: "\(packageName)",
        platforms: [
            .macOS(.v\(macosVersion.replacingOccurrences(of: ".", with: "")))
        ],
        dependencies: [
            .package(url: "https://github.com/leviouwendijk/Server.git", branch: "master"),
            .package(url: "https://github.com/leviouwendijk/Milieu.git", branch: "master"),
            .package(url: "https://github.com/leviouwendijk/Loggers.git", branch: "master"),

            // .package(url: "https://github.com/leviouwendijk/Primitives.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Methods.git", branch: "master"),

            // .package(url: "https://github.com/leviouwendijk/Variables.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Writers.git", branch: "master"), // SafeFile writer

            // .package(url: "https://github.com/leviouwendijk/plate.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Structures.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Extensions.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Interfaces.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Parsers.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Constructors.git", branch: "master"),

            // .package(url: "https://github.com/leviouwendijk/Surfaces.git", branch: "master"),
            // .package(url: "https://github.com/leviouwendijk/Vaporized.git", branch: "master"),

            // .package(url: "https://github.com/apple/pkl-swift", from: "0.2.1"),

            // .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "1.0.0"),
            // .package(url: "https://github.com/smithy-lang/smithy-swift", from: "0.166.0"),
        ],
        targets: [
            .executableTarget(
                name: "\(packageName)",
                dependencies: [
                    .product(name: "Server", package: "Server"),
                    .product(name: "Milieu", package: "Milieu"),
                    .product(name: "Loggers", package: "Loggers"),

                    // .product(name: "Primitives", package: "Primitives"),
                    // .product(name: "Methods", package: "Methods"),

                    // .product(name: "Variables", package: "Variables"),
                    // .product(name: "Writers", package: "Writers"),

                    // .product(name: "plate", package: "plate"),
                    // .product(name: "Structures", package: "Structures"),
                    // .product(name: "Extensions", package: "Extensions"),
                    // .product(name: "Interfaces", package: "Interfaces"),
                    // .product(name: "Parsers", package: "Parsers"),
                    // .product(name: "Constructors", package: "Constructors"),

                    // .product(name: "Surfaces", package: "Surfaces"),
                    // .product(name: "Vaporized", package: "Vaporized"),

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
