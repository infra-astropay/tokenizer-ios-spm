// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Tokenizer",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Tokenizer",
            targets: ["Tokenizer"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Tokenizer",
            url: "https://github.com/infra-astropay/tokenizer-ios-spm/releases/download/1.1.2/Tokenizer.xcframework.zip",
            checksum: "cb8a4188367a229955b1c8c45f985453bbb33e02785984780cfd244cf1b1d2d3"
        )
    ]
)
