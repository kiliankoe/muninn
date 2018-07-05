// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "muninn",
    dependencies: [
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.0"),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "MuninnCore", dependencies: ["Yams", "AnyCodable"]),
        .target(name: "muninn", dependencies: ["MuninnCore", "Console"]),
        .testTarget(name: "MuninnTests", dependencies: ["MuninnCore"])
    ]
)

