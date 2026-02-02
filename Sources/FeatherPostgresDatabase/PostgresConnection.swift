//
//  PostgresConnection.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 01. 10..
//

import FeatherDatabase
import PostgresNIO

extension PostgresConnection: @retroactive DatabaseConnection {
    public typealias Query = PostgresQuery
    public typealias Result = PostgresQueryResult

    /// Execute a Postgres query on this connection.
    ///
    /// This wraps `PostgresNIO` query execution and maps errors.
    /// - Parameter query: The Postgres query to execute.
    /// - Throws: A `DatabaseError` if the query fails.
    /// - Returns: A query result containing the returned rows.
    @discardableResult
    public func run<T: Sendable>(
        query: Query,
        _ handler: (Result.Row) async throws -> T = { $0 }
    ) async throws(DatabaseError) -> [T] {
        do {
            let resultSequence = try await self.query(
                .init(
                    unsafeSQL: query.sql,
                    binds: query.bindings
                ),
                logger: logger
            )

            var result: [T] = []
            for try await item in resultSequence {
                result.append(try await handler(item))
            }
            return result
        }
        catch {
            throw .query(error)
        }

    }

    public func run(
        query: Query,
        _ handler: (Result.Row) async throws -> Void = { _ in }
    ) async throws(DatabaseError) {
        do {
            let resultSequence = try await self.query(
                .init(
                    unsafeSQL: query.sql,
                    binds: query.bindings
                ),
                logger: logger
            )

            for try await item in resultSequence {
                try await handler(item)
            }
        }
        catch {
            throw .query(error)
        }
    }

}
