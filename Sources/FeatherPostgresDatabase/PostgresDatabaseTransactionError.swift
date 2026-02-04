//
//  PostgresDatabaseTransactionError.swift
//  feather-postgres-database
//
//  Created by Tibor Bödecs on 2026. 02. 02..
//

import FeatherDatabase
import PostgresNIO

public struct PostgresDatabaseTransactionError: DatabaseTransactionError {

    var underlyingError: PostgresTransactionError

    public var file: String {
        underlyingError.file
    }

    public var line: Int {
        underlyingError.line
    }

    public var beginError: (any Error)? {
        underlyingError.beginError
    }

    public var closureError: (any Error)? {
        underlyingError.closureError
    }

    public var commitError: (any Error)? {
        underlyingError.commitError
    }

    public var rollbackError: (any Error)? {
        underlyingError.rollbackError
    }
}
