import Foundation
// import plate
import Writers
import Path

struct TemplateFile {
    let name: String
    let path: StandardPath
    let content: String
    
    func create(in basePath: URL) throws -> URL {
        let fullURL = path.url(base: basePath).appendingPathComponent(name)
        let safeFile = SafeFile(fullURL)
        let opts = SafeWriteOptions()
        try safeFile.write(content, options: opts)
        return fullURL
    }
}
