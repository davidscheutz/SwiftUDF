import Foundation

extension ViewProvider {
    /// Waits for a check to be true
    ///
    /// This function takes throws an exception if the check isn't true within the provided timeout duration.
    /// - Parameters:
    ///   - timeout: Seconds for the check to complete
    ///   - interval: Milliseconds between each check
    ///   - check: Completion executed on each interval with the current instance until it returns true or it times out
    public func wait(timeout: TimeInterval = 1, interval: UInt64 = 10, _ check:  @escaping (Self) -> Bool) async throws {
        try await waitFor(timeout: timeout, interval: interval) { check(self) }
    }
}

/// Waits for a check to be true
///
/// This function takes throws an exception if the check isn't true within the provided timeout duration.
/// - Parameters:
///   - timeout: Seconds for the check to complete
///   - interval: Milliseconds between each check
///   - check: Completion executed on each interval until it returns true or it times out
public func waitFor(timeout: TimeInterval = 1, interval: UInt64 = 10, _ check:  @escaping () -> Bool) async throws {
    let start = Date()
    
    try await _ = Task {
        while !check() {
            if Date().timeIntervalSince(start) > timeout {
                throw NSError(domain: "Timeout for wait check...", code: 0)
            }
            
            try await Task.sleep(nanoseconds: interval * 100_000_000) // seconds
        }
    }.value
}
