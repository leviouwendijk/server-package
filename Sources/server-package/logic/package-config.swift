import Foundation
import plate

struct PackageConfig {
    let name: String
    let version: Int

    let cwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    var cwdName: String { cwd.lastPathComponent }
    var version_string: String { "v\(version)" }
    
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
        convertIdentifier(name, to: .snake, separators: .commonWithDot)
        .replacingOccurrences(of: "_", with: "-")
    }
    
    var versionPath: URL {
        // If already in package root, don't add it again
        if cwdName.lowercased() == name.lowercased() {
            return cwd.appendingPathComponent(version_string)
        }

        // Otherwise, create package/vN structure
        return
            cwd
            .appendingPathComponent(hyphenatedName)
            .appendingPathComponent(version_string)
    }
    
    var sourcePath: URL {
        versionPath.appendingPathComponent("Sources/\(name)")
    }
}
