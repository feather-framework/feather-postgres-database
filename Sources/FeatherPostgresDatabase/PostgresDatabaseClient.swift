//
//  PostgresDatabaseClient.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 01. 10..
//

import FeatherDatabase
import Logging
import PostgresNIO

/// A Postgres-backed database client.
///
/// Use this client to execute queries and manage transactions on Postgres.
public struct PostgresDatabaseClient: DatabaseClient {
    public typealias Connection = PostgresDatabaseConnection

    var client: PostgresNIO.PostgresClient
    var logger: Logger

    /// Create a Postgres database client.
    ///
    /// Use this initializer to provide an existing Postgres client.
    /// - Parameters:
    ///   - client: The underlying Postgres client.
    ///   - logger: The logger for database operations.
    public init(
        client: PostgresNIO.PostgresClient,
        logger: Logger
    ) {
        self.client = client
        self.logger = logger
    }

    // MARK: - database api

    /// Execute work using a managed Postgres connection.
    ///
    /// The closure receives a Postgres connection for the duration of the call.
    /// - Parameter: closure: A closure that receives the connection.
    /// - Throws: A `DatabaseError` if connection handling fails.
    /// - Returns: The query result produced by the closure.
    @discardableResult
    public func withConnection<T>(
        _ closure: (Connection) async throws -> T,
    ) async throws(DatabaseError) -> T {
        do {
            return try await client.withConnection { connection in
                let databaseConnection = PostgresDatabaseConnection(
                    connection: connection,
                    logger: logger
                )
                return try await closure(databaseConnection)
            }
        }
        catch let error as DatabaseError {
            throw error
        }
        catch {
            throw .connection(error)
        }
    }

    /// Execute work inside a Postgres transaction.
    ///
    /// The closure is wrapped in a transactional scope.
    /// - Parameter: closure: A closure that receives the connection.
    /// - Throws: A `DatabaseError` if the transaction fails.
    /// - Returns: The query result produced by the closure.
    @discardableResult
    public func withTransaction<T>(
        _ closure: (Connection) async throws -> T,
    ) async throws(DatabaseError) -> T {
        do {
            return try await client.withTransaction(
                logger: logger
            ) { connection in
                let databaseConnection = PostgresDatabaseConnection(
                    connection: connection,
                    logger: logger
                )
                return try await closure(databaseConnection)
            }
        }
        catch let error as PostgresTransactionError {
            throw .transaction(error)
        }
        catch {
            throw .connection(error)
        }
    }

}
