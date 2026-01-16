//
//  PostgresConnection.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 01. 10..
//

import FeatherDatabase
import PostgresNIO

extension PostgresConnection: @retroactive DatabaseConnection {

    /// Execute a Postgres query on this connection.
    ///
    /// This wraps `PostgresNIO` query execution and maps errors.
    /// - Parameter query: The Postgres query to execute.
    /// - Throws: A `DatabaseError` if the query fails.
    /// - Returns: A query result containing the returned rows.
    @discardableResult
    public func execute(
        query: PostgresQuery
    ) async throws(DatabaseError) -> PostgresQueryResult {
        do {
            let result = try await self.query(
                .init(
                    unsafeSQL: query.sql,
                    binds: query.bindings
                ),
                logger: logger
            )
            return PostgresQueryResult(backingSequence: result)
        }
        catch {
            throw DatabaseError.query(error)
        }
    }
}
