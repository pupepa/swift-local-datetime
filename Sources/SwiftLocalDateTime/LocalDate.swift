import Foundation

/// `LocalDate` represents a specific date.
public struct LocalDate: Codable, Sendable {
  private let y: Year
  private let m: Month

  /// Returns the year.
  public var year: Int {
    y.year
  }

  /// Returns the month.
  public var month: Int {
    m.rawValue
  }

  /// Returns the day.
  public let day: Int

  /// Initializes a `LocalDate` with the specified `Date` and `TimeZone`.
  /// - Parameters:
  ///   - date: The reference date.
  ///   - timeZone: The time zone. Default is the current time zone.
  public init(date: Date, timeZone: TimeZone = .current) {
    let components = Self.calendar.dateComponents(in: timeZone, from: date)

    self.y = Year(components.year!)
    self.m = Month(rawValue: components.month!)!
    self.day = components.day!
  }

  /// Initializes a `LocalDate` with the specified string and `DateFormatter`.
  /// - Parameters:
  ///   - string: The string representing the date.
  ///   - formatter: The date formatter.
  public init?(string: String, formatter: DateFormatter) {
    guard let date = formatter.date(from: string) else { return nil }

    let components = formatter.calendar.dateComponents([.year, .month, .day], from: date)

    guard let year = components.year,
      let month = components.month,
      let day = components.day
    else { return nil }

    self.init(year: year, month: month, day: day)
  }

  /// Initializes a `LocalDate` with the specified year, month, and day.
  /// - Parameters:
  ///   - year: The year.
  ///   - month: The month.
  ///   - day: The day.
  public init?(year: Int, month: Int, day: Int) {
    let y = Year(year)
    guard let m = Month(rawValue: month), day <= m.numberOfDays(year: y) else { return nil }

    self.y = y
    self.m = m
    self.day = day
  }

  /// Returns a `Date` in the specified time zone.
  /// - Parameter timeZone: The time zone. Default is the current time zone.
  /// - Returns: The `Date` in the specified time zone.
  public func date(in timeZone: TimeZone = .current) -> Date {
    let dateComponents = DateComponents(
      calendar: Self.calendar,
      timeZone: timeZone,
      year: year,
      month: month,
      day: day
    )

    return dateComponents.date!
  }

  /// Returns a date string formatted with the specified `DateFormatter`.
  /// - Parameter formatter: The date formatter.
  /// - Returns: The formatted date string.
  public func dateString(with formatter: DateFormatter) -> String {
    formatter.string(from: self.date())
  }

  fileprivate static let timeZone = TimeZone(secondsFromGMT: 0)!

  fileprivate static let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = LocalDate.timeZone
    return calendar
  }()
}

extension LocalDate {
  /// Returns the first day of the month.
  public var firstDay: Self {
    let calendar = Self.calendar
    let components = calendar.dateComponents([.year, .month], from: self.date())

    return .init(date: calendar.date(from: components)!)
  }

  /// Returns the last day of the month.
  public var lastDay: Self {
    let calendar = Self.calendar
    return .init(date: calendar.date(byAdding: .init(month: 1, day: -1), to: firstDay.date())!)
  }
}

extension LocalDate {
  /// Returns the week.
  public var week: Week {
    Week(rawValue: Self.calendar.component(.weekday, from: self.date()))!
  }
}

extension LocalDate {
  /// Enumeration representing date components.
  public enum Component {
    case day
    case month
    case year
  }
}

extension LocalDate.Component {
  var calendarComponent: Calendar.Component {
    switch self {
    case .day: return .day
    case .month: return .month
    case .year: return .year
    }
  }
}

extension LocalDate {
  /// Returns the last day of the specified week.
  /// - Parameter week: The week.
  /// - Returns: The last day of the specified week.
  public func lastDay(of week: Week) -> LocalDate {
    let weekOfLastDate = Self.calendar.component(.weekday, from: self.lastDay.date())
    let dayDifference =
      (weekOfLastDate - week.rawValue) < 0 ? (weekOfLastDate + 7) - week.rawValue : weekOfLastDate - week.rawValue
    let lastDayOfWeek = Self.calendar.date(byAdding: .day, value: -dayDifference, to: self.lastDay.date())!

    return LocalDate(date: lastDayOfWeek)
  }
}

extension LocalDate {
  /// Returns the month interval between two dates.
  /// - Parameters:
  ///   - fromDate: The start date.
  ///   - toDate: The end date.
  /// - Returns: The month interval.
  public static func monthInterval(from fromDate: LocalDate, to toDate: LocalDate) -> Int {
    let fromDateYear = fromDate.year
    let fromDateMonth = fromDate.month
    let toDateYear = toDate.year
    let toDateMonth = toDate.month

    return (toDateYear - fromDateYear) * 12 + toDateMonth - fromDateMonth
  }

  /// Returns the day interval between two dates.
  /// - Parameters:
  ///   - fromDate: The start date.
  ///   - toDate: The end date.
  /// - Returns: The day interval.
  public static func dayInterval(from fromDate: LocalDate, to toDate: LocalDate) -> Int {
    Self.calendar.dateComponents([.day], from: fromDate.date(), to: toDate.date()).day ?? 0
  }
}

extension LocalDate {
  /// Returns a date by adding the specified component and value.
  /// - Parameters:
  ///   - component: The component to add.
  ///   - value: The value to add.
  /// - Returns: The date after adding the component and value.
  public func date(byAdding component: LocalDate.Component, value: Int) -> LocalDate {
    let date = Self.calendar.date(byAdding: component.calendarComponent, value: value, to: self.date())!

    return .init(date: date)
  }
}

extension LocalDate {
  /// Returns whether the date is a weekday.
  public var isWeekday: Bool {
    self.week.isWeekday
  }

  /// Returns whether the date is a weekend.
  public var isWeekend: Bool {
    self.week.isWeekend
  }
}

extension LocalDate: Equatable {
  public static func == (lhs: LocalDate, rhs: LocalDate) -> Bool {
    return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
  }
}

extension LocalDate: Comparable {
  public static func < (lhs: LocalDate, rhs: LocalDate) -> Bool {
    return lhs.date() < rhs.date()
  }
}

extension LocalDate: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(year)
    hasher.combine(month)
    hasher.combine(day)
  }
}
