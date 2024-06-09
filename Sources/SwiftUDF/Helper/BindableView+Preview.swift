import Foundation
import SwiftUI

extension BindableView {
    public static func preview(_ state: State, title: String? = nil) -> some View {
        Self.init(state: state, handler: { _ in })
            .previewDisplayName(title)
    }
}
