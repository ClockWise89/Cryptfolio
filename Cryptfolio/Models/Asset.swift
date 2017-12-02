//
//  Asset.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import SQLite
import CocoaLumberjack

class Asset {
    let id: Int64
    let ticker: String
    let name: String
    let fullname: String
    
    fileprivate init(id: Int64, ticker: String, name: String, fullname: String) {
        self.id = id
        self.ticker = ticker
        self.name = name
        self.fullname = fullname
    }
    
    static func AddAssetToDB(id: Int64, ticker: String, name: String, fullname: String) throws -> Asset? {
        guard let db = Database.shared.fetchConnection(type: .cryptofolio) else {
            DDLogWarn("Attempted to save Asset to Database: Database connection is nil!")
            return nil
        }
        
        do {
            let query = "insert or replace into 'asset' ('id', 'ticker', 'name', 'fullname') values (\(id), '\(ticker)', '\(name)', '\(fullname)')"
            try db.run(query)
            DDLogDebug("Asset with id \(db.lastInsertRowid) was added or updated successfully.")
            
            return Asset(id: id, ticker: ticker, name: name, fullname: fullname)
            
        } catch let Result.error(message: message, code: _, statement: _) {
            DDLogError("Unable to add asset: \(message)")
            return nil
        }
    }
    
    static func apiIdExists(apiId: Int64) -> Bool {
        guard let db = Database.shared.fetchConnection(type: .cryptofolio) else {
            DDLogWarn("Attempted to check apiId \(apiId): Database connection is nil!")
            return false
        }
        
        do {
            let table = Table("Asset")
            let db_api_id = Expression<Int64>("apiId")
            let count = try db.scalar(table.where(db_api_id == apiId).count)
            return count > 0
            
        } catch {
            DDLogError("Unable to check apiId from database: \(error.localizedDescription)")
            return false
        }
    }
    
    static func fetchAssetByApiId(apiId: Int64) -> Asset? {
        guard let db = Database.shared.fetchConnection(type: .cryptofolio) else {
            DDLogWarn("Attempted to fetch Asset with apiId \(apiId): Database connection is nil!")
            return nil
        }
        
        do {
            let table = Table("Asset")
            let db_id = Expression<Int64>("id")
            let db_ticker = Expression<String>("ticker")
            let db_name = Expression<String>("name")
            let db_fullname = Expression<String>("fullname")
            
            var asset: Asset?
            for a in try db.prepare(table.where(db_id == apiId)) {
                asset = Asset(id: a[db_id], ticker: a[db_ticker], name: a[db_name], fullname: a[db_fullname])
            }
            
            if (asset != nil) {
                DDLogDebug("Found asset with id \(apiId)")
            }
            
            return asset
            
        } catch {
            DDLogError("Unable to fetch asset from database: \(error.localizedDescription)")
            return nil
        }
    }
}
