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

class CryptoCompareService{
    let apiService: ApiService
    
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func coinList() -> Promise<Void> {
        return Promise { fulfill, reject in
            self.apiService.baseRequest(method: .get, url: "coinlist").then { response -> Void in
                
                fulfill()
                
                }.catch { error in
                    reject(error)
            }
        }
    }
}
