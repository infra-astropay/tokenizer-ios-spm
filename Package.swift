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
            checksum: "3ce51b5bd39748e533a688f85db1e0bba3649aa20cd79fae9da760d347251fe9"
        )
    ]
)
