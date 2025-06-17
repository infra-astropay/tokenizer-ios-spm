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
            url: "https://github.com/infra-astropay/tokenizer-ios-spm/releases/download/1.2.0/Tokenizer.xcframework.zip",
            checksum: "b81a36459491e0aa994b62b7061acc27d93d913d52cbc87f72fd85d760786c8d"
        )
    ]
)
