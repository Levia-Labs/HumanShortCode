// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HumanShortCode",
    products: [.library(name: "HumanShortCode", targets: ["HumanShortCode"])],
    targets: [
        .target(name: "HumanShortCode"),
        .testTarget(name: "HumanShortCodeTests", dependencies: ["HumanShortCode"]),
    ]
)
