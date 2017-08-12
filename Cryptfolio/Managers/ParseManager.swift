//
//  ParseManager.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import SwiftyJSON
import Foundation
import CocoaLumberjack

class ParseManager {

    static func parseCoinList(json: JSON) -> [Asset] {
        var assets: [Asset] = []
        for (_, assetObject) in json["Data"] {
            
            let id = assetObject["Id"].intValue
            let overviewUrl = assetObject["Url"].stringValue
            let imageUrl = assetObject["ImageUrl"].stringValue
            let ticker = assetObject["Name"].stringValue
            let name = assetObject["CoinName"].stringValue
            let fullname = assetObject["FullName"].stringValue
            
            assets.append(Asset(id: id, overviewUrl: overviewUrl, imageUrl: imageUrl, ticker: ticker, name: name, fullname: fullname))
        }
        
        return assets
    }
}
