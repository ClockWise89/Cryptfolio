//
//  HoldingsViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit

class HoldingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.style()
    }
    
    private func style() {
        self.view.backgroundColor = UIColor.cfColor(.mineShaft)
    }
}
