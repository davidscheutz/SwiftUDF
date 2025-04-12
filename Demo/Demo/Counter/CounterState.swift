import Foundation
import SwiftUDF

enum Increment: Int, CaseIterable, Identifiable {
    case byOne = 1
    case byFive = 5
    case byTen = 10
    
    var id: Int { rawValue }
    var display: String { "\(rawValue)" }
}

@State(CounterView.self)
struct CounterState {
    let increment: Increment
    let count: Int
    let error: String?
    
    var canReset: Bool {
        count > 0
    }
}

@Event(CounterView.self)
enum CounterEvent {
    case incrementSelected(_ increment: Increment)
    case increase
    case decrease
    case reset
}
