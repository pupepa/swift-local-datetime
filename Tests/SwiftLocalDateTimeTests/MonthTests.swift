import XCTest
@testable import SwiftLocalDateTime

class MonthTests: XCTestCase {
    func testComparable() throws {
        XCTAssertEqual(Month.january, Month.january)
        XCTAssertGreaterThan(Month.july, Month.april)
    }
}
