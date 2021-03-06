// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Capable",
    products: [
        .library(
            name: "Capable",
            targets: ["Capable"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "1.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "Capable",
            dependencies: [],
            path: "Source"),
        .testTarget(
            name: "CapableTests",
            dependencies: ["Capable", "Quick", "Nimble"],
            path: "Tests"),
    ],
    swiftLanguageVersions: [4]
)
