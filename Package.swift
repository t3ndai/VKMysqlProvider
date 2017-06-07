import PackageDescription

let package = Package(
    name: "VKMysqlProvider",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", majorVersion: 0)
        ]
)
