// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "YeeKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "YeeKit", targets: ["YeeKit"]),
    ],
    targets: [
        .target(
            name: "YeeKit",
            path: "Sources/"
        )
    ]
)
