// deferred

// public struct DependencyPackage: Codable, Sendable {
//     public let package: String
//     public let product: String
//     public let enabled: Bool
    
//     public init(
//         package: String,
//         product: String,
//         enabled: Bool = false,
//     ) {
//         self.package = package
//         self.product = product
//         self.enabled = enabled
//     }

//     public init(
//         _ sharedName: String,
//         enabled: Bool = false,
//     ) {
//         self.package = sharedName
//         self.product = sharedName
//         self.enabled = enabled
//     }
// }

// public enum DependencyPackageRenderer {
//     internal static func indent(_ times: Int) -> String {
//         let single_indent = 4
//         let indent_spaces = times * single_indent
//         return String(repeating: " ", count: indent_spaces)
//     }

//     public enum render {
//         internal static func combine_string_elements(
//             indent: Int,
//             commented_out: Bool,
//             string_input: String
//         ) -> [String] {
//             var res: [String] = []
//             let spaces = DependencyPackageRenderer.indent(indent)
//             res.append(spaces)
//             if commented_out { 
//                 res.append("// ")
//             }
//             res.append(string_input)
//             return res
//         }

//         internal static func package_string(
//             named name: String,
//             branch: String = "master"
//         ) -> String {
//             return ".package(url: \"https://github.com/leviouwendijk/\(name).git\", branch: \"\(branch)\"),"
//         }

//         public static func package(
//             _ dependency: DependencyPackage,
//         ) -> String {
//             let str = package_string(named: dependency.package)
//             let line = combine_string_elements(
//                 indent: 2,
//                 commented_out: !dependency.enabled,
//                 string_input: str
//             )
//             return line.joined()
//         }

//         internal static func product_string(
//             name: String,
//             package: String
//         ) -> String {
//             return ".product(name: \"\(name)\", package: \"\(package)\"),"
//         }

//         public static func product(
//             _ dependency: DependencyPackage,
//         ) -> String {
//             let str = product_string(name: dependency.product, package: dependency.package)
//             let line = combine_string_elements(
//                 indent: 4,
//                 commented_out: !dependency.enabled,
//                 string_input: str
//             )
//             return line.joined()
//         }
//     }
// }

// internal enum DefaultDependencies {
//     static let leviouwendijk: [DependencyPackage] = [
//         .init("HTTP", enabled: true),
//         .init("Server", enabled: true),
//         .init("Milieu", enabled: true),
//         .init("Loggers", enabled: true),
//         .init("Cryptography"),

//         .init("Primitives"),
//         .init("Methods"),

//         .init("Variables"),
//         .init("Writers"),

//         .init("Accounting"),
//         .init("Agentic"),
//         .init("AgenticAdapters"),
//         .init("AgenticDomains"),
//         .init("AgenticInterfaces"),
//         .init("Allocators"),
//         .init("ANSI"),
//         .init("Arguments"),
//         .init("AWSConnector"),
//         .init("Capture"),
//         .init("Clipboard"),
//         .init("Commerce"),
//         .init("Compositions"),
//         .init("Concatenation"),
//         .init("Constructors"),
//         .init("CSS"),
//         .init("Cynology"),
//         .init("Difference"),
//         .init("DSL"),
//         .init("Economics"),
//         .init("Executable"),
//         .init("Extensions"),
//         .init("FileParsers"),
//         .init("FileTypes"),
//         .init("Fuzzy"),
//         .init("Graphical"),
//         .init("HTML"),
//         .init("ICS"),
//         .init("Implementations"),
//         .init("Indentation"),
//         .init("Interfaces"),
//         .init("JS"),
//         .init("Mail"),
//         .init("Matching"),
//         .init("Musica"),
//         .init("Parsers"),
//         .init("Parsing"),
//         .init("Partition"),
//         .init("Path"),
//         .init("plate"),
//         .init("Position"),
//         .init("PostgresConnector"),
//         .init("ProtocolComponents"),
//         .init("PSQL"),
//         .init("Ranking"),
//         .init("Readers"),
//         .init("Registry"),
//         .init("Selection"),
//         .init("Storable"),
//         .init("Strings"),
//         .init("Terminal"),
//         .init("TestFlows"),
//         .init("Tokens"),
//         .init("Version"),
//         .init("ViewComponents"),
//         .init("WebComponents"),
//     ]
// }
