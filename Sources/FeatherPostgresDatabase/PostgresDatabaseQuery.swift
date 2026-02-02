//
//  PostgresQuery.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 01. 10..
//

import FeatherDatabase
import PostgresNIO

extension PostgresQuery: @retroactive DatabaseQuery {
    /// The bindings type for Postgres queries.
    ///
    /// This type represents parameter bindings for PostgresNIO.
    public typealias Bindings = PostgresBindings

    /// The bound parameters for the SQL text.
    ///
    /// This exposes the underlying `binds` storage.
    public var bindings: PostgresBindings { binds }
}
