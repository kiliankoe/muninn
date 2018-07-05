// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "muninn",
    dependencies: [
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "MuninnCore", dependencies: []),
        .target(name: "muninn", dependencies: ["MuninnCore", "Console"]),
        .testTarget(name: "MuninnTests", dependencies: ["MuninnCore"])
    ]
)

