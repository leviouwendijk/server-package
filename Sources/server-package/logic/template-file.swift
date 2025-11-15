import Foundation
import plate

struct TemplateFile {
    let name: String
    let path: ProjectPath
    let content: String
    
    func create(in basePath: URL) throws -> URL {
        let fullURL = path.url(base: basePath).appendingPathComponent(name)
        let safeFile = SafeFile(fullURL)
        let opts = SafeWriteOptions()
        try safeFile.write(content, options: opts)
        return fullURL
    }
}
