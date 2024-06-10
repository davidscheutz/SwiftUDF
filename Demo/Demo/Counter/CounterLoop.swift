import Foundation

/// @Loop(CounterState, CounterEvent)
final class CounterLoop: GeneratedBaseCounterLoop {
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
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds
            updateError(nil)
        }
    }
}
