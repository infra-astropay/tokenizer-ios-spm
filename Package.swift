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
            url: "https://github.com/infra-astropay/tokenizer-ios-spm/releases/download/1.3.0/Tokenizer.xcframework.zip",
            checksum: "4b493996c4d6725ad2ec887da331b70ecd834ab0754b8593af4b1200550cfe66"
        )
    ]
)
