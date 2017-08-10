//
//  LoginViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-08.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import CocoaLumberjack
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthenticationManager.shared.addStateListener() { (success) in
            if success {
                self.performSegue(withIdentifier: "showLoggedIn", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AuthenticationManager.shared.removeStateListener()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard let email = self.emailTextField.text, email != "", let password = self.passwordTextField.text, password != "" else {
            DDLogDebug("Email and/or password was faulty")
            return
        }
        
        AuthenticationManager.shared.signIn(email: email, password: password)
    }
}
