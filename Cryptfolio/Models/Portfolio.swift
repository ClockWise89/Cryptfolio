//
//  Portfolio.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-11-30.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation

class Portfolio {
    let id: Int
    var name: String
    var transactions: [Transaction]
    
    init(id: Int, name: String, transactions: [Transaction] ) {
        self.id = id
        self.name = name
        self.transactions = transactions
    }
    
    static func Build() {
        // Use this to build from database maybe
    }
}
