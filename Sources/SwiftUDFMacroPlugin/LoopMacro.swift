import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

// this should generate an extension confirming to the base type
// extension LoginLoop: ListLoopBaseGenerated {}
public struct LoopMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        /*
         Code generation is still done using Sourcery.
         Plan is to migrate functionality over to Swift macros over time.
         */
        return []
    }
}
