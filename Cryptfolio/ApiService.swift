//
//  ApiService.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import CocoaLumberjack
import SwiftyJSON

enum CustomError: Error {
    case notFound
    case timeout
    case networkError
}

class ApiService {
    fileprivate let alamofireManager: SessionManager
    fileprivate let kTimeOutLimit = 30.0
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = self.kTimeOutLimit
        configuration.timeoutIntervalForResource = self.kTimeOutLimit
        
        self.alamofireManager = SessionManager(configuration: configuration)
    }
    
    func baseRequest(method: HTTPMethod, url: String, parameters: Parameters? = nil) -> Promise<ServiceResponse> {
        var headers: HTTPHeaders = [:]
        headers["Content-Type"] = "application/json; charset=UTF-8"
        
        let appendedUrl = ApiManager.baseURL + url
        let request = self.alamofireManager.request(appendedUrl, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        return self.handleRequest(request: request)
    }
    
    fileprivate func handleRequest(request: DataRequest) -> Promise<ServiceResponse> {
        return Promise { fulfill, reject -> Void in
            request.validate().responseJSON { response in
               
                DDLogDebug("Request: \(String(describing: String(response.request!.httpMethod!))) \(String(describing: response.request!.url!.absoluteString))")
                
                switch response.result {
                case .success:
                    fulfill(self.success(response: response))
                    
                case .failure(let error):
                    reject(self.failure(response: response, withError: error))
                }
            }
        }
    }
    
    private func success(response: DataResponse<Any>) -> ServiceResponse {
        let json = JSON(response.result.value ?? [])
        let result = ServiceResponse(json: json, statusCode: response.response?.statusCode)
        result.data = response.data
        
        return result
    }
    
    private func failure(response: DataResponse<Any>, withError error: Error) -> Error {
        return error
    }
}
