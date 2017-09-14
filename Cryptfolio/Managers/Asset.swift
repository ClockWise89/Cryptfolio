//
//  Asset.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import SQLite

enum AssetStatus {
    case added
    case deleted
}

class Asset {
    let id: Int
    let ticker: String
    let name: String
    let fullname: String
    let status: AssetStatus
    
    init(id: Int, ticker: String, name: String, fullname: String, status: AssetStatus) {
        self.id = id
        self.ticker = ticker
        self.name = name
        self.fullname = fullname
        self.status = status
    }
}
