// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GitLabSwift",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GitLabSwift",
            targets: ["GitLabSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/immobiliare/RealHTTP.git", branch: "fix/query-param-encoding"),
        .package(url: "https://github.com/immobiliare/Glider", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "GitLabSwift",
            dependencies: [
                "RealHTTP",
                "Glider"
            ]),
        .testTarget(
            name: "GitLabSwiftTests",
            dependencies: ["GitLabSwift"]),
    ]
)
