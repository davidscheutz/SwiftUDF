public protocol BindableView {
    associatedtype State
    associatedtype Event
    
    init(state: State, handler: @escaping (Event) -> Void)
}
