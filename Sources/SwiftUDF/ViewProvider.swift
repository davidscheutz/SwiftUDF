public protocol ViewProvider {
    associatedtype State
    associatedtype Event

    var state: CurrentValuePublisher<State> { get }

    func handle(_ event: Event)
    
    /// called on view appear
    func start()
    
    /// called on view disappear
    func stop()
}
