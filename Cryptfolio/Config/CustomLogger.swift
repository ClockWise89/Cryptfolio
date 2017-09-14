//
//  Extension.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-09-13.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import CocoaLumberjack
import Foundation

// DDLogVerbose("Verbose"); // Use for general information
// DDLogDebug("Debug"); // Use for debug purposes
// DDLogInfo("Info"); // Use for general important information
// DDLogWarn("Warn"); // Use for warnings
// DDLogError("Error"); // Use for errors

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
        
        let message = "\(logLevel) - [\(logMessage.fileName)] [Line \(logMessage.line)]: \(logMessage.message)"
        let timestamp = logMessage.timestamp.asDouble()
        
        
        // Save to database
        do {
            try Database.shared.logToDatabase(timestamp: timestamp, message: message)
        } catch DbError.update(message: let message) {
            DDLogError("Unable to save log entry to database: \(message)")
        } catch {
            DDLogError("Unable to save log entry to database: \(error.localizedDescription)")
        }
        
        return "\(logMessage.timestamp) \(message)"
    }
}
