import Foundation

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
  public static var current: Month {
    let calendar = Calendar(identifier: .gregorian)
    let month = Int(calendar.component(.month, from: Date()))

    return Month(rawValue: month)!
  }
}
