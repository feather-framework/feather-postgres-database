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
        stringInterpolation value: StringInterpolation
    ) {
        self.init(
            query: .init(
                unsafeSQL: value.sql,
                binds: value.binds
            )
        )
    }
}

extension PostgresDatabaseQuery {

    // NOTE: source derived from postgres-nio
    public struct StringInterpolation: StringInterpolationProtocol, Sendable {
        public typealias StringLiteralType = String

        @usableFromInline
        var sql: String

        @usableFromInline
        var binds: PostgresBindings

        public init(
            literalCapacity: Int,
            interpolationCount: Int
        ) {
            self.sql = ""
            self.binds = PostgresBindings(capacity: interpolationCount)
        }

        public mutating func appendLiteral(
            _ literal: String
        ) {
            self.sql.append(contentsOf: literal)
        }

        @inlinable
        public mutating func appendInterpolation<
            Value: PostgresThrowingDynamicTypeEncodable
        >(
            _ value: Value
        ) throws {
            try self.binds.append(value, context: .default)
            self.sql.append(contentsOf: "$\(self.binds.count)")
        }

        @inlinable
        public mutating func appendInterpolation<
            Value: PostgresThrowingDynamicTypeEncodable
        >(
            _ value: Value?
        ) throws {
            switch value {
            case .none:
                self.binds.appendNull()
            case .some(let value):
                try self.binds.append(value, context: .default)
            }

            self.sql.append(contentsOf: "$\(self.binds.count)")
        }

        @inlinable
        public mutating func appendInterpolation<
            Value: PostgresDynamicTypeEncodable
        >(
            _ value: Value
        ) {
            self.binds.append(value, context: .default)
            self.sql.append(contentsOf: "$\(self.binds.count)")
        }

        @inlinable
        public mutating func appendInterpolation<
            Value: PostgresDynamicTypeEncodable
        >(
            _ value: Value?
        ) {
            switch value {
            case .none:
                self.binds.appendNull()
            case .some(let value):
                self.binds.append(value, context: .default)
            }

            self.sql.append(contentsOf: "$\(self.binds.count)")
        }

        @inlinable
        public mutating func appendInterpolation<
            Value: PostgresThrowingDynamicTypeEncodable,
            JSONEncoder: PostgresJSONEncoder
        >(
            _ value: Value,
            context: PostgresEncodingContext<JSONEncoder>
        ) throws {
            try self.binds.append(value, context: context)
            self.sql.append(contentsOf: "$\(self.binds.count)")
        }

        @inlinable
        public mutating func appendInterpolation(
            unescaped interpolated: String
        ) {
            self.sql.append(contentsOf: interpolated)
        }

        @inlinable
        public mutating func appendInterpolation(
            unescaped interpolated: Int
        ) {
            self.sql.append(contentsOf: String(interpolated))
        }
    }
}
