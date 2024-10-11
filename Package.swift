// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftLocalDateTime",
  platforms: [
    .iOS(.v16),
    .watchOS(.v8),
  ],
  products: [
    .library(
      name: "SwiftLocalDateTime",
      targets: ["SwiftLocalDateTime"]
    )
  ],
  targets: [
    .target(
      name: "SwiftLocalDateTime",
      dependencies: [],
      swiftSettings: [
        .swiftLanguageMode(.v5),
        .enableUpcomingFeature("StrictConcurrency")
      ]
    ),
    .testTarget(
      name: "SwiftLocalDateTimeTests",
      dependencies: ["SwiftLocalDateTime"]
    ),
  ]
)
