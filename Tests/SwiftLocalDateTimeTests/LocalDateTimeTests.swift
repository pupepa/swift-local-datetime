import XCTest

@testable import SwiftLocalDateTime

final class LocalDateTimeTests: XCTestCase {
  func testInitLocalDateTimeWithLocalDateAndLocalTime() {
    let localDate = LocalDate(year: 2021, month: 11, day: 15)!
    let localTime = LocalTime(hour: 7, minute: 55)!
    let localDateTime = LocalDateTime(localDate: localDate, localTime: localTime)

    XCTAssertNotNil(localDateTime)
    XCTAssertEqual(localDateTime.localDate, localDate)
    XCTAssertEqual(localDateTime.localTime, localTime)
  }

  func testInitLocalDateTimeWithYearAndMonthAndDayAndHourAndMinuteAndSecond() {
    let localDateTime = LocalDateTime(year: 2021, month: 3, day: 17, hour: 1, minute: 22, second: 33)!

    XCTAssertEqual(localDateTime.year, 2021)
    XCTAssertEqual(localDateTime.month, 3)
    XCTAssertEqual(localDateTime.day, 17)
    XCTAssertEqual(localDateTime.hour, 1)
    XCTAssertEqual(localDateTime.minute, 22)
    XCTAssertEqual(localDateTime.second, 33)
  }

  func testInitLocalDateTimeWithInvalidYearAndMonthAndDayAndHourAndMinuteAndSecond() {
    XCTAssertNil(LocalDateTime(year: 2021, month: 13, day: 17, hour: 1, minute: 22, second: 33))
    XCTAssertNil(LocalDateTime(year: 2021, month: 3, day: 17, hour: 1, minute: 22, second: 61))
  }

  func testInitLocalDateTimeWithDate() {
    // 2021-03-17 01:22:33+00:00
    let date = Date(timeIntervalSince1970: 1_615_944_153)
    let localDateTime = LocalDateTime(date: date, timeZone: TimeZone(secondsFromGMT: 0)!)

    XCTAssertEqual(localDateTime.year, 2021)
    XCTAssertEqual(localDateTime.month, 3)
    XCTAssertEqual(localDateTime.day, 17)
    XCTAssertEqual(localDateTime.hour, 1)
    XCTAssertEqual(localDateTime.minute, 22)
    XCTAssertEqual(localDateTime.second, 33)
  }

  func testDate() {
    let localDate = LocalDate(year: 2021, month: 11, day: 15)!
    let localTime = LocalTime(hour: 7, minute: 55)!
    let localDateTime = LocalDateTime(localDate: localDate, localTime: localTime)

    XCTAssertEqual(localDateTime.date(timeZone: TimeZone(secondsFromGMT: 0)!).timeIntervalSince1970, 1_636_962_900)
  }

  func testEquatable() {
    // 2021-03-17 01:22:33+00:00
    let date1 = LocalDateTime(date: Date(timeIntervalSince1970: 1_615_944_153), timeZone: TimeZone(secondsFromGMT: 0)!)
    let date2 = LocalDateTime(year: 2021, month: 3, day: 17, hour: 1, minute: 22, second: 33)

    XCTAssertEqual(date1, date2)
  }

  func testComparable() {
    let date1 = LocalDateTime(year: 2021, month: 3, day: 17, hour: 1, minute: 22, second: 33)!
    let date2 = LocalDateTime(year: 2021, month: 3, day: 17, hour: 1, minute: 22, second: 34)!

    XCTAssertTrue(date1 < date2)
  }

  func testHashable() {
    let dateTimes: Set<LocalDateTime> = [
      .init(year: 2021, month: 11, day: 18, hour: 1, minute: 2)!,
      .init(year: 2021, month: 11, day: 18, hour: 1, minute: 2)!,  // Duplicate value
      .init(year: 2021, month: 11, day: 18, hour: 1, minute: 3)!,
    ]

    XCTAssertEqual(dateTimes.count, 2)
  }
}
