import XCTest

@testable import SwiftLocalDateTime

class YearTests: XCTestCase {
  func testYear() throws {
    XCTAssertEqual(Year(2021).year, 2021)
    XCTAssertEqual(Year(2021), Year(2021))
  }

  func testIsLeap() throws {
    XCTAssertTrue(Year(2020).isLeap)
    XCTAssertTrue(Year(2000).isLeap)
    XCTAssertFalse(Year(2021).isLeap)
    XCTAssertFalse(Year(2100).isLeap)
  }
}
