//
//  CryptoCompareService.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import CocoaLumberjack

class CryptoCompareService{
    let apiService: ApiService
    
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func coinList() -> Promise<[Coin]> {
        return Promise { fulfill, reject in
            self.apiService.baseRequest(method: .get, url: "/coinlist").then { response -> Void in
                
                var coins: [Coin] = []
                if let json = response.json {
                    coins = ParseManager.parseCoinList(json: json)
                }
                
                DDLogDebug("Request fetched \(coins.count) objects")
                
                fulfill(coins)
                
                }.catch { error in
                    reject(error)
            }
        }
    }
}
