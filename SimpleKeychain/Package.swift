// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("ImplicitOpenExistentials"),
    .enableUpcomingFeature("StrictConcurrency"),
    .unsafeFlags(["-warn-concurrency", "-enable-actor-data-race-checks"])
]

let package = Package(
    name: "SimpleKeychain",
    platforms: [
        .iOS(.v15),
        .watchOS(.v9),
        .macOS(.v13),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SimpleKeychain",
            targets: ["SimpleKeychain"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SimpleKeychain",
            swiftSettings: [
                  /// Xcode 15. Remove `=targeted` to use the default `complete`.
                  .enableExperimentalFeature("StrictConcurrency"),
                  .enableExperimentalFeature("ForwardTrailingClosures"),
                  .enableExperimentalFeature("ExistentialAny"),
                  .enableExperimentalFeature("ImplicitOpenExistentials"),
              ]),
        .testTarget(
            name: "SimpleKeychainTests",
            dependencies: ["SimpleKeychain"]),
    ]
)
