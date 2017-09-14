//
//  AuthenticationManager.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-08.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import CocoaLumberjack
import FirebaseAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {} // Prevents others from using the default '()' initializer for this class.
    
    var authHandle: AuthStateDidChangeListenerHandle!
    var auth: Auth!
    
    private func initiateAuth() {
        self.auth = Auth.auth()
    }
    
    func addStateListener(callback: ((Bool) -> Void)?) {
        
        if self.auth == nil {
            self.initiateAuth()
        }
        
        self.authHandle = self.auth.addStateDidChangeListener { (auth, user) in
            
            if user != nil {
                DDLogInfo("User was successfully logged in.")
                callback?(true)
                
            } else {
                DDLogInfo("User was logged out.")
                callback?(false)
            }
        }
    }
    
    func removeStateListener() {
        self.auth.removeStateDidChangeListener(self.authHandle)
        self.authHandle = nil
    }
    
    func createUser(email: String, password: String) {
        
        self.auth.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                DDLogError("Create new user failed with error: \(String(describing: error == nil ? "Reason unknown" : error!.localizedDescription ))")
                
            } else {
                DDLogInfo("User was successfully created")
                
                if user != nil {
                    self.auth.signIn(withEmail: email, password: password)
                    DDLogDebug("Logging in after registration...")
                } else {
                    DDLogError("User was created, but was not logged in.")
                }
            }
        }
    }
    
    func signIn(email: String, password: String, callback: ((Bool) -> Void)? = nil) {
        DDLogDebug("Logging in...")
        self.auth.signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                DDLogDebug("Signing in successful.")
                callback?(true)
            } else {
                DDLogError("Signing in unsuccessful: \(String(describing: error == nil ? "Reason unknown" : error!.localizedDescription ))")
                callback?(false)
            }
        }
    }
    
    func signOut(callback: ((Bool) -> Void)? = nil) {
        do {
            try Auth.auth().signOut()
            DDLogError("Signing out.")
            callback?(true)
            
        } catch let signOutError as NSError {
            DDLogError("There was an error signing out: \(signOutError.debugDescription)")
            callback?(false)
        }
    }
    
}
