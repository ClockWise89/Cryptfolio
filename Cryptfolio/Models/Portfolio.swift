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
    var assets: [Asset]
    
    init(id: Int, name: String, assets: [Asset] ) {
        self.id = id
        self.name = name
        self.assets = assets
    }
}
