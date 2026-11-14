import Foundation
import SwiftUI
import Combine

extension BindableView {
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
    
    // Plain `SwiftUI.State` storage instead of `@SwiftUI.State`: since the iOS/macOS 27 SDKs `State` is
    // also a macro, and its expansion breaks because this module declares its own `State` macro.
    private var stateStorage: SwiftUI.State<ChildView.State>
    private var providerStorage: SwiftUI.State<Provider>
    
    private let viewBuilder: (ChildView.State, @escaping (ChildView.Event) -> Void) -> ChildView
    
    init(provider: Provider, view: ChildView.Type) {
        stateStorage = .init(initialValue: provider.state.value)
        providerStorage = .init(initialValue: provider)
        viewBuilder = view.init
    }
    
    private var state: ChildView.State {
        get { stateStorage.wrappedValue }
        nonmutating set { stateStorage.wrappedValue = newValue }
    }
    
    private var provider: Provider {
        providerStorage.wrappedValue
    }
    
    var body: some View {
        viewBuilder(state, provider.handle(_:))
            .onReceive(provider.state.receiveOnMain().eraseToAnyPublisher()) { update($0) }
    }
    
    private func update(_ newState: ChildView.State) {
        state = newState
    }
}
