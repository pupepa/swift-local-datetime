// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SwiftLocalDateTime",
  platforms: [
    .iOS(.v13),
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
      dependencies: []
    ),
    .testTarget(
      name: "SwiftLocalDateTimeTests",
      dependencies: ["SwiftLocalDateTime"]
    ),
  ]
)
