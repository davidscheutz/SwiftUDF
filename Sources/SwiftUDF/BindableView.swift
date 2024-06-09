import SwiftUI

public protocol BindableView: View {
    associatedtype State
    associatedtype Event
    
    init(state: State, handler: @escaping (Event) -> Void)
}
