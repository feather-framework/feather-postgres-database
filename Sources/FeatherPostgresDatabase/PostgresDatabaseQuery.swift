//
//  PostgresQuery.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 01. 10..
//

import FeatherDatabase
import PostgresNIO

public struct PostgresDatabaseQuery: DatabaseQuery {
    /// The bindings type for Postgres queries.
    ///
    /// This type represents parameter bindings for PostgresNIO.
    public typealias Bindings = PostgresBindings

    /// The SQL text to execute.
    ///
    /// This is the raw SQL string for the query.
    public var sql: String {
        query.sql
    }

    /// The bound parameters for the SQL text.
    ///
    /// This exposes the underlying `binds` storage.
    public var bindings: PostgresBindings {
        query.binds
    }

    var query: PostgresQuery

}

extension PostgresDatabaseQuery: ExpressibleByStringInterpolation {

    public init(
        stringLiteral value: String
    ) {
        self.init(query: .init(stringLiteral: value))
    }

    public init(
        stringInterpolation value: PostgresQuery.StringInterpolation
    ) {
        self.init(query: .init(stringInterpolation: value))
    }
}
