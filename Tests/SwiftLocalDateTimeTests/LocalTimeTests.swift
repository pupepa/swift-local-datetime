import XCTest
@testable import SwiftLocalDateTime

class LocalTimeTests: XCTestCase {
    func testInitializeWithHourAndMinuteAndSecond() {
        let time = LocalTime(hour: 1, minute: 2, second: 3)!
        XCTAssertNotNil(time)
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 2)
        XCTAssertEqual(time.second, 3)
    }

    func testInitializeWithHourAndMinute() {
        let time = LocalTime(hour: 1, minute: 2)
        XCTAssertNotNil(time)
        XCTAssertEqual(time!.hour, 1)
        XCTAssertEqual(time!.minute, 2)
    }

    func testInitializeWithInvalidHour() {
        let time = LocalTime(hour: 24, minute: 2)
        XCTAssertNil(time)
    }

    func testInitializeWithInvalidMinute() {
        let time = LocalTime(hour: 23, minute: 60)
        XCTAssertNil(time)
    }

    func testInitializeWithInvalidSecond() {
        let time = LocalTime(hour: 23, minute: 59, second: 60)
        XCTAssertNil(time)
    }

    func testInitializeWithMinutesOfDay() {
        let time = LocalTime(minutesOfDay: 100)!
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 40)
        XCTAssertEqual(time.second, 0)
    }

    func testInitializeWithMinutesOfDayMin() {
        let time = LocalTime(minutesOfDay: 0)!
        XCTAssertEqual(time.hour, 0)
        XCTAssertEqual(time.minute, 0)
        XCTAssertEqual(time.second, 0)
    }

    func testInitializeWithMinutesOfDayMax() {
        let time = LocalTime(minutesOfDay: 1439)!
        XCTAssertEqual(time.hour, 23)
        XCTAssertEqual(time.minute, 59)
        XCTAssertEqual(time.second, 0)
    }

    func testInitializeWithInvalidMinutesOfDay() {
        XCTAssertNil(LocalTime(minutesOfDay: -1))
        XCTAssertNil(LocalTime(minutesOfDay: 1440))
    }

    func testInitializeLocalTime() {
        // 2022-01-01 01:02:03+00:00
        let date = Date(timeIntervalSince1970: 1640998923)
        let localTime = LocalTime(date: date, timeZone: TimeZone(secondsFromGMT: 0)!)
        XCTAssertEqual(localTime, LocalTime(hour: 1, minute: 2, second: 3))
    }

    func testInitializeWithHHMMSS() {
        let timeString = "01:02:03"
        let time = LocalTime(timeString: timeString)!

        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 2)
        XCTAssertEqual(time.second, 3)
    }

    func testInitializeWithInvalidHHMMSS() {
        XCTAssertNil(LocalTime(timeString: "25:00:00"))
        XCTAssertNil(LocalTime(timeString: "20:61:00"))
        XCTAssertNil(LocalTime(timeString: "20:01:61"))
    }

    func testInitializeWithHHMMSSWithoutColon() {
        let timeString = "202122"
        let time = LocalTime(timeString: timeString)!

        XCTAssertEqual(time.hour, 20)
        XCTAssertEqual(time.minute, 21)
        XCTAssertEqual(time.second, 22)
    }

    func testInitializeWithHHMM() {
        let timeString = "01:02"
        let time = LocalTime(timeString: timeString)!

        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 2)
    }

    func testInitializeWithInvalidHHMM() {
        XCTAssertNil(LocalTime(timeString: "25:00"))
        XCTAssertNil(LocalTime(timeString: "20:61"))
    }

    func testInitializeWithHHMMWithoutColon() {
        let timeString = "1235"
        let time = LocalTime(timeString: timeString)!

        XCTAssertEqual(time.hour, 12)
        XCTAssertEqual(time.minute, 35)
    }

    func testInitializeWithHMMWithoutColon() {
        let timeString = "935"
        let time = LocalTime(timeString: timeString)!

        XCTAssertEqual(time.hour, 9)
        XCTAssertEqual(time.minute, 35)
    }

    func testInitializeWithNumber() {
        let numberString = "70"
        let time = LocalTime(timeString: numberString)!

        XCTAssertNotNil(time)
    }

    func testString() {
        let time = LocalTime(hour: 3, minute: 4, second: 5)!
        XCTAssertEqual(time.hourString, "03")
        XCTAssertEqual(time.minuteString, "04")
        XCTAssertEqual(time.secondString, "05")
    }

    func testString2() {
        let time = LocalTime(hour: 14, minute: 25, second: 36)!
        XCTAssertEqual(time.hourString, "14")
        XCTAssertEqual(time.minuteString, "25")
        XCTAssertEqual(time.secondString, "36")
    }

    func testDate() {
        let time = LocalTime(hour: 14, minute: 25, second: 36)!

        XCTAssertEqual(time.date().timeIntervalSince1970, 19536)
    }

    func testMinutedOfDay() {
        let time = LocalTime(hour: 1, minute: 30)!
        XCTAssertEqual(time.minutesOfDay, 90)
    }

    func testSecondOfDay() {
        let time = LocalTime(hour: 1, minute: 30, second: 45)!
        XCTAssertEqual(time.secondOfDay, 5445)
    }

    func testLocalTimeByAddingHour() {
        let time = LocalTime(hour: 15, minute: 48)!.time(byAdding: .hour, value: 1)

        XCTAssertEqual(time.hour, 16)
    }

    func testLocalTimeByAddingHourCrossDay() {
        let time = LocalTime(hour: 23, minute: 48)!.time(byAdding: .hour, value: 1)

        XCTAssertEqual(time.hour, 0)
    }

    func testLocalTimeByAddingMinute() {
        let time = LocalTime(hour: 15, minute: 48)!.time(byAdding: .minute, value: 1)

        XCTAssertEqual(time.minute, 49)
    }

    func testLocalTimeByAddingMinuteCrossHour() {
        let time = LocalTime(hour: 15, minute: 58)!.time(byAdding: .minute, value: 10)

        XCTAssertEqual(time.hour, 16)
        XCTAssertEqual(time.minute, 8)
    }

    func testLocalTimeByAddingMinuteCrossDay() {
        let time = LocalTime(hour: 22, minute: 5)!.time(byAdding: .minute, value: 180)

        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 5)
    }

    func testLocalTimeInterval() {
        let fromTime = LocalTime(hour: 3, minute: 10)!
        let toTime = LocalTime(hour: 3, minute: 40)!

        XCTAssertEqual(LocalTime.interval(from: fromTime, to: toTime), 30)
    }

    func testLocalTimeIntervalCrossDay() {
        let fromTime = LocalTime(hour: 23, minute: 10)!
        let toTime = LocalTime(hour: 1, minute: 5)!

        XCTAssertEqual(LocalTime.interval(from: fromTime, to: toTime), 115)
    }

    func testEquatable() {
        XCTAssertEqual(
            LocalTime(hour: 3, minute: 4, second: 5)!,
            LocalTime(timeString: "03:04:05")!
        )

        XCTAssertNotEqual(
            LocalTime(hour: 1, minute: 2, second: 3)!,
            LocalTime(timeString: "03:04:05")!
        )
    }

    func testComparable() {
        XCTAssertLessThan(LocalTime(hour: 1, minute: 2, second: 3)!, LocalTime(timeString: "03:04:05")!)
        XCTAssertLessThan(LocalTime(hour: 1, minute: 2, second: 10)!, LocalTime(hour: 1, minute: 2, second: 20)!)
    }

    func testHashable() {
        let times: Set<LocalTime> = [
            LocalTime(hour: 1, minute: 2)!,
            LocalTime(hour: 1, minute: 2)!, // Duplicate value
            LocalTime(hour: 2, minute: 3)!,
        ]

        XCTAssertEqual(times.count, 2)
    }
}
