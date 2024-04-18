//
//  PostgresRelationalDatabaseComponentFactory.swift
//  PostgresRelationalDatabaseDriverPostgres
//
//  Created by Tibor Bodecs on 18/11/2023.
//

import FeatherComponent
import AsyncKit
import PostgresKit

struct PostgresRelationalDatabaseComponentFactory: ComponentFactory {

    let context: PostgresRelationalDatabaseComponentContext
    
    init(context: PostgresRelationalDatabaseComponentContext) {
        self.context = context
    }
    
    func build(using config: ComponentConfig) throws -> Component {
        PostgresRelationalDatabaseComponent(config: config)
    }
}
