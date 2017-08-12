//
//  ServiceResponse.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation
import SwiftyJSON


class ServiceResponse {
    var data: Data?
    var json: JSON?
    var statusCode: Int?

    
    init(json: JSON?, statusCode: Int?) {
        self.json = json
        self.statusCode = statusCode
    }
}
