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

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If we do not have a stored token -> Go to LoginViewController
        DDLogDebug("Token was not found. Will show LoginViewController")
        self.performSegue(withIdentifier: "showLogin", sender: nil)
    }
}

