//
//  Transaction.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-12-01.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import CocoaLumberjack
import SQLite

enum TransactionType {
    case createdByUser
    case createdByBlockchain
    
    var description: String {
        switch  self {
        case .createdByUser: return "createdByUser"
        case .createdByBlockchain: return "createdByBlockchain"
        }
    }
}

class Transaction {
    let id: Int64
    let asset: Asset
    let timestamp: Double
    let type: TransactionType
    let fromAddress: String
    let toAddress: String
    let amount: Double
    
    init(id: Int64, asset: Asset, timestamp: Double, type: TransactionType, fromAddress: String, toAddress: String, amount: Double) {
        self.id = id
        self.asset = asset
        self.timestamp = timestamp
        self.type = type
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.amount = amount
    }
    
    static func AddTransactionToDB(asset: Asset, timestamp: Double, type: TransactionType, fromAddress: String, toAddress: String, amount: Double) -> Transaction? {
        guard let db = Database.shared.fetchConnection(type: .cryptofolio) else {
            DDLogWarn("Attempted to save Transaction to Database: Database connection is nil!")
            return nil
        }
        
        do {
            let table = Table("Transaction")
            let db_asset_id = Expression<Int64>("assetId")
            let db_timestamp = Expression<Double>("timestamp")
            let db_type = Expression<String>("type")
            let db_from_address = Expression<String>("fromAddress")
            let db_to_address = Expression<String>("toAddress")
            let db_amount = Expression<Double>("amount")
            
            let rowId = try db.run(table.insert(db_asset_id <- asset.id, db_timestamp <- timestamp, db_type <- type.description, db_from_address <- fromAddress, db_to_address <- toAddress, db_amount <- amount))
            DDLogInfo("Transaction with id \(rowId) was added to database successfully.")
    
            return Transaction(id: rowId, asset: asset, timestamp: timestamp, type: type, fromAddress: fromAddress, toAddress: toAddress, amount: amount)
            
        } catch {
            DDLogError("Unable to add Transaction to database: \(error.localizedDescription)")
            return nil
        }
    }
}
