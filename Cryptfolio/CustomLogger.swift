//
//  Extension.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-09-13.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import CocoaLumberjack
import Foundation

class CustomLogger : NSObject, DDLogFormatter {
    
    func format(message logMessage: DDLogMessage) -> String? {
        var logLevel: String
        switch logMessage.flag {
        case DDLogFlag.debug: logLevel = "[DEBUG]"
        case DDLogFlag.info: logLevel = "[INFO]"
        case DDLogFlag.warning: logLevel = "[WARNING]"
        case DDLogFlag.error: logLevel = "[ERROR]"
        default: logLevel = "[VERBOSE]"
        }
        
        return "\(logMessage.timestamp) \(logLevel) - [\(logMessage.fileName)] [Line \(logMessage.line)]: \(logMessage.message)"
    }
}
