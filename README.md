# SwiftLocalDateTime

Inspired by `java.time.LocalDateTime`. (also `java.time.LocalDate` and `java.time.LocalTime`)

## Requirements

iOS 13+ / watchOS 6+

## Installation

### Swift Package Manager

Add the following line to your `Package.swift`:

```
dependencies: [
    .package(url: "https://github.com/pupepa/SwiftLocalDate.git")
]
```

## Usage

### LocalDate

```swift
let localDate = LocalDate(year: 2021, month: 12, day: 1)!

print(localDate.year)   // 2021
print(localDate.month)  // 12
print(localDate.day)    // 1
```

### LocalTime

```swift
let localTime = LocalTime(hour: 5, minute: 3, second: 40)!

print(localTime.hour)    // 5
print(localTime.minute)  // 3
print(localTime.second)  // 40
```

### LocalDateTime

```swift
let localDateTime = LocalDateTime(
    year: 2021,
    month: 12,
    day: 1,
    hour: 5,
    minute: 3,
    second: 40
)!

print(localDate.year)    // 2021
print(localDate.month)   // 12
print(localDate.day)     // 1
print(localTime.hour)    // 5
print(localTime.minute)  // 3
print(localTime.second)  // 40
```

## License

MIT license.
