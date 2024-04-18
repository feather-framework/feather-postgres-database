// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-relational-database-driver-postgres",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FeatherRelationalDatabaseDriverPostgres", targets: ["FeatherRelationalDatabaseDriverPostgres"]),
    ],
    dependencies: [
        .package(url: "https://github.com/feather-framework/feather-relational-database", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/vapor/postgres-kit", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "FeatherRelationalDatabaseDriverPostgres",
            dependencies: [
                .product(name: "FeatherRelationalDatabase", package: "feather-relational-database"),
                .product(name: "PostgresKit", package: "postgres-kit"),
            ]
        ),
        .testTarget(
            name: "FeatherRelationalDatabaseDriverPostgresTests",
            dependencies: [
                .target(name: "FeatherRelationalDatabaseDriverPostgres"),
            ]
        ),
    ]
)
