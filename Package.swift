// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinomSDK",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "BinomSDK",
            targets: ["BinomSDK"]
        )
    ],
    dependencies: [
        .package(name: "Pimine", url: "https://github.com/Pimine/PimineSDK", .branch("master")),
        .package(url: "https://github.com/mxcl/PromiseKit", .branch("v7")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0"))
    ],
    targets: [
        .target(
            name: "BinomSDK",
            dependencies: [
                "Pimine",
                "PromiseKit",
                "Moya"
            ],
            path: "Sources",
            exclude: ["Support files/Info.plist"]
        )
    ]
)
