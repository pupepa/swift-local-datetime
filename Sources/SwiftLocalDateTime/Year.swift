import Foundation

public struct Year: Sendable {
  public let year: Int

  public init(_ year: Int) {
    self.year = year
  }

  public var isLeap: Bool {
    return year % 4 == 0 && (year % 400 == 0 || year % 100 != 0)
  }
}

extension Year: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.year == rhs.year
  }
}
