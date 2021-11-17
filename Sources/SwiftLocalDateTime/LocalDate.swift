import Foundation

public final class LocalDate {
    private let y: Year
    private let m: Month

    public var year: Int {
        y.year
    }

    public var month: Int {
        m.rawValue
    }

    public let day: Int

    public init(date: Date, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        let components = Self.calendar.dateComponents(in: timeZone, from: date)

        self.y = Year(components.year!)
        self.m = Month(rawValue: components.month!)!
        self.day = components.day!
    }

    public convenience init?(string: String, formatter: DateFormatter) {
        guard let date = formatter.date(from: string) else { return nil }

        let components = formatter.calendar.dateComponents([.year, .month, .day], from: date)

        guard let year = components.year,
              let month = components.month,
              let day = components.day else { return nil }

        self.init(year: year, month: month, day: day)
    }

    public init?(year: Int, month: Int, day: Int) {
        let y = Year(year)
        guard let m = Month(rawValue: month), day <= m.numberOfDays(year: y) else { return nil }

        self.y = y
        self.m = m
        self.day = day
    }

    public func date(in timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) -> Date {
        let dateComponents = DateComponents(
            calendar: Self.calendar,
            timeZone: timeZone,
            year: year,
            month: month,
            day: day
        )

        return dateComponents.date!
    }

    public func dateString(with formatter: DateFormatter) -> String {
        formatter.string(from: self.date())
    }

    fileprivate static let timeZone = TimeZone(secondsFromGMT: 0)!

    fileprivate static var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = LocalDate.timeZone
        return calendar
    }()
}

extension LocalDate {
    public var firstDay: Self {
        let calendar = Self.calendar
        let components = calendar.dateComponents([.year, .month], from: self.date())

        return .init(date: calendar.date(from: components)!)
    }

    public var lastDay: Self {
        let calendar = Self.calendar
        return .init(date: calendar.date(byAdding: .init(month: 1, day: -1), to: firstDay.date())!)
    }
}

extension LocalDate {
    public var week: Week {
        Week(rawValue: Self.calendar.component(.weekday, from: self.date()))!
    }
}

extension LocalDate {
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
    public func lastDay(of week: Week) -> LocalDate {
        let weekOfLastDate = Self.calendar.component(.weekday, from: self.lastDay.date())
        let dayDifference = (weekOfLastDate - week.rawValue) < 0 ? (weekOfLastDate + 7) - week.rawValue : weekOfLastDate - week.rawValue
        let lastDayOfWeek = Self.calendar.date(byAdding: .day, value: -dayDifference, to: self.lastDay.date())!

        return LocalDate(date: lastDayOfWeek)
    }
}

extension LocalDate {
    public static func monthInterval(from fromDate: LocalDate, to toDate: LocalDate) -> Int {
        Self.calendar.dateComponents([.month], from: fromDate.date(), to: toDate.date()).month ?? 0
    }

    public static func dayInterval(from fromDate: LocalDate, to toDate: LocalDate) -> Int {
        Self.calendar.dateComponents([.day], from: fromDate.date(), to: toDate.date()).day ?? 0
    }
}

extension LocalDate {
    public func date(byAdding component: LocalDate.Component, value: Int) -> LocalDate {
        let date = Self.calendar.date(byAdding: component.calendarComponent, value: value, to: self.date())!

        return .init(date: date)
    }
}

extension LocalDate {
    public var isWeekday: Bool {
        self.week.isWeekday
    }

    public var isWeekend: Bool {
        self.week.isWeekend
    }
}

extension LocalDate: Equatable {
    public static func == (lhs: LocalDate, rhs: LocalDate) -> Bool {
        return lhs.year == rhs.year &&
               lhs.month == rhs.month &&
               lhs.day == rhs.day
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
