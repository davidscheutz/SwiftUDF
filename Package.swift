// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUDF",
    platforms: [.iOS(.v14), .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUDF",
            targets: ["SwiftUDF"]),
    ],
    dependencies: [
        .package(url: "https://github.com/davidscheutz/SwiftEvolution.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SwiftUDF",
            dependencies: [
                .product(name: "SwiftEvolution", package: "SwiftEvolution")
            ]
        ),
    ]
)
