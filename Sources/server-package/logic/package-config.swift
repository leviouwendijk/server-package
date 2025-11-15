import Foundation

struct PackageConfig {
    let name: String
    let version: Int
    
    var capitalizedName: String {
        name.capitalized
    }
    
    var versionPath: URL {
        URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(name)
            .appendingPathComponent("v\(version)")
    }
    
    var sourcePath: URL {
        versionPath.appendingPathComponent("Sources/\(capitalizedName)")
    }
}
