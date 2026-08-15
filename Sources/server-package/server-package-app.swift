import Arguments

enum ServerPackageApp:
    ArgumentCommand
{
    static let name = "server-package"

    static let defaultChild =
        ServerPackage.self

    static let children: [ArgumentCommandType] = [
        ServerPackage.self,
        UpdateDefaults.self,
    ]
}
