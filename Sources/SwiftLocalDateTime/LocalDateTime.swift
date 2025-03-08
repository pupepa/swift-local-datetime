import Foundation

/// `LocalDateTime` represents a specific date and time.
public struct LocalDateTime: Codable, Sendable {
  public let localDate: LocalDate
  public let localTime: LocalTime

  /// Initializes a `LocalDateTime` with the specified date and time.
  /// - Parameters:
  ///   - localDate: The date.
  ///   - localTime: The time.
  public init(localDate: LocalDate, localTime: LocalTime) {
    self.localDate = localDate
    self.localTime = localTime
  }

  /// Initializes a `LocalDateTime` with the specified year, month, day, hour, minute, and second.
  /// - Parameters:
  ///   - year: The year.
  ///   - month: The month.
  ///   - day: The day.
  ///   - hour: The hour.
  ///   - minute: The minute.
  ///   - second: The second. Default is 0.
  public init?(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) {
    guard let localDate = LocalDate(year: year, month: month, day: day) else { return nil }
    guard let localTime = LocalTime(hour: hour, minute: minute, second: second) else { return nil }

    self.localDate = localDate
    self.localTime = localTime
  }

  /// Initializes a `LocalDateTime` with the specified `Date` and `TimeZone`.
  /// - Parameters:
  ///   - date: The reference date.
  ///   - timeZone: The time zone. Default is the current time zone.
  public init(date: Date, timeZone: TimeZone = .current) {
    self.localDate = LocalDate(date: date, timeZone: timeZone)
    self.localTime = LocalTime(date: date, timeZone: timeZone)
  }

  /// Returns a `Date` in the specified time zone.
  /// - Parameter timeZone: The time zone. Default is the current time zone.
  /// - Returns: The `Date` in the specified time zone.
  public func date(timeZone: TimeZone = .current) -> Date {
    let date = localDate.date(in: timeZone)
    return date.addingTimeInterval(TimeInterval(localTime.secondOfDay))
  }

  /// Returns the year.
  public var year: Int {
    localDate.year
  }

  /// Returns the month.
  public var month: Int {
    localDate.month
  }

  /// Returns the day.
  public var day: Int {
    localDate.day
  }

  /// Returns the hour.
  public var hour: Int {
    localTime.hour
  }

  /// Returns the minute.
  public var minute: Int {
    localTime.minute
  }

  /// Returns the second.
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
