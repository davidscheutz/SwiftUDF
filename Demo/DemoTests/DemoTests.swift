import XCTest
@testable import Demo

final class DemoTests: XCTestCase {

    func test_increaseCounter() throws {
        let sut = CounterLoop()
        
        sut.handle(.increase)
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func test_changeIncrement() {
        let sut = CounterLoop()
        
        sut.handle(.incrementSelected(.byFive))
        
        XCTAssertEqual(sut.increment, .byFive)
    }
    
    func test_countNeverBelowZero() {
        let sut = CounterLoop()
        
        sut.handle(.incrementSelected(.byTen))
        sut.handle(.decrease)
        
        XCTAssertEqual(sut.count, 0)
    }
}
