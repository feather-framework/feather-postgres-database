//
//  PostgresConnection.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 01. 10..
//

import FeatherDatabase
import PostgresNIO

public struct PostgresDatabaseConnection: DatabaseConnection {

    public typealias Query = PostgresQuery
    public typealias RowSequence = PostgresDatabaseRowSequence

    var connection: PostgresConnection
    public var logger: Logger

    /// Execute a Postgres query on this connection.
    ///
    /// This wraps `PostgresNIO` query execution and maps errors.
    /// - Parameters:
    ///   - query: The Postgres query to execute.
    ///   - handler: A closure that receives the RowSequence result.
    /// - Throws: A `DatabaseError` if the query fails.
    /// - Returns: A query result containing the returned rows.
    @discardableResult
    public func run<T: Sendable>(
        query: Query,
        _ handler: (RowSequence) async throws -> T = { _ in }
    ) async throws(DatabaseError) -> T {
        do {
            let sequence = try await connection.query(
                .init(
                    unsafeSQL: query.sql,
                    binds: query.bindings
                ),
                logger: logger
            )

            return try await handler(
                PostgresDatabaseRowSequence(
                    backingSequence: sequence
                )
            )
        }
        catch {
            throw .query(error)
        }
    }
}
