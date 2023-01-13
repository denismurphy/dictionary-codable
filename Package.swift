// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "DictionaryCodable",
    platforms: [.iOS(.v13),.tvOS(.v13),.watchOS(.v6),.macOS(.v11)],
    products: [
        .library(
            name: "DictionaryCodable",
            targets: ["DictionaryCodable"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DictionaryCodable",
            dependencies: []),
    ],
    swiftLanguageVersions: [.v5]
)
