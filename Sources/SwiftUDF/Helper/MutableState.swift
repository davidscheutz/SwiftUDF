import Combine

public typealias MutableState<State> = CurrentValueSubject<State, Never>

extension MutableState {
    public func update(_ update: (Output) -> Output) {
        send(update(value))
    }
    
    public func await(_ update: @escaping () async -> Output) {
        Task { send(await update()) }
    }
}

extension MutableState where Output: RangeReplaceableCollection {
    public func append(_ element: Output.Element) {
        var update = value
        update.append(element)
        send(update)
    }
}
