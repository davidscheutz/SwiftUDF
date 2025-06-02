import Foundation
import SwiftUDF

@Loop(in: CounterEvent.self, out: CounterState.self)
final class CounterLoop: CounterLoopBaseGenerated {
    init() {
        super.init(initial: .init(increment: .byOne, count: 0, error: nil))
    }
    
    override func incrementSelected(increment: Increment) {
        updateIncrement(increment)
    }
    
    override func increase() {
        updateCount(count + increment.rawValue)
    }
    
    override func decrease() {
        let updatedCount = count - increment.rawValue
        
        if updatedCount < 0 {
            update(count: 0, error: .update("A negative count isn't supported, reset to zero!"))
            resetErrorDelayed()
        } else {
            updateCount(updatedCount)
        }
    }
    
    override func reset() {
        update(increment: .byOne, count: 0, error: .reset)
    }
    
    // MARK: Helper
    
    private func resetErrorDelayed() {
        Task {
            try await Task.sleep(for: .seconds(2))
            updateError(nil)
        }
    }
}
