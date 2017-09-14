//
//  ApiManager.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    static let baseURL = "https://www.cryptocompare.com/api/data"
    
    let apiService: ApiService
    let cryptoCompareService: CryptoCompareService

    // Mark: Init    
    public init(apiService: ApiService) {
        self.apiService = apiService
        self.cryptoCompareService = CryptoCompareService(apiService: apiService)
    }
    
    public convenience init() {
        self.init(apiService: ApiService())
    }
    
}
