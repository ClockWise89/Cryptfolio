//
//  Coin.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-09-13.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation

class Coin {
    let id: Int
    let overviewUrl: String
    let imageUrl: String
    let ticker: String
    let name: String
    let fullname: String
    
    
    init(id: Int, overviewUrl: String, imageUrl: String, ticker: String, name: String, fullname: String) {
        self.id = id
        self.overviewUrl = overviewUrl
        self.imageUrl = imageUrl
        self.ticker = ticker
        self.name = name
        self.fullname = fullname
    }
}
