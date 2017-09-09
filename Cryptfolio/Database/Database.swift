//
//  Database.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-09-09.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import CocoaLumberjack
import UIKit
import SQLite

enum DbError: Error {
    case OpenData(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class Database {
    fileprivate let db: SQLite.Connection
    
    fileprivate init(db: SQLite.Connection) {
        self.db = db
    }
    
    static func open() throws -> Database {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        if let path = dirPath.first {
            
            do {
                let db = try Connection("\(path)/db.sqlite3")
                return Database(db: db)
            } catch let error as NSError {
                throw DbError.OpenData(message: error.localizedDescription)
            }
            
        } else {
            throw DbError.OpenData(message: "Database directory not found.")
        }
    }
}
