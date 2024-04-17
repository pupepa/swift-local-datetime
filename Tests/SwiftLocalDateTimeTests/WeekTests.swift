import XCTest

@testable import SwiftLocalDateTime

class WeekTests: XCTestCase {
  func testComparable() throws {
    XCTAssertEqual(Week.sunday, Week.sunday)
    XCTAssertGreaterThan(Week.saturday, Week.wednesday)
  }
}
