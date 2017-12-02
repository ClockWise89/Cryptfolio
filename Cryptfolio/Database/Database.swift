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
                
                DDLogDebug("Database \(type.name) was successfully opened.")
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
                try self.prepareTransaction()
            }
            
        } catch DbError.prepare(message: let message) {
            DDLogError("Error preparing model: \(message)")
        
        } catch {
            DDLogError(error.localizedDescription)
        }
    }
    
    fileprivate func prepareAsset() throws {
        do {
            let asset = Table("Asset")
            
            try self.cryptfolioConnection.run(asset.create(ifNotExists: true) { t in
                
                let id = Expression<Int64>("id")
                let apiId = Expression<Int64>("apiId")
                let ticker = Expression<String>("ticker")
                let name = Expression<String>("name")
                let fullname = Expression<String>("fullname")
                
                t.column(id, primaryKey: true)
                t.column(apiId, defaultValue: 0)
                t.column(ticker, defaultValue: "Unknown")
                t.column(name, defaultValue: "Unknown")
                t.column(fullname, defaultValue: "Unknown")
            })
            
            DDLogDebug("Asset table was prepared.")
            
        } catch {
            throw DbError.prepare(message: error.localizedDescription)
        }
    }
    
    fileprivate func prepareTransaction() throws {
        do {
            let transaction = Table("Transaction")
            
            try self.cryptfolioConnection.run(transaction.create(ifNotExists: true) { t in
                
                let id = Expression<Int64>("id")
                let assetId = Expression<Int64>("assetId")
                let timestamp = Expression<Double>("timestamp")
                let type = Expression<String>("type")
                let fromAddress = Expression<String>("fromAddress")
                let toAddress = Expression<String>("toAddress")
                let amount = Expression<Double>("amount")
                
                t.column(id, primaryKey: true)
                t.column(assetId, defaultValue: -1)
                t.column(timestamp, defaultValue: 0.0)
                t.column(type, defaultValue: "Unknown")
                t.column(fromAddress, defaultValue: "")
                t.column(toAddress, defaultValue: "")
                t.column(amount, defaultValue: 0.0)
            })
            
            DDLogDebug("Transaction table was prepared.")
            
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
            
            DDLogDebug("Log table was prepared.")
            
        } catch {
            throw DbError.prepare(message: error.localizedDescription)
        }
    }
    
    func logToDatabase(timestamp: Double, message: String) throws {
        do {
            let logTable = Table("Log")
            let db_timestamp = Expression<Double>("timestamp")
            let db_message = Expression<String>("message")
            
            try self.logConnection.run(logTable.insert(db_timestamp <- timestamp, db_message <- message))
            
        } catch {
            throw DbError.update(message: error.localizedDescription)
        }
    }
    
    func fetchConnection(type: DatabaseType) -> Connection? {
        if type == .cryptofolio {
            return self.cryptfolioConnection
        }
        
        return nil
    }
}
