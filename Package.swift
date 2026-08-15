// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "server-package",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/leviouwendijk/plate.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Interfaces.git", branch: "master"),

        .package(url: "https://github.com/leviouwendijk/Path.git", branch: "master"),
        
        .package(url: "https://github.com/leviouwendijk/Difference.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Writers.git", branch: "master"),
        .package(url: "https://github.com/leviouwendijk/Arguments.git", branch: "master"),

        .package(url: "https://github.com/leviouwendijk/Variables.git", branch: "master"),

    ],
    targets: [
        .executableTarget(
            name: "server-package",
            dependencies: [
                .product(name: "plate", package: "plate"),
                .product(name: "Interfaces", package: "Interfaces"),

                .product(name: "Path", package: "Path"),

                .product(name: "Writers", package: "Writers"),
                .product(name: "Difference", package: "Difference"),
                .product(name: "Arguments", package: "Arguments"),

                .product(name: "Variables", package: "Variables")
            ]
        ),
    ]
)
