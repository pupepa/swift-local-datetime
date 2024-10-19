import Foundation

public struct LocalDateTime: Codable, Sendable {
  public let localDate: LocalDate
  public let localTime: LocalTime

  public init(localDate: LocalDate, localTime: LocalTime) {
    self.localDate = localDate
    self.localTime = localTime
  }

  public init?(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) {
    guard let localDate = LocalDate(year: year, month: month, day: day) else { return nil }
    guard let localTime = LocalTime(hour: hour, minute: minute, second: second) else { return nil }

    self.localDate = localDate
    self.localTime = localTime
  }

  public init(date: Date, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
    self.localDate = LocalDate(date: date, timeZone: timeZone)
    self.localTime = LocalTime(date: date, timeZone: timeZone)
  }

  public func date(timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) -> Date {
    let date = localDate.date(in: timeZone)
    return date.addingTimeInterval(TimeInterval(localTime.secondOfDay))
  }

  public var year: Int {
    localDate.year
  }

  public var month: Int {
    localDate.month
  }

  public var day: Int {
    localDate.day
  }

  public var hour: Int {
    localTime.hour
  }

  public var minute: Int {
    localTime.minute
  }

  public var second: Int {
    localTime.second
  }
}

extension LocalDateTime: Equatable {
  public static func == (lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
    return lhs.localDate == rhs.localDate && lhs.localTime == rhs.localTime
  }
}

extension LocalDateTime: Comparable {
  public static func < (lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
    return lhs.date().timeIntervalSince1970 < rhs.date().timeIntervalSince1970
  }
}

extension LocalDateTime: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(localDate)
    hasher.combine(localTime)
  }
}
