//
//  PostgresDatabaseComponent.swift
//  PostgresDatabaseDriverPostgres
//
//  Created by Tibor Bodecs on 03/12/2023.
//

import AsyncKit
import FeatherComponent
import FeatherDatabase
import PostgresKit
import SQLKit

@dynamicMemberLookup
struct PostgresDatabaseComponent: DatabaseComponent {
    
    public let config: ComponentConfig

    subscript<T>(
        dynamicMember keyPath: KeyPath<
            PostgresDatabaseComponentContext, T
        >
    ) -> T {
        let context =
            config.context as! PostgresDatabaseComponentContext
        return context[keyPath: keyPath]
    }

    public func connection() async throws -> Database {
        .init(self.pool.database(logger: self.logger).sql())
    }
}
