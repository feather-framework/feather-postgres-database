//
//  FeatherRelationalDatabaseDriverPostgresTests.swift
//  FeatherRelationalDatabaseDriverPostgresTests
//
//  Created by Tibor Bodecs on 2023. 01. 16..
//

import NIO
import XCTest
import FeatherComponent
import FeatherRelationalDatabase
import FeatherRelationalDatabaseDriverPostgres
import PostgresKit

final class FeatherRelationalDatabaseDriverPostgresTests: XCTestCase {
    
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
        let pool = EventLoopGroupConnectionPool<PostgresConnectionSource>.init(
            source: connectionSource,
            on: eventLoopGroup
        )
        
        try await registry.addRelationalDatabase(
            PostgresRelationalDatabaseComponentContext(pool: pool)
        )
        
        let dbComponent = try await registry.relationalDatabase()
        let db = try await dbComponent.connection()
        
        do {
            struct Galaxy: Codable {
                let id: Int
                let name: String
            }
            
            try await db
                .create(table: "galaxies")
                .ifNotExists()
            // TODO: figure out how to auto increment
                .column("id", type: .int, .primaryKey(autoIncrement: false))
                .column("name", type: .text)
                .run()
            
            try await db.delete(from: "galaxies").run()
            
            try await db
                .insert(into: "galaxies")
                .columns("id", "name")
                .values(SQLBind(1), SQLBind("Milky Way"))
                .values(SQLBind(2), SQLBind("Andromeda"))
                .run()
            
            let galaxies = try await db
                .select()
                .column("*")
                .from("galaxies")
                .all(decoding: Galaxy.self)
            
            print("------------------------------")
            for galaxy in galaxies {
                print(galaxy.id, galaxy.name)
            }
            print("------------------------------")
        }
        catch {
            throw error
        }
        
        pool.shutdown()
        try await eventLoopGroup.shutdownGracefully()
        try await threadPool.shutdownGracefully()
    }
}
