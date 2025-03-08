import Foundation

/// `Year` represents a specific year.
public struct Year: Codable, Sendable {
  public let year: Int

  /// Initializes a `Year` with the specified year.
  /// - Parameter year: The year.
  public init(_ year: Int) {
    self.year = year
  }

  /// Returns whether the year is a leap year.
  public var isLeap: Bool {
    return year % 4 == 0 && (year % 400 == 0 || year % 100 != 0)
  }
}

extension Year: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.year == rhs.year
  }
}
