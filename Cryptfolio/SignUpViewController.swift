//
//  SignUpViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-08.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import FirebaseAuth
import CocoaLumberjack

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var authHandler: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authHandler = Auth.auth()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.authHandler.addStateDidChangeListener { (auth, user) in
            if user != nil {
                DDLogDebug("User was successfully logged in.")
                self.performSegue(withIdentifier: "showLoggedIn", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.authHandler.removeStateDidChangeListener(self.authHandler)
        self.authHandler = nil
    }
    
    private func createUser(email: String, password: String) {
        
        self.authHandler.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                DDLogError("Create new user failed with error: \(String(describing: error == nil ? "Reason unknown" : error!.localizedDescription ))")
                
            } else {
                DDLogInfo("User was successfully created")
                
                if user != nil {
                    Auth.auth().signIn(withEmail: email, password: password)
                    DDLogDebug("Logging in after registration...")
                } else {
                    DDLogError("User was created, but was not logged in.")
                }
            }
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard let email = self.emailTextField.text, email != "", let password = self.passwordTextField.text, password != "" else {
            DDLogDebug("Email and/or password was faulty")
            return
        }
        
        self.createUser(email: email, password: password)
    }
}
