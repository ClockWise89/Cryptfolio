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
    case openData(message: String)
    case prepare(message: String)
    case update(message: String)
}

enum DatabaseType {
    case cryptofolio
    case log
    
    var name: String {
        switch self {
        case .log: return "log.sqlite3"
        default: return "cryptfolio.sqlite3"
        }
    }
}


class Database {
    
    static let shared = Database()
    fileprivate var cryptfolioConnection: SQLite.Connection!
    fileprivate var logConnection: SQLite.Connection!
    
    // Mark: Init
    public init() {
        do {
            try self.open(type: .cryptofolio)
            try self.open(type: .log)
            
        } catch DbError.openData(let message) {
            DDLogError(message)
        } catch {
            DDLogError("Unknown error opening database.") // Should never happen since we only throw one error in open()
        }
    }
    
    fileprivate func open(type: DatabaseType) throws {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        if let path = dirPath.first {
            
            do {
                let db = try Connection("\(path)/\(type.name)")
                
                if (type == .log) {
                    self.logConnection = db
                } else {
                    self.cryptfolioConnection = db
                }
                
                DDLogInfo("Database \(type.name) was successfully opened.")
                self.prepareModels(type: type)
                
            } catch {
                throw DbError.openData(message: error.localizedDescription)
            }
            
        } else {
            throw DbError.openData(message: "Database \(type.name) directory not found.")
        }
    }
    
    fileprivate func prepareModels(type: DatabaseType) {
        do {
            
            if (type == .log) {
                try self.prepareLog()
            } else {
                try self.prepareAsset()
            }
            
        } catch DbError.prepare(message: let message) {
            DDLogError("Error preparing model: \(message)")
        
        } catch {
            DDLogError(error.localizedDescription)
        }
    }
    
    fileprivate func prepareAsset() throws {
        do {
            let assets = Table("Asset")
            let portfolio = Table("Portfolio")
            
            try self.cryptfolioConnection.run(assets.create(ifNotExists: true) { t in
                
                let id = Expression<Int64>("id")
                let ticker = Expression<String>("ticker")
                let name = Expression<String>("name")
                let fullname = Expression<String>("fullname")
                let balance = Expression<Double>("balance")
                let lastPrice = Expression<Double>("lastPrice")
                let timestampAdded = Expression<Double>("timestampAdded")
                let timestampRemoved = Expression<Double>("timestampRemoved")
                let lastEdited = Expression<Double>("timestampLastEdited")
                let status = Expression<Int64>("status")
                
                t.column(id, primaryKey: true)
                t.column(ticker, defaultValue: "Unknown")
                t.column(name, defaultValue: "Unknown")
                t.column(fullname, defaultValue: "Unknown")
                t.column(balance, defaultValue: 0.0)
                t.column(lastPrice, defaultValue: 0.0)
                t.column(timestampAdded, defaultValue: 0.0)
                t.column(timestampRemoved, defaultValue: 0.0)
                t.column(lastEdited, defaultValue: 0.0)
                t.column(status, defaultValue: 0)
            })
            
            DDLogInfo("Asset was prepared.")
            
            try self.cryptfolioConnection.run(portfolio.create(ifNotExists: true) { t in
                
                let id = Expression<Int64>("id")
                let name = Expression<String>("name")
                let balance = Expression<Double>("balance") // Maybe not needed
                let timestampAdded = Expression<Double>("timestampAdded")
                let timestampRemoved = Expression<Double>("timestampRemoved")
                let lastEdited = Expression<Double>("timestampLastEdited")
                
                t.column(id, primaryKey: true)
                t.column(name, defaultValue: "Unknown")
                t.column(balance, defaultValue: 0.0)
                t.column(timestampAdded, defaultValue: 0.0)
                t.column(timestampRemoved, defaultValue: 0.0)
                t.column(lastEdited, defaultValue: 0.0)
            })
            
            DDLogInfo("Portolio was prepared.")
            
        } catch {
            throw DbError.prepare(message: error.localizedDescription)
        }
    }
    
    fileprivate func prepareLog() throws {
        do {
            let log = Table("Log")
            try self.logConnection.run(log.create(ifNotExists: true) { t in
                let timestamp = Expression<Double>("timestamp")
                let message = Expression<String>("message")
                
                t.column(timestamp, primaryKey: true)
                t.column(message)
            })
            
            DDLogInfo("Log was prepared.")
            
        } catch {
            throw DbError.prepare(message: error.localizedDescription)
        }
    }
    
    func logToDatabase(timestamp: Double, message: String) throws {
        do {
            let logTable = Table("Log")
            let t = Expression<Double>("timestamp")
            let m = Expression<String>("message")
            
            try self.logConnection.run(logTable.insert(t <- timestamp, m <- message))
            
        } catch {
            throw DbError.update(message: error.localizedDescription)
        }
    }
}
