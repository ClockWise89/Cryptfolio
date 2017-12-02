//
//  Extension.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-09-13.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import CocoaLumberjack
import Foundation

// DDLogError("Error"); // Saved in log
// DDLogWarn("Warn"); // Saved in log
// DDLogInfo("Info"); // Saved in log. Use for User related logging.
// DDLogDebug("Debug"); // Not saved in log. Use for debug purposes.
// DDLogVerbose("Verbose"); // Not saved in log. No need to use.


class CustomLogger : NSObject, DDLogFormatter {
    
    func format(message logMessage: DDLogMessage) -> String? {
        var logLevel: String
        var saveToDb = false
        
        switch logMessage.flag {
        case DDLogFlag.debug:
            logLevel = "[DEBUG]"
        case DDLogFlag.info:
            logLevel = "[INFO]"
            saveToDb = true
        case DDLogFlag.warning:
            logLevel = "[WARNING]"
            saveToDb = true
        case DDLogFlag.error:
            logLevel = "[ERROR]"
            saveToDb = true
        default:
            logLevel = "[VERBOSE]"
        }
        
        let message = "\(logLevel) - [\(logMessage.fileName)] [Line \(logMessage.line)]: \(logMessage.message)"
        let timestamp = logMessage.timestamp.asDouble()
        
        if (saveToDb) {
            // Save to database
            do {
                try Database.shared.logToDatabase(timestamp: timestamp, message: message)
            } catch DbError.update(message: let message) {
                return "Unable to save log entry to database: \(message)"
            } catch {
                return "Unable to save log entry to database: \(error.localizedDescription)"
            }
        }
        
        return "\(logMessage.timestamp) \(message)"
    }
}
