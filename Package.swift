// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "folklore",
  dependencies: [
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-log.git", branch: "main"),
  ],
  targets: [
    .target(
      name: "Folklore",
      dependencies: [
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
        .product(name: "Logging", package: "swift-log"),
      ]),
    .executableTarget(
      name: "ExampleBot",
      dependencies: ["Folklore"]
    )
  ]
)
