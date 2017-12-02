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
        let serialQueue = DispatchQueue(label: "serialDatabaseOpen")
        serialQueue.async { // We need to run this sequentially or we might not be setup in the logger for errors
            do {
                try self.open(type: .log)
                try self.open(type: .cryptofolio)
    
            } catch DbError.openData(let message) {
                DDLogError(message)
            } catch {
                DDLogError("Unknown error opening database.") // Should never happen since we only throw one error in open()
            }
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
                
            } catch let Result.error(message: message, code: _, statement: _) {
                throw DbError.openData(message: message)
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
            DDLogError("Error preparing model \(message)")
        
        } catch {
            DDLogError(error.localizedDescription)
        }
    }
    
    fileprivate func prepareAsset() throws {
        do {
            let query = "create table if not exists 'Asset' ('id' integer primary key not null, 'ticker' text not null default ('unknown'), 'name' text not null default ('unknown'), 'fullname' text not null default ('unknown'))"
            try self.cryptfolioConnection.run(query)
            DDLogDebug("Asset table was prepared.")
            
        } catch let Result.error(message: message, code: _, statement: _) {
            throw DbError.prepare(message: "Asset: \(message)")
        }
    }
    
    func prepareTransaction() throws {
        do {
            let query = "create table if not exists 'transaction' ('id' integer primary key not null, 'assetId' integer not null default(-1), 'timestamp' real not null default (0.0), 'type' text not null default ('unknown'), 'fromAddress' text not null default ('unknown'), 'toAddress' text not null default ('unknown'), 'amount' real not null default (0.0))"
            try self.cryptfolioConnection.run(query)
            DDLogDebug("Transaction table was prepared.")
            
        } catch let Result.error(message: message, code: _, statement: _) {
            throw DbError.prepare(message: "Transaction: \(message)")
        }
    }
    
    fileprivate func prepareLog() throws {
        do {
            let query = "create table if not exists 'log' ('timestamp' real primary key not null, 'message' text not null)"
            try self.logConnection.run(query)
            DDLogDebug("Log table was prepared.")
            
        } catch let Result.error(message: message, code: _, statement: _){
            throw DbError.prepare(message: "Log: \(message)")
        }
    }
    
    func logToDatabase(timestamp: Double, message: String) throws {
        do {
            let query = "insert into 'log' ('timestamp', 'message') values (\(timestamp), '\(message)')"
            try self.logConnection.run(query)
            
        } catch let Result.error(message: message, code: _, statement: _) {
            throw DbError.update(message: message)
        }
    }
    
    func fetchConnection(type: DatabaseType) -> Connection? {
        if type == .cryptofolio {
            return self.cryptfolioConnection
        }
        
        return nil
    }
}
