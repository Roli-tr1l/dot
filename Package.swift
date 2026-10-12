// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Dot",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Dot", targets: ["Dot"])
    ],
    targets: [
        .executableTarget(
            name: "Dot",
            path: "Sources/Dot"
        )
    ]
)
