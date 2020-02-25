// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SuffixTree",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SuffixTree",
            targets: ["SuffixTree"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/pumperknickle/AwesomeTrie.git", from: "0.1.2"),
        .package(url: "https://github.com/pumperknickle/Bedrock.git", from: "0.2.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2"),
    ],
    targets: [
        .target(
            name: "SuffixTree",
            dependencies: ["AwesomeTrie", "Bedrock"]),
        .testTarget(
            name: "SuffixTreeTests",
            dependencies: ["SuffixTree", "Quick", "Nimble"]),
    ]
)
