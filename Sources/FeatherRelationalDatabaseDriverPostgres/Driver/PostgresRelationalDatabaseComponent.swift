//
//  PostgresRelationalDatabaseComponent.swift
//  PostgresRelationalDatabaseDriverPostgres
//
//  Created by Tibor Bodecs on 03/12/2023.
//

import FeatherComponent
import FeatherRelationalDatabase
import SQLKit
import PostgresKit
import AsyncKit

@dynamicMemberLookup
struct PostgresRelationalDatabaseComponent: RelationalDatabaseComponent {
    
    public let config: ComponentConfig

    subscript<T>(
        dynamicMember keyPath: KeyPath<PostgresRelationalDatabaseComponentContext, T>
    ) -> T {
        let context = config.context as! PostgresRelationalDatabaseComponentContext
        return context[keyPath: keyPath]
    }

    public func connection() async throws -> SQLKit.SQLDatabase {
        self.pool.database(logger: self.logger).sql()
    }
}
