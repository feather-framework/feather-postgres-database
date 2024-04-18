//
//  PostgresRelationalDatabaseComponentFactory.swift
//  PostgresRelationalDatabaseDriverPostgres
//
//  Created by Tibor Bodecs on 18/11/2023.
//

import AsyncKit
import FeatherComponent
import PostgresKit

struct PostgresRelationalDatabaseComponentFactory: ComponentFactory {

    let context: PostgresRelationalDatabaseComponentContext

    func build(using config: ComponentConfig) throws -> Component {
        PostgresRelationalDatabaseComponent(config: config)
    }
}
