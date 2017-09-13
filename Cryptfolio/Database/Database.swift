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

enum DatabaseType {
    case asset
    case log
    
    var name: String {
        switch self {
        case .asset:
            return "asset.sqlite3"
        case .log:
            return "log.sqlite3"
        }
    }
}


class Database {
    
    static let shared = Database()
    fileprivate var assetConnection: SQLite.Connection!
    fileprivate var logConnection: SQLite.Connection!
    
    // Mark: Init
    public init() {
        do {
            try self.open(type: .asset)
            try self.open(type: .log)
            
        } catch DbError.OpenData(let message) {
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
                
                switch type {
                case .asset:
                    self.assetConnection = db
                case .log:
                    self.logConnection = db
                }
                
                DDLogInfo("Database \(type.name) was successfully opened.")
                self.prepareModels(type: type)
                
            } catch {
                throw DbError.OpenData(message: error.localizedDescription)
            }
            
        } else {
            throw DbError.OpenData(message: "Database \(type.name) directory not found.")
        }
    }
    
    fileprivate func prepareModels(type: DatabaseType) {
        do {
            
            switch type {
            case .asset:
                try self.prepareAsset()
            case .log:
                try self.prepareLog()
            }
            
        } catch DbError.Prepare(message: let message) {
            DDLogError("Error preparing model: \(message)")
        
        } catch {
            DDLogError(error.localizedDescription)
        }
    }
    
    fileprivate func prepareAsset() throws {
        do {
            let assets = Table("Asset")
            try self.assetConnection.run(assets.create(ifNotExists: true) { t in
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
                
                t.column(id, primaryKey: .autoincrement)
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
            
        } catch {
            throw DbError.Prepare(message: error.localizedDescription)
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
            throw DbError.Prepare(message: error.localizedDescription)
        }
    }
}
