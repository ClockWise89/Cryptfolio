//
//  LaunchViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-08.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import Firebase
import CocoaLumberjack
import FirebaseAuth

class LaunchViewController: UIViewController {

    var authHandler: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.authHandler = Auth.auth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.authHandler.addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
                DDLogDebug("User is logged in.")
                
                self.performSegue(withIdentifier: "showLoggedIn", sender: nil)
            
            } else {
                self.performSegue(withIdentifier: "showLogin", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.authHandler.removeStateDidChangeListener(self.authHandler)
        self.authHandler = nil
    }
}

