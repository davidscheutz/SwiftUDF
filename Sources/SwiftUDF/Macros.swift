/// Declares an annotation that can be used to generate a Loop.
///
/// A `@Loop` generates the base class for the provided state and event type.
///
///
/// - Parameters:
///   - event: Specifies the type of events that the loop will process.
///   - state: Specifies the type of the state the loop will mutate.
@attached(peer, names: named(Singleton))
public macro Loop(
    in event: Any.Type,
    out state: Any.Type
) = #externalMacro(module: "SwiftUDFMacroPlugin", type: "LoopMacro")

/// Declares an annotation that can be used to specify a state.
///
/// A `@State` links the type to the provided views.
///
///
/// - Parameters:
///   - view: Specifies the type that the state will be linked to.
@attached(peer, names: named(Singleton))
public macro State(_ view: Any.Type) = #externalMacro(module: "SwiftUDFMacroPlugin", type: "StateMacro")

/// Declares an annotation that can be used to specify an event.
///
/// A `@Event` links the type to the provided views.
///
///
/// - Parameters:
///   - view: Specifies the type that the event will be linked to.
@attached(peer, names: named(Singleton))
public macro Event(_ view: Any.Type) = #externalMacro(module: "SwiftUDFMacroPlugin", type: "EventMacro")
