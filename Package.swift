import PackageDescription

let package = Package(
    name: "kps",
    dependencies: [
        .Package(
            url: "https://github.com/SwiftyJSON/SwiftyJSON.git",
            versions: Version(1, 0, 0)..<Version(3, .max, .max)
        ),
        .Package(
            url: "https://github.com/jatoben/CommandLine.git",
            versions: Version(3, 0, 0)..<Version(4, .max, .max)
        ),
        ]
    )
