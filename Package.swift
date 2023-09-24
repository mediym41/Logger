// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Logger",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Logger",
            targets: ["Logger"]),
        .executable(
            name: "LoggerExample",
            targets: ["LoggerExample"])
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Logger",
            dependencies: [],
            path: "./Sources/Logger"),
        .target(
            name: "LoggerExample",
            dependencies: ["Logger"],
            path: "./Sources/Example"),
        .testTarget(
            name: "LoggerTests",
            dependencies: ["Logger"]),
    ]
)
