import Foundation

/// `LocalTime` represents a specific time.
public struct LocalTime: Codable, Sendable {
  public let hour: Int
  public let minute: Int
  public let second: Int

  /// Initializes a `LocalTime` with the specified hour, minute, and second.
  /// - Parameters:
  ///   - hour: The hour.
  ///   - minute: The minute.
  ///   - second: The second. Default is 0.
  public init?(hour: Int, minute: Int, second: Int = 0) {
    guard hour < 24 else { return nil }
    guard minute < 60 else { return nil }
    guard second < 60 else { return nil }

    self.hour = hour
    self.minute = minute
    self.second = second
  }

  /// Initializes a `LocalTime` with the specified minutes of the day.
  /// - Parameter minutesOfDay: The minutes of the day.
  public init?(minutesOfDay: Int) {
    guard minutesOfDay >= 0 else { return nil }
    guard minutesOfDay < 1440 else { return nil }

    self.init(hour: minutesOfDay / 60, minute: minutesOfDay % 60)
  }

  /// Initializes a `LocalTime` with the specified `Date` and `TimeZone`.
  /// - Parameters:
  ///   - date: The reference date.
  ///   - timeZone: The time zone. Default is the current time zone.
  public init(date: Date, timeZone: TimeZone = .current) {
    let dateFormatter = Self.dateFormatter
    dateFormatter.timeZone = timeZone

    dateFormatter.dateFormat = "HH"
    self.hour = Int(dateFormatter.string(from: date)) ?? 0

    dateFormatter.dateFormat = "mm"
    self.minute = Int(dateFormatter.string(from: date)) ?? 0

    dateFormatter.dateFormat = "ss"
    self.second = Int(dateFormatter.string(from: date)) ?? 0
  }

  private static let dateFormatter = DateFormatter()

  /// Initializes a `LocalTime` with the specified time string and `TimeZone`.
  /// - Parameters:
  ///   - timeString: The string representing the time.
  ///   - timeZone: The time zone. Default is the current time zone.
  public init?(timeString: String, timeZone: TimeZone = .current) {
    let range = NSRange(location: 0, length: timeString.count)

    if let result = try? NSRegularExpression(pattern: "(\\d{1,2}):{0,1}(\\d{2}):{0,1}(\\d{2})")
      .firstMatch(in: timeString, range: range)
    {
      guard let hour = Int((timeString as NSString).substring(with: result.range(at: 1))), hour < 24 else { return nil }
      guard let minute = Int((timeString as NSString).substring(with: result.range(at: 2))), minute < 60 else {
        return nil
      }
      guard let second = Int((timeString as NSString).substring(with: result.range(at: 3))), second < 60 else {
        return nil
      }

      self.init(hour: hour, minute: minute, second: second)
    } else if let result = try? NSRegularExpression(pattern: "(\\d{1,2}):{0,1}(\\d{2})")
      .firstMatch(in: timeString, range: range)
    {
      guard let hour = Int((timeString as NSString).substring(with: result.range(at: 1))), hour < 24 else { return nil }
      guard let minute = Int((timeString as NSString).substring(with: result.range(at: 2))), minute < 60 else {
        return nil
      }

      self.init(hour: hour, minute: minute)
    } else if let result = try? NSRegularExpression(pattern: "\\d{1,2}").firstMatch(in: timeString, range: range) {
      guard let minute = Int((timeString as NSString).substring(with: result.range(at: 0))) else { return nil }

      let time = LocalTime(date: .init(), timeZone: timeZone).time(byAdding: .minute, value: minute)

      self.init(hour: time.hour, minute: time.minute)
    } else {
      return nil
    }
  }

  /// Returns the time as a string.
  public var timeString: String {
    // FIXME: Support formats like 9:00 AM
    return "\(hourString):\(minuteString)"
  }

  /// Returns the hour as a string.
  public var hourString: String {
    return "\(hour < 10 ? "0" : "")\(hour)"
  }

  /// Returns the minute as a string.
  public var minuteString: String {
    return "\(minute < 10 ? "0" : "")\(minute)"
  }

  /// Returns the second as a string.
  public var secondString: String {
    return "\(second < 10 ? "0" : "")\(second)"
  }

  /// Returns a `Date` with the specified base date and time zone.
  /// - Parameters:
  ///   - baseDate: The base date. Default is January 1, 1970.
  ///   - timeZone: The time zone. Default is the current time zone.
  /// - Returns: The `Date` with the specified base date and time zone.
  public func date(with baseDate: Date = .init(timeIntervalSince1970: 0), timeZone: TimeZone = TimeZone.current) -> Date
  {
    let addedTimeInterval = TimeInterval(secondOfDay) - TimeInterval(timeZone.secondsFromGMT())
    return baseDate.addingTimeInterval(addedTimeInterval)
  }

  /// Returns the minutes of the day.
  public var minutesOfDay: Int {
    return (hour * 60) + minute
  }

  /// Returns the seconds of the day.
  public var secondOfDay: Int {
    return (hour * 60 * 60) + (minute * 60) + second
  }
}

extension LocalTime {
  /// Enumeration representing time components.
  public enum Component {
    case hour
    case minute
  }

  /// Returns a time by adding the specified component and value.
  /// - Parameters:
  ///   - component: The component to add.
  ///   - value: The value to add.
  /// - Returns: The time after adding the component and value.
  public func time(byAdding component: LocalTime.Component, value: Int) -> LocalTime {
    switch component {
    case .hour:
      let newHour = (hour + value) % 24

      return LocalTime(hour: newHour, minute: minute)!
    case .minute:
      let newHour = (hour + ((minute + value) / 60)) % 24
      let newMinute = (minute + value) % 60

      return LocalTime(hour: newHour, minute: newMinute)!
    }
  }
}

extension LocalTime {
  /// Returns the interval between two times in minutes.
  /// - Parameters:
  ///   - fromTime: The start time.
  ///   - toTime: The end time.
  /// - Returns: The interval in minutes.
  public static func interval(from fromTime: LocalTime, to toTime: LocalTime) -> Int {
    if fromTime > toTime {
      return ((toTime.hour + 24) * 60 + toTime.minute) - (fromTime.hour * 60 + fromTime.minute)
    }

    return (toTime.hour * 60 + toTime.minute) - (fromTime.hour * 60 + fromTime.minute)
  }
}

extension LocalTime: Equatable {
  public static func == (lhs: LocalTime, rhs: LocalTime) -> Bool {
    return lhs.secondOfDay == rhs.secondOfDay
  }
}

extension LocalTime: Comparable {
  public static func < (lhs: LocalTime, rhs: LocalTime) -> Bool {
    return lhs.secondOfDay < rhs.secondOfDay
  }
}

extension LocalTime: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(hour)
    hasher.combine(minute)
    hasher.combine(second)
  }
}
