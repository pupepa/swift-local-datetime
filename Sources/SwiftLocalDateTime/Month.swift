import Foundation

/// `Month` represents the months of the year.
public enum Month: Int, CaseIterable, Codable, Sendable {
  case january = 1
  case february
  case march
  case april
  case may
  case june
  case july
  case august
  case september
  case october
  case november
  case december
}

extension Month: Comparable {
  public static func < (lhs: Month, rhs: Month) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

public extension Month {
  /// Returns the number of days in the specified year for the month.
  /// - Parameter year: The year.
  /// - Returns: The number of days in the month.
  func numberOfDays(year: Year) -> Int {
    switch self {
    case .february:
      return year.isLeap ? 29 : 28
    case .april, .june, .september, .november:
      return 30
    default:
      return 31
    }
  }
}

extension Month {
  /// Returns the current month.
  public static var current: Month {
    let calendar = Calendar(identifier: .gregorian)
    let month = Int(calendar.component(.month, from: Date()))

    return Month(rawValue: month)!
  }
}
