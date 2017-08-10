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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthenticationManager.shared.addStateListener() { (hasCurrentUser) in
            if hasCurrentUser {
                self.performSegue(withIdentifier: "showLoggedIn", sender: nil)
            } else {
                self.performSegue(withIdentifier: "showLogin", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AuthenticationManager.shared.removeStateListener()
    }
}

