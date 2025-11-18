import Foundation
import ArgumentParser
import plate

/// Which generated file(s) to update.
enum TemplateFileKind: String, CaseIterable, ExpressibleByArgument {
    case state
    case runtime

    var filename: String {
        switch self {
        case .state:
            return "state.swift"
        case .runtime:
            return "runtime.swift"
        }
    }

    func url(in sourceRoot: URL) -> URL {
        sourceRoot.appendingPathComponent(filename)
    }
}

struct UpdateDefaults: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "update-defaults",
        abstract: "Update default Server runtime/state files in an existing package, with diff preview."
    )

    @Option(
        name: .shortAndLong,
        help: "Path to the package root (directory that contains Package.swift). Defaults to current directory."
    )
    var root: String?

    @Option(
        name: [.short, .customLong("file")],
        parsing: .upToNextOption,
        help: "Which files to update (state, runtime). Defaults to both."
    )
    var files: [TemplateFileKind] = [.state, .runtime]

    @Flag(
        name: .shortAndLong,
        help: "Skip confirmation prompts and apply all upgrades."
    )
    var yes: Bool = false

    @Flag(
        name: .shortAndLong,
        help: "Only show what would change; do not write any files."
    )
    var dryRun: Bool = false

    mutating func run() async throws {
        let fm = FileManager.default
        let rootURL = URL(fileURLWithPath: root ?? fm.currentDirectoryPath)

        let packageName = try detectPackageName(at: rootURL)
        let sourceRoot = rootURL
            .appendingPathComponent("Sources")
            .appendingPathComponent(packageName)

        let selected = Set(files)
        let allKinds: [TemplateFileKind] = [.state, .runtime]
        let kindsToProcess =
            selected.isEmpty
            ? allKinds
            : allKinds.filter { selected.contains($0) }

        if kindsToProcess.isEmpty {
            print("No files selected for update.")
            return
        }

        for kind in kindsToProcess {
            let url = kind.url(in: sourceRoot)
            try updateFile(
                kind: kind,
                at: url,
                assumeYes: yes,
                dryRun: dryRun
            )
        }
    }
}

// MARK: - Helpers

private func detectPackageName(at root: URL) throws -> String {
    let packageURL = root.appendingPathComponent("Package.swift")
    let contents = try String(contentsOf: packageURL, encoding: .utf8)

    guard let range = contents.range(of: "name: \"") else {
        throw ValidationError("Could not detect package name in Package.swift at \(packageURL.path)")
    }

    let start = range.upperBound
    guard let end = contents[start...].firstIndex(of: "\"") else {
        throw ValidationError("Malformed name line in Package.swift")
    }

    return String(contents[start..<end])
}

private struct TemplateSet {
    let previous: [ServerPackageDefaults.TemplateVersion: String]
    let latest: String
}

private func templates(for kind: TemplateFileKind) -> TemplateSet {
    switch kind {
    case .state:
        return TemplateSet(
            previous: ServerPackageDefaults.State.previous,
            latest: ServerPackageDefaults.State.latest
        )
    case .runtime:
        return TemplateSet(
            previous: ServerPackageDefaults.Runtime.previous,
            latest: ServerPackageDefaults.Runtime.latest
        )
    }
}

private func colorizeDiff(_ diff: String) -> String {
    diff
        .split(separator: "\n", omittingEmptySubsequences: false)
        .map { lineSub in
            let line = String(lineSub)
            if line.hasPrefix("---") || line.hasPrefix("+++") {
                return line.ansi(.yellow)
            } else if line.hasPrefix(" - ") {
                return line.ansi(.red)
            } else if line.hasPrefix(" + ") {
                return line.ansi(.green)
            } else {
                return line
            }
        }
        .joined(separator: "\n")
}

private func updateFile(
    kind: TemplateFileKind,
    at url: URL,
    assumeYes: Bool,
    dryRun: Bool
) throws {
    let fm = FileManager.default

    guard fm.fileExists(atPath: url.path) else {
        print("Skipping \(url.path) (file not found)")
        return
    }

    let current = try String(contentsOf: url, encoding: .utf8)
    let set = templates(for: kind)
    let previous = set.previous
    let latest = set.latest

    let sortedVersions = previous.keys.sorted()
    let latestVersion = (sortedVersions.last ?? 0) + 1

    if current == latest {
        print("Already up to date: \(url.lastPathComponent) (v\(latestVersion))")
        return
    }

    // Try to detect which template version this file matches.
    let match = previous.first { (_, template) in
        template == current
    }

    let fileName = url.lastPathComponent

    let fromVersion: Int?
    let diffOld: String
    let oldNameLabel: String
    let newNameLabel = "latest template v\(latestVersion)"

    if let (v, template) = match {
        fromVersion = v
        diffOld = template
        oldNameLabel = "template v\(v)"
        print("\n\(fileName): detected known server-package template v\(v) → v\(latestVersion)".ansi(.cyan))
    } else {
        fromVersion = nil
        diffOld = current
        oldNameLabel = "current file"
        print("\n\(fileName): does not match any known template; diffing against latest template v\(latestVersion).".ansi(.yellow))
    }

    // Build a simple line diff between "old" and "latest".
    let rawDiff = makeSimpleLineDiff(
        old: diffOld,
        new: latest,
        oldName: oldNameLabel,
        newName: newNameLabel
    )

    if rawDiff.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        print("No textual differences detected for \(fileName).")
        return
    }

    let colored = colorizeDiff(rawDiff)
    print("")
    print(colored)
    print("")

    if dryRun {
        print("DRY RUN: no changes written for \(fileName).")
        return
    }

    // Confirmation
    if !assumeYes {
        print("Apply changes to \(fileName)? (y/N): ", terminator: "")
        guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              input == "y" || input == "yes"
        else {
            print("Skipping \(fileName).")
            return
        }
    }

    let options = SafeWriteOptions(
        overrideExisting: true,
        makeBackupOnOverride: true,
        whitespaceOnlyIsBlank: false,
        backupSuffix: "_previous_version.bak",
        addTimestampIfBackupExists: true,
        createIntermediateDirectories: true,
        atomic: true,
        createBackupDirectory: true,
        backupDirectoryName: "safe-file-backups",
        backupSetPrefix: "server-defaults_",
        maxBackupSets: 10
    )

    let file = SafeFile(url)
    let result = try file.write(latest, options: options)

    if let fromVersion {
        print("Updated \(fileName) from v\(fromVersion) -> v\(latestVersion). \(result)")
    } else {
        print("Updated \(fileName) to latest template v\(latestVersion). \(result)")
    }
}
