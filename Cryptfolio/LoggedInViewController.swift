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
        do {
            try Auth.auth().signOut()
            DDLogError("Signing out.")
            self.performSegue(withIdentifier: "showLogin", sender: nil)
            
        } catch let signOutError as NSError {
            DDLogError("There was an error signing out: \(signOutError.debugDescription)")
        }
    }

}
