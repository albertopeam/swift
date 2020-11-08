// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Adapters",
    platforms: [.iOS("13.0")],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Adapters",
            targets: ["Adapters"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Application", path: "../Application")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Adapters",
            dependencies: []),
        .testTarget(
            name: "AdaptersTests",
            dependencies: ["Adapters"]),
    ]
)
