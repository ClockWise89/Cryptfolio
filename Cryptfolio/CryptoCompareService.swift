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
    
    func coinList() -> Promise<[Asset]> {
        return Promise { fulfill, reject in
            self.apiService.baseRequest(method: .get, url: "/coinlist").then { response -> Void in
                
                var assets: [Asset] = []
                if let json = response.json {
                    assets = ParseManager.parseCoinList(json: json)
                }
                
                DDLogDebug("Request fetched \(assets.count) objects")
                
                fulfill(assets)
                
                }.catch { error in
                    reject(error)
            }
        }
    }
}
