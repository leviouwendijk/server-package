import Foundation
// import plate
import Variables

enum PackageManifestPolicy:
    String,
    Sendable,
    Codable,
    CaseIterable,
    Hashable
{
    case replace
    case backup
    case preserve
}

struct PackageConfig {
    let name: String
    let version: Int
    let style: PackageGenerationStyle
    let keepSwiftTests: Bool
    let throwingProcess: Bool
    let manifestPolicy: PackageManifestPolicy

    let cwd = URL(
        fileURLWithPath: FileManager.default.currentDirectoryPath
    )

    init(
        name: String,
        version: Int = 1,
        style: PackageGenerationStyle = .prose,
        keepSwiftTests: Bool = false,
        throwingProcess: Bool = false,
        manifestPolicy: PackageManifestPolicy = .replace
    ) {
        self.name = name
        self.version = version
        self.style = style
        self.keepSwiftTests = keepSwiftTests
        self.throwingProcess = throwingProcess
        self.manifestPolicy = manifestPolicy
    }

    var shouldKeepSwiftTests: Bool {
        keepSwiftTests
            || manifestPolicy == .preserve
    }

    var cwdName: String {
        cwd.lastPathComponent
    }

    var version_string: String {
        "v\(version)"
    }

    // var capitalizedName: String {
    //     name.capitalized
    // }

    var confirmable: String {
        var root = versionPath
        root.deleteLastPathComponent()

        let r = root.lastPathComponent
        let v = versionPath.lastPathComponent

        return "\(r)/\(v)"
    }

    var hyphenatedName: String {
        // convertIdentifier(
        //     name,
        //     to: .snake,
        //     separators: .commonWithDot
        // )
        // .replacingOccurrences(of: "_", with: "-")

        name.casing.kebab()
    }

    var versionPath: URL {
        // If already in package root, don't add it again
        if cwdName.lowercased() == name.lowercased() {
            return cwd.appendingPathComponent(
                version_string
            )
        }

        // Otherwise, create package/vN structure
        return cwd
            .appendingPathComponent(
                hyphenatedName
            )
            .appendingPathComponent(
                version_string
            )
    }

    var sourcePath: URL {
        versionPath.appendingPathComponent(
            "Sources/\(name)"
        )
    }
}
