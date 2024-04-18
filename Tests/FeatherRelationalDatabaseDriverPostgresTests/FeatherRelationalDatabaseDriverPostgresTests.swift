//
//  FeatherDatabaseDriverPostgresTests.swift
//  FeatherDatabaseDriverPostgresTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import FeatherComponent
import FeatherDatabase
import FeatherDatabaseDriverPostgres
import FeatherDatabaseTesting
import NIO
import PostgresKit
import XCTest

final class FeatherDatabaseDriverPostgresTests: XCTestCase {

    var host: String {
        ProcessInfo.processInfo.environment["PG_HOST"]!
    }

    var user: String {
        ProcessInfo.processInfo.environment["PG_USER"]!
    }

    var pass: String {
        ProcessInfo.processInfo.environment["PG_PASS"]!
    }

    var db: String {
        ProcessInfo.processInfo.environment["PG_DB"]!
    }

    func testExample() async throws {
        let registry = ComponentRegistry()

        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let threadPool = NIOThreadPool(numberOfThreads: 1)
        threadPool.start()

        let configuration = SQLPostgresConfiguration(
            hostname: host,
            username: user,
            password: pass,
            database: db,
            tls: .disable
        )
        let connectionSource = PostgresConnectionSource(
            sqlConfiguration: configuration
        )
        let pool = EventLoopGroupConnectionPool<PostgresConnectionSource>
            .init(
                source: connectionSource,
                on: eventLoopGroup
            )

        try await registry.addDatabase(
            PostgresDatabaseComponentContext(pool: pool)
        )

        let db = try await registry.database()

        let testSuite = DatabaseTestSuite(db)
        try await testSuite.testAll()

        pool.shutdown()
        try await eventLoopGroup.shutdownGracefully()
        try await threadPool.shutdownGracefully()
    }
}
