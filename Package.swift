// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "YijingUI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "YijingUI", targets: ["YijingUI"]),
    ],
    targets: [
        .target(
            name: "YijingUI",
            path: "Sources/YijingUI"
        )
    ]
)
