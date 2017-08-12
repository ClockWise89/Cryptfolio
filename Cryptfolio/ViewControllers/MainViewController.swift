//
//  MainViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import CocoaLumberjack

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.styleTabBar()
        self.setupTabBar()
    }

    private func styleTabBar() {
        self.tabBar.barTintColor = UIColor.cfColor(.concrete)
        self.tabBar.isTranslucent = false
        
    }
    
    private func setupTabBar() {
        guard let items = self.tabBar.items else {
            DDLogDebug("There are no items in tabbar at setup.")
            return
        }
        
        var activeImage = UIImage()
        var inactiveImage = UIImage()
        
        for (index, item) in (items).enumerated() {
            
            switch index {
            case 0:
                activeImage = UIImage(named: "iconPortfolioActive")!
                inactiveImage = UIImage(named: "iconPortfolioInactive")!
            case 1:
                activeImage = UIImage(named: "iconMarketActive")!
                inactiveImage = UIImage(named: "iconMarketInactive")!
            case 2:
                activeImage = UIImage(named: "iconProfileActive")!
                inactiveImage = UIImage(named: "iconProfileInactive")!

            default: break
            }
            
            item.image = inactiveImage.withRenderingMode(.alwaysOriginal)
            item.selectedImage = activeImage.withRenderingMode(.alwaysOriginal)
            
            self.tabBar.tintColor = UIColor.cfColor(.black)
        }
    }
}
