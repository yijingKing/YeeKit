
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "YeeKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "YeeKit", targets: ["YeeKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.4.0"),
    ],
    targets: [
        .target(
            name: "YeeKit",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher"),
            ],
            path: "Sources/YeeKit"
        )
    ]
)
