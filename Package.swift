// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-database-driver-postgres",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FeatherDatabaseDriverPostgres", targets: ["FeatherDatabaseDriverPostgres"]),
    ],
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-database", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/vapor/postgres-kit", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "FeatherDatabaseDriverPostgres",
            dependencies: [
                .product(name: "FeatherDatabase", package: "feather-database"),
                .product(name: "PostgresKit", package: "postgres-kit"),
            ]
        ),
        .testTarget(
            name: "FeatherDatabaseDriverPostgresTests",
            dependencies: [
                .product(name: "FeatherDatabaseTesting", package: "feather-database"),
                .target(name: "FeatherDatabaseDriverPostgres"),
            ]
        ),
    ]
)
