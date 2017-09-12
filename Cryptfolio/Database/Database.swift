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
    
    static let shared = Database()
    fileprivate var connection: SQLite.Connection!
    
    func open() throws {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        if let path = dirPath.first {
            
            do {
                let db = try Connection("\(path)/db.sqlite3")
                self.connection = db
                DDLogInfo("Database was opened successfully.")
                
                self.prepareModels()
                
            } catch {
                throw DbError.OpenData(message: error.localizedDescription)
            }
            
        } else {
            throw DbError.OpenData(message: "Database directory not found.")
        }
    }
    
    fileprivate func prepareModels() {
        do {
            try self.prepareAsset()
        } catch DbError.Prepare(message: let message) {
            DDLogError("Error preparing model: \(message)")
        
        } catch {
            DDLogError(error.localizedDescription)
        }
    }
    
    fileprivate func prepareAsset() throws {
        do {
            let assets = Table("assets")
            try self.connection.run(assets.create { t in
                let id = Expression<Int64>("id")
                let ticker = Expression<String>("ticker")
                let name = Expression<String>("name")
                let fullname = Expression<String>("fullname")
                let balance = Expression<Double>("balance")
                let lastPrice = Expression<Double>("lastPrice")
                let timestampAdded = Expression<Double>("timestampAdded")
                let timestampRemoved = Expression<Double>("timestampRemoved")
                let lastEdited = Expression<Double>("timestampLastEdited")
                
                t.column(id, primaryKey: .autoincrement)
                t.column(ticker, defaultValue: "Unknown")
                t.column(name, defaultValue: "Unknown")
                t.column(fullname, defaultValue: "Unknown")
                t.column(balance, defaultValue: 0.0)
                t.column(lastPrice, defaultValue: 0.0)
                t.column(timestampAdded, defaultValue: 0.0)
                t.column(timestampRemoved, defaultValue: 0.0)
                t.column(lastEdited, defaultValue: 0.0)
            })
            
            DDLogInfo("Asset was prepared.")
            
        } catch {
            throw DbError.Prepare(message: error.localizedDescription)
        }
    }
}
