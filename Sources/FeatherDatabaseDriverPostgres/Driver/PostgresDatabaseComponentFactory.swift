//
//  PostgresDatabaseComponentFactory.swift
//  PostgresDatabaseDriverPostgres
//
//  Created by Tibor Bodecs on 18/11/2023.
//

import AsyncKit
import FeatherComponent
import PostgresKit

struct PostgresDatabaseComponentFactory: ComponentFactory {

    let context: PostgresDatabaseComponentContext

    func build(using config: ComponentConfig) throws -> Component {
        PostgresDatabaseComponent(config: config)
    }
}
