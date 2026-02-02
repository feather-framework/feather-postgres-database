//
//  File.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 02. 02..
//

import FeatherDatabase
import PostgresNIO

/// Make Postgres transaction errors conform to `DatabaseTransactionError`.
///
/// This allows Postgres errors to flow through `DatabaseError`.
extension PostgresTransactionError: @retroactive DatabaseTransactionError {}
