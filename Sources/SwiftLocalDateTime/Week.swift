import Foundation

public enum Week: Int, CaseIterable {
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
    public static var weekday: [Week] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday]
    }

    public static var weekend: [Week] {
        return [.saturday, .sunday]
    }

    public var isWeekday: Bool {
        return Self.weekday.contains(self)
    }

    public var isWeekend: Bool {
        return Self.weekend.contains(self)
    }
}
