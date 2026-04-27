// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MonthCalendarKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "MonthCalendarKit",
            targets: ["MonthCalendarKit"]
        )
    ],
    targets: [
        .target(
            name: "MonthCalendarKit",
            path: "Sources/MonthCalendarKit"
        ),
        .testTarget(
            name: "MonthCalendarKitTests",
            dependencies: ["MonthCalendarKit"],
            path: "Tests/MonthCalendarKitTests"
        )
    ],
    swiftLanguageModes: [.v6]
)
