//
//  LoggedInViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-08.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import FirebaseAuth

class LoggedInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        AuthenticationManager.shared.signOut() { (success) in
            if success {
                self.performSegue(withIdentifier: "showLogin", sender: nil)
                // Do clean up
            }
        }
    }
}
