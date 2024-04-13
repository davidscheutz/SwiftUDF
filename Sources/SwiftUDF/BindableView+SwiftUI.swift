import Foundation
import SwiftUI
import Combine

extension View where Self: BindableView {
    public static func create<Provider: ViewProvider>(using provider: Provider) -> some View
        where Provider.State == State, Provider.Event == Event
    {
        BindableContainerView(provider: provider, view: Self.self)
            .onAppear { provider.start() }
            .onDisappear { provider.stop() }
    }
}

fileprivate struct BindableContainerView<Provider: ViewProvider, ChildView: BindableView & View>: View
    where ChildView.State == Provider.State, ChildView.Event == Provider.Event {
    
    @State private var state: ChildView.State
    @State private var provider: Provider
    
    private let viewBuilder: (ChildView.State, @escaping (ChildView.Event) -> Void) -> ChildView
    
    init(provider: Provider, view: ChildView.Type) {
        _state = .init(initialValue: provider.state.value)
        _provider = .init(initialValue: provider)
        viewBuilder = view.init
    }
    
    var body: some View {
        viewBuilder(state, provider.handle(_:))
            .onReceive(provider.state.receive(on: RunLoop.main).eraseToAnyPublisher()) { newState in
                if Thread.isMainThread {
                    update(newState)
                } else {
                    DispatchQueue.main.async { self.update(newState) }
                }
            }
    }
    
    private func update(_ newState: ChildView.State) {
        state = newState
    }
}
