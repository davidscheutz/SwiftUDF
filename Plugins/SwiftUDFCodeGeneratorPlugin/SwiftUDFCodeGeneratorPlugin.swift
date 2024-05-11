import Foundation
import PackagePlugin

@main
struct SwiftUDFCodeGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands (context: PluginContext, target: Target) throws -> [Command] {
        []
    }
}

#if canImport (XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftUDFCodeGeneratorPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        [
            try sourcery(target: target, in: context)
        ]
    }
    
    private func sourcery(target: XcodeProjectPlugin.XcodeTarget, in context: XcodeProjectPlugin.XcodePluginContext) throws -> Command {
        let toolPath = try context.tool(named: "sourcery")
        let templatesPath = toolPath.path.removingLastComponent().removingLastComponent().appending("Templates")
        
        return command(
            for: target,
            executable: toolPath.path,
            templates: templatesPath.string,
            root: context.xcodeProject.directory,
            output: context.pluginWorkDirectory
        )
    }
    
    private func command(for target: XcodeTarget, executable: Path, templates: String, root: Path, output: Path) -> Command {
        Command.prebuildCommand(
            displayName: "SwiftUDF generate: \(target.displayName)",
            executable: executable,
            arguments: [
                "--templates",
                templates,
                "--args",
                "target=\(target.displayName)",
                "--sources",
                root.appending(subpath: target.displayName),
                "--output",
                output,
                "--parseDocumentation",
                "--disableCache",
                "--verbose"
            ],
            environment: [:],
            outputFilesDirectory: output
        )
    }
}
#endif
