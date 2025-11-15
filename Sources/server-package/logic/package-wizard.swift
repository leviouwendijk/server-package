import Foundation
import ArgumentParser
import plate

struct PackageWizard {
    func present() async throws {
        print("\n" + "Server Package Generator".ansi(.bold) + "\n")
        
        let name = try promptForName()
        let version = try promptForVersion()
        
        displaySummary(name: name, version: version)
        let confirmed = try promptConfirm()
        
        guard confirmed else {
            print("Cancelled")
            return
        }
        
        let config = PackageConfig(name: name, version: version)
        try await createPackage(config: config, skipConfirm: true)
    }
    
    private func promptForName() throws -> String {
        print("Package name (lowercase): ", terminator: "")
        guard let input = readLine(), !input.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ValidationError("Package name required")
        }
        return input.lowercased()
    }
    
    private func promptForVersion() throws -> Int {
        print("Version number (default 1): ", terminator: "")
        if let input = readLine(), !input.isEmpty {
            guard let version = Int(input), version > 0 else {
                throw ValidationError("Version must be a positive integer")
            }
            return version
        }
        return 1
    }
    
    private func displaySummary(name: String, version: Int) {
        print("\n" + "Package Summary:".ansi(.bold))
        print("  Name: \(name)")
        print("  Version: v\(version)")
        print("  Path: \(name)/v\(version)/")
    }
    
    private func promptConfirm() throws -> Bool {
        print("\nProceed? (y/n): ", terminator: "")
        guard let input = readLine() else { return false }
        return input.lowercased() == "y" || input.lowercased() == "yes"
    }
}
