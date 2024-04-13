import SwiftUI

extension Binding {
    public static func map<T>(
        from source: Value,
        event: @escaping (Value) -> T,
        handler: @escaping (T) -> Void
    ) -> Binding<Value> {
        .init(
            get: { source },
            set: { handler(event($0)) }
        )
    }
}
