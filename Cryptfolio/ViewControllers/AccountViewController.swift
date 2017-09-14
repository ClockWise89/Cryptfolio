//
//  AccountViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressedLogout(_ sender: Any) {
        AuthenticationManager.shared.signOut() { (success) in
            self.performSegue(withIdentifier: "showLogin", sender: self)
        }
        
    }
}
