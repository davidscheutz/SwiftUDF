import SwiftCompilerPlugin
import SwiftSyntaxMacros
import Foundation

@main
struct SwiftUDFMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LoopMacro.self,
        StateMacro.self,
        EventMacro.self
    ]
}
