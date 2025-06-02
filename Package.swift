// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftUDF",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "SwiftUDF", targets: ["SwiftUDF"]),
        .plugin(name: "SwiftUDFCodeGeneratorPlugin", targets: ["SwiftUDFCodeGeneratorPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/davidscheutz/SwiftEvolution.git", from: "0.0.1"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftUDF",
            dependencies: [
                .product(name: "SwiftEvolution", package: "SwiftEvolution"),
                .byNameItem(name: "SwiftUDFMacroPlugin", condition: nil)
            ]
        ),
        .macro(
            name: "SwiftUDFMacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .plugin(
            name: "SwiftUDFCodeGeneratorPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "SwiftUDFSourcery")
            ]
        ),
        .binaryTarget(
            name: "SwiftUDFSourcery",
            path: "Binaries/sourcery.artifactbundle"
        ),
    ]
)
