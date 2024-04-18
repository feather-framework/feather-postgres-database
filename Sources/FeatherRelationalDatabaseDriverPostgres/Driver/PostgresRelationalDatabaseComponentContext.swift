//
//  PostgresRelationalDatabaseComponentContext.swift
//  PostgresRelationalDatabaseDriverPostgres
//
//  Created by Tibor Bodecs on 18/11/2023.
//

import FeatherComponent
@preconcurrency import PostgresKit

public struct PostgresRelationalDatabaseComponentContext: ComponentContext {

    let pool: EventLoopGroupConnectionPool<PostgresConnectionSource>

    public init(
        pool: EventLoopGroupConnectionPool<PostgresConnectionSource>
    ) {
        self.pool = pool
    }

    public func make() throws -> ComponentFactory {
        PostgresRelationalDatabaseComponentFactory(context: self)
    }
}
