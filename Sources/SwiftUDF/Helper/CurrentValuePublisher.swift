import Combine

public protocol StatePublisher<Output>: Publisher where Failure == Never {
    var value: Output { get }
}

extension CurrentValueSubject: StatePublisher where Failure == Never {}

public class CurrentValuePublisher<Output>: Publisher {
    public typealias Output = Output
    public typealias Failure = Never
    
    private let source: any StatePublisher<Output>
    
    public init<T: StatePublisher>(_ source: T) where T.Output == Output {
        self.source = source
    }
    
    public var value: Output { source.value }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
        source.receive(subscriber: subscriber)
    }
}
