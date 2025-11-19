import Foundation
import ArgumentParser
import plate

/// Which generated file(s) to update.
enum TemplateFileKind: String, CaseIterable, ExpressibleByArgument {
    case state
    // case runtime
    case app

    var filename: String {
        switch self {
        case .state:
            return "state.swift"
        // case .runtime:
        //     return "runtime.swift"
        case .app:
            return "app.swift"
        }
    }

    var legacyFilenames: [String] {
        switch self {
        case .state:
            return []
        case .app:
            return ["runtime.swift"]
        }
    }

    // func url(in sourceRoot: URL) -> URL {
    //     sourceRoot.appendingPathComponent(filename)
    // }

    func targetURL(in sourceRoot: URL) -> URL {
        sourceRoot.appendingPathComponent(filename)
    }

    func resolveExistingURL(in sourceRoot: URL, fm: FileManager = .default) -> URL? {
        let primary = targetURL(in: sourceRoot)
        if fm.fileExists(atPath: primary.path) {
            return primary
        }

        for name in legacyFilenames {
            let candidate = sourceRoot.appendingPathComponent(name)
            if fm.fileExists(atPath: candidate.path) {
                return candidate
            }
        }

        return nil
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
    var files: [TemplateFileKind] = [
        .state, 
        // .runtime
        .app
    ]

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
        let allKinds: [TemplateFileKind] = [
            .state, 
            // .runtime
            .app
        ]
        let kindsToProcess =
            selected.isEmpty
            ? allKinds
            : allKinds.filter { selected.contains($0) }

        if kindsToProcess.isEmpty {
            print("No files selected for update.")
            return
        }

        for kind in kindsToProcess {
            guard let existingURL = kind.resolveExistingURL(in: sourceRoot, fm: fm) else {
                print("Skipping \(kind.rawValue): no file found in \(sourceRoot.path)")
                continue
            }

            let targetURL = kind.targetURL(in: sourceRoot)

            try updateFile(
                kind: kind,
                existingURL: existingURL,
                targetURL: targetURL,
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
    case .app:
        return TemplateSet(
            previous: ServerPackageDefaults.App.previous,
            latest: ServerPackageDefaults.App.latest
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
    existingURL: URL,
    targetURL: URL,
    assumeYes: Bool,
    dryRun: Bool
) throws {
    let fm = FileManager.default

    let current = try String(contentsOf: existingURL, encoding: .utf8)
    let set = templates(for: kind)
    let previous = set.previous
    let latest = set.latest

    let sortedVersions = previous.keys.sorted()
    let latestVersion = (sortedVersions.last ?? 0) + 1

    let existingName = existingURL.lastPathComponent
    let targetName = targetURL.lastPathComponent

    if existingURL == targetURL, current == latest {
        print("Already up to date: \(existingName) (v\(latestVersion))")
        return
    }

    // Try to detect which template version this file matches.
    let match = previous.first { (_, template) in
        template == current
    }

    let fromVersion: Int?
    let diffOld: String
    let oldNameLabel: String
    let newNameLabel = "latest template v\(latestVersion)"

    if let (v, template) = match {
        fromVersion = v
        diffOld = template
        oldNameLabel = "template v\(v)"
        print("\n\(existingName): detected known server-package template v\(v) → v\(latestVersion)".ansi(.cyan))
    } else {
        fromVersion = nil
        diffOld = current
        oldNameLabel = "current file"
        print("\n\(existingName): does not match any known template; diffing against latest template v\(latestVersion).".ansi(.yellow))
    }

    let rawDiff = makeSimpleLineDiff(
        old: diffOld,
        new: latest,
        oldName: oldNameLabel,
        newName: newNameLabel
    )

    let hasTextDiff = !rawDiff.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

    if hasTextDiff {
        let colored = colorizeDiff(rawDiff)
        print("")
        print(colored)
        print("")
    } else {
        // No textual diff, but we might still be renaming (runtime.swift -> app.swift).
        if existingURL != targetURL && !fm.fileExists(atPath: targetURL.path) {
            print("No content changes, but will create \(targetName) from \(existingName).")
        } else {
            print("No textual differences detected for \(existingName).")
            if existingURL == targetURL {
                return
            }
        }
    }

    if dryRun {
        print("DRY RUN: no changes written for \(targetName).")
        return
    }

    // Confirmation for writing the new template
    if !assumeYes {
        if existingURL == targetURL {
            print("Apply changes to \(existingName)? (y/N): ", terminator: "")
        } else {
            print("Apply changes and write to \(targetName) (from \(existingName))? (y/N): ", terminator: "")
        }

        guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              input == "y" || input == "yes"
        else {
            print("Skipping \(existingName).")
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

    // Always write to the canonical target (state.swift / app.swift).
    let file = SafeFile(targetURL)
    let result = try file.write(latest, options: options)

    if let fromVersion {
        print("Updated \(targetName) from v\(fromVersion) -> v\(latestVersion). \(result)")
    } else {
        print("Updated \(targetName) to latest template v\(latestVersion). \(result)")
    }

    // --- extra step: suggest removing runtime.swift if app.swift now exists ---

    // Only relevant for the app entrypoint.
    guard kind == .app else { return }

    let runtimeURL = targetURL
        .deletingLastPathComponent()
        .appendingPathComponent("runtime.swift")

    guard fm.fileExists(atPath: runtimeURL.path) else {
        return
    }

    print("")
    print("You now have app.swift:".ansi(.green))
    print("  \(targetURL.path)".ansi(.green))
    print("")
    print("Which means you can remove runtime.swift:".ansi(.yellow))
    print("  \(runtimeURL.path)".ansi(.red))
    print("")

    if dryRun {
        print("DRY RUN: not removing runtime.swift.")
        return
    }

    if assumeYes {
        try? fm.removeItem(at: runtimeURL)
        print("Removed runtime.swift.")
        return
    }

    print("Remove runtime.swift? (y/N): ", terminator: "")
    let answer = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    if answer == "y" || answer == "yes" {
        try? fm.removeItem(at: runtimeURL)
        print("Removed runtime.swift.")
    } else {
        print("Keeping runtime.swift.")
    }
}
