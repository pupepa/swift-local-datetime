import Foundation

/// `Week` represents the days of the week.
public enum Week: Int, CaseIterable, Codable, Sendable {
  case sunday = 1
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
}

extension Week: Comparable {
  public static func < (lhs: Week, rhs: Week) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

extension Week {
  /// Returns an array of weekdays.
  public static var weekday: [Week] {
    return [.monday, .tuesday, .wednesday, .thursday, .friday]
  }

  /// Returns an array of weekends.
  public static var weekend: [Week] {
    return [.saturday, .sunday]
  }

  /// Returns whether the day is a weekday.
  public var isWeekday: Bool {
    return Self.weekday.contains(self)
  }

  /// Returns whether the day is a weekend.
  public var isWeekend: Bool {
    return Self.weekend.contains(self)
  }
}

extension Week {
  /// Returns the current day of the week.
  public static var today: Week {
    let calendar: Calendar = {
      var calendar = Calendar(identifier: .gregorian)
      calendar.timeZone = .current
      calendar.locale = .current

      return calendar
    }()

    let weekday = calendar.component(.weekday, from: Date())

    return Week(rawValue: weekday)!
  }
}
