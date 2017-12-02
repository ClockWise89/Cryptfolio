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

    static func parseCoinList(json: JSON) -> [Coin] {
        var coins: [Coin] = []
        DDLogVerbose(json.description)
        
        for (_, coinObject) in json["Data"] {
            
            let id = coinObject["Id"].int64Value
            let overviewUrl = coinObject["Url"].stringValue
            let imageUrl = coinObject["ImageUrl"].stringValue
            let ticker = coinObject["Name"].stringValue
            let name = coinObject["CoinName"].stringValue
            let fullname = coinObject["FullName"].stringValue
            
            coins.append(Coin(id: id, overviewUrl: overviewUrl, imageUrl: imageUrl, ticker: ticker, name: name, fullname: fullname))
        }
        
        return coins
    }
}
