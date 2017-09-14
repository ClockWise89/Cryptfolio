//
//  DateExtension.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-09-14.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import Foundation

extension Date {
    func asDouble() -> Double {
        return self.timeIntervalSince1970
    }
}
