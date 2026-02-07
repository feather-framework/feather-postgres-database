//
//  PostgresDatabaseConnection.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 01. 10.
//

import FeatherDatabase
import PostgresNIO

extension Query {

    fileprivate func toPostgresQuery() -> PostgresQuery {
        var postgresUnsafeSQL = sql
        var postgresBindings: PostgresBindings = .init()

        for binding in bindings {
            /// postgres binding index starts with 1
            let idx = binding.index + 1
            postgresUnsafeSQL =
                postgresUnsafeSQL
                .replacing("{{\(idx)}}", with: "$\(idx)")

            switch binding.binding {
            case .int(let value):
                postgresBindings.append(value)
            case .double(let value):
                postgresBindings.append(value)
            case .string(let value):
                postgresBindings.append(value)
            }
        }

        return .init(
            unsafeSQL: postgresUnsafeSQL,
            binds: postgresBindings
        )
    }
}

public struct PostgresDatabaseConnection: DatabaseConnection {

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
        _ handler: (RowSequence) async throws -> T = { $0 }
    ) async throws(DatabaseError) -> T {
        do {
            let sequence = try await connection.query(
                query.toPostgresQuery(),
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
