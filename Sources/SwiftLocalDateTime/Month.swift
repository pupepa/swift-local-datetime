import Foundation

public enum Month: Int {
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
