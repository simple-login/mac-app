// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var platforms: [SupportedPlatform] = [
    .macOS(.v13)
]

let package = Package(name: "Shared",
                      platforms: platforms,
                      products: [
                          // Products define the executables and libraries a package produces, and make them
                          // visible to other packages.
                          .library(name: "Shared",
                                   targets: ["Shared"])
                      ],
                      dependencies: [
                          .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", exact: "4.2.2"),
                          .package(url: "https://github.com/simple-login/swift-package", exact: "2.1.1")
                      ],
                      targets: [
                          // Targets are the basic building blocks of a package. A target can define a module or a
                          // test suite.
                          // Targets can depend on other targets in this package, and on products in packages this
                          // package depends on.
                          .target(name: "Shared",
                                  dependencies: [
                                      .product(name: "KeychainAccess", package: "KeychainAccess")
                                  ],
                                  resources: [
                                      .process("Resources")
                                  ])
                      ])
