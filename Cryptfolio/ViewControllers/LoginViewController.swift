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
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.style()
        
        AuthenticationManager.shared.addStateListener() { (success) in
            if success {
                self.performSegue(withIdentifier: "showMain", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AuthenticationManager.shared.removeStateListener()
    }
    
    private func style() {
        self.view.backgroundColor = UIColor.cfColor(.white)
        self.separatorView.backgroundColor = UIColor.cfColor(.concrete)
        self.signInButton.layer.cornerRadius = 5.0
        self.signInButton.clipsToBounds = true
        self.signInButton.backgroundColor = UIColor.cfColor(.black)
        self.signInButton.setTitle("Sign in", for: .normal)
        self.signInButton.setTitleColor(UIColor.cfColor(.white), for: .normal)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        guard let email = self.emailTextField.text, email != "", let password = self.passwordTextField.text, password != "" else {
            DDLogDebug("Email and/or password was faulty")
            return
        }
        
        AuthenticationManager.shared.signIn(email: email, password: password)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
    }
}
