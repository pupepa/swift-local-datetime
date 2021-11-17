import XCTest
@testable import SwiftLocalDateTime

final class LocalDateTests: XCTestCase {
    private let japanDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ja-JP")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
}()

    private let usDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US")
        formatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()

    func testInitLocalDateWithDate() {
        // 2021-03-21 09:00:00+09:00
        let localDate = LocalDate(
            date: Date(timeIntervalSince1970: 1616284800),
            timeZone: .init(identifier: "Asia/Tokyo")!
        )

        XCTAssertNotNil(LocalDate(date: Date()))
        XCTAssertEqual(localDate.year, 2021)
        XCTAssertEqual(localDate.month, 3)
        XCTAssertEqual(localDate.day, 21)
    }

    func testInitLocalDateWithDate2() {
        // 2021-03-20 20:00:00-05:00
        let localDate = LocalDate(
            date: Date(timeIntervalSince1970: 1616284800),
            timeZone: .init(identifier: "America/New_York")!
        )

        XCTAssertNotNil(LocalDate(date: Date()))
        XCTAssertEqual(localDate.year, 2021)
        XCTAssertEqual(localDate.month, 3)
        XCTAssertEqual(localDate.day, 20)
    }

    func testInitLocalDateWithStringInJapan() {
        let formatter = japanDateFormatter
        let localDate = LocalDate(string: "2021-03-22", formatter: formatter)

        XCTAssertNotNil(localDate)
        XCTAssertEqual(localDate!.year, 2021)
        XCTAssertEqual(localDate!.month, 3)
        XCTAssertEqual(localDate!.day, 22)
    }

    func testInitLocalDateWithStringInUS() {
        let formatter = usDateFormatter
        let localDate = LocalDate(string: "2021-03-22", formatter: formatter)

        XCTAssertNotNil(localDate)
        XCTAssertEqual(localDate!.year, 2021)
        XCTAssertEqual(localDate!.month, 3)
        XCTAssertEqual(localDate!.day, 22)
    }

    func testInitLocalDateWithStringWithSplit() {
        let dateString = "2021-03-22"
        let dateComponents = dateString.split(separator: "-").map { Int($0)! }
        let localDate = LocalDate(year: dateComponents[0], month: dateComponents[1], day: dateComponents[2])

        XCTAssertNotNil(localDate)
        XCTAssertEqual(localDate!.year, 2021)
        XCTAssertEqual(localDate!.month, 3)
        XCTAssertEqual(localDate!.day, 22)
    }

    func testInitLocalDateWithInvalidString() {
        XCTAssertNil(LocalDate(string: "令和3年3月22日", formatter: japanDateFormatter))
    }

    func testInitLocalDateWithYMD() {
        let localDate = LocalDate(year: 2021, month: 12, day: 1)!

        XCTAssertEqual(localDate.year, 2021)
        XCTAssertEqual(localDate.month, 12)
        XCTAssertEqual(localDate.day, 1)
    }

    func testInitLocalDateWithInvalidYMD() {
        XCTAssertNil(LocalDate(year: 2021, month: 2, day: 29))
    }

    func testReturnsCorrectDateInJapan() {
        let localDate = LocalDate(string: "2021-01-01", formatter: japanDateFormatter)!

        // TimeZone = "+00:00"
        XCTAssertEqual(localDate.date().timeIntervalSince1970, 1609459200)
    }

    func testReturnsCorrectDateInUS() {
        let localDate = LocalDate(string: "2021-01-01", formatter: usDateFormatter)!

        // TimeZone = "+00:00"
        XCTAssertEqual(localDate.date().timeIntervalSince1970, 1609459200)
    }

    func testFirstDayOfJanuary() {
        let localDate = LocalDate(year: 2021, month: 1, day: 31)!

        XCTAssertEqual(
            localDate.firstDay.dateString(with: japanDateFormatter),
            "2021-01-01"
        )
    }

    func testFirstDayOfFebruary() {
        let localDate = LocalDate(year: 2024, month: 2, day: 29)!

        XCTAssertEqual(
            localDate.firstDay.dateString(with: japanDateFormatter),
            "2024-02-01"
        )
    }

    func testLastDayOfJanuary() {
        let localDate = LocalDate(year: 2021, month: 1, day: 1)!

        XCTAssertEqual(
            localDate.lastDay.dateString(with: japanDateFormatter),
            "2021-01-31"
        )
    }

    func testLastDayOfFebruary() {
        let localDate = LocalDate(year: 2024, month: 2, day: 5)!

        XCTAssertEqual(
            localDate.lastDay.dateString(with: japanDateFormatter),
            "2024-02-29"
        )
    }

    func testLastDayOfDecember() {
        let localDate = LocalDate(year: 2021, month: 12, day: 31)!

        XCTAssertEqual(
            localDate.lastDay.dateString(with: japanDateFormatter),
            "2021-12-31"
        )
    }

    func testWeekOfLocalDate() {
        let localDate = LocalDate(year: 2021, month: 12, day: 31)!

        XCTAssertEqual(localDate.week, .friday)
    }

    func testLastDayOfWeek() {
        let localDate = LocalDate(year: 2021, month: 1, day: 1)!

        XCTAssertEqual(localDate.lastDay(of: .monday), LocalDate(year: 2021, month: 1, day: 25))
        XCTAssertEqual(localDate.lastDay(of: .friday), LocalDate(year: 2021, month: 1, day: 29))
    }

    func testLastDayOfWeek2() {
        let localDate = LocalDate(year: 2021, month: 5, day: 1)!

        XCTAssertEqual(localDate.lastDay(of: .monday), LocalDate(year: 2021, month: 5, day: 31))
        XCTAssertEqual(localDate.lastDay(of: .tuesday), LocalDate(year: 2021, month: 5, day: 25))
    }

    func testMonthInterval() {
        let fromDate = LocalDate(year: 2021, month: 4, day: 1)!
        let toDate = LocalDate(year: 2021, month: 8, day: 20)!
        XCTAssertEqual(LocalDate.monthInterval(from: fromDate, to: toDate), 4)
    }

    func testMonthIntervalCrossYear() {
        let fromDate = LocalDate(year: 2021, month: 1, day: 1)!
        let toDate = LocalDate(year: 2022, month: 2, day: 28)!
        XCTAssertEqual(LocalDate.monthInterval(from: fromDate, to: toDate), 13)
    }

    func testDayInterval() {
        let fromDate = LocalDate(year: 2021, month: 2, day: 1)!
        let toDate = LocalDate(year: 2021, month: 2, day: 10)!

        XCTAssertEqual(LocalDate.dayInterval(from: fromDate, to: toDate), 9)
    }

    func testDayIntervalCrossMonth() {
        let fromDate = LocalDate(year: 2021, month: 2, day: 1)!
        let toDate = LocalDate(year: 2021, month: 3, day: 1)!

        XCTAssertEqual(LocalDate.dayInterval(from: fromDate, to: toDate), 28)
    }

    func testByAddingDay() {
        let fromDate = LocalDate(year: 2021, month: 3, day: 1)!
        let toDate = LocalDate(year: 2021, month: 3, day: 10)!

        XCTAssertEqual(fromDate.date(byAdding: .day, value: 9), toDate)
    }

    func testByAddingMonth() {
        let fromDate = LocalDate(year: 2021, month: 3, day: 10)!
        let toDate = LocalDate(year: 2021, month: 7, day: 10)!

        XCTAssertEqual(fromDate.date(byAdding: .month, value: 4), toDate)
    }

    func testByAddingYear() {
        let fromDate = LocalDate(year: 2021, month: 3, day: 10)!
        let toDate = LocalDate(year: 2025, month: 3, day: 10)!

        XCTAssertEqual(fromDate.date(byAdding: .year, value: 4), toDate)
    }

    func testIsWeekday() {
        // Wed
        XCTAssertTrue(LocalDate(year: 2021, month: 12, day: 1)!.isWeekday)
        // Sat
        XCTAssertFalse(LocalDate(year: 2021, month: 12, day: 4)!.isWeekday)
        // Sun
        XCTAssertFalse(LocalDate(year: 2021, month: 12, day: 5)!.isWeekday)
        // Thu
        XCTAssertTrue(LocalDate(year: 2024, month: 2, day: 29)!.isWeekday)
    }

    func testIsWeekend() {
        // Wed
        XCTAssertFalse(LocalDate(year: 2021, month: 12, day: 1)!.isWeekend)
        // Sat
        XCTAssertTrue(LocalDate(year: 2021, month: 12, day: 4)!.isWeekend)
        // Sun
        XCTAssertTrue(LocalDate(year: 2021, month: 12, day: 5)!.isWeekend)
        // Thu
        XCTAssertFalse(LocalDate(year: 2024, month: 2, day: 29)!.isWeekend)
    }

    func testIsEquatable() {
        XCTAssertEqual(
            LocalDate(string: "2021-03-22", formatter: japanDateFormatter)!,
            LocalDate(string: "2021-03-22", formatter: japanDateFormatter)!
        )

        XCTAssertNotEqual(
            LocalDate(string: "2021-03-21", formatter: japanDateFormatter)!,
            LocalDate(string: "2021-03-22", formatter: japanDateFormatter)!
        )
    }

    func testComparable() {
        XCTAssertLessThan(
            LocalDate(string: "2021-03-21", formatter: japanDateFormatter)!,
            LocalDate(string: "2021-03-22", formatter: japanDateFormatter)!
        )
    }

    func testHashable() {
        let localDates: Set<LocalDate> = [
            LocalDate(year: 2021, month: 11, day: 11)!,
            LocalDate(year: 2021, month: 11, day: 11)!, // Duplicate value
            LocalDate(year: 2021, month: 11, day: 12)!,
            LocalDate(year: 2021, month: 11, day: 13)!
        ]

        XCTAssertEqual(localDates.count, 3)
    }
}
