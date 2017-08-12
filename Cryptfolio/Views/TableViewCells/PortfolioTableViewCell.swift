//
//  PortfolioTableViewCell.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var liquidityLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!

    class func getNib() -> UINib {
        return UINib(nibName: "PortfolioTableViewCell", bundle: nil)
    }
    
    private func style(number: Int) {
        
        self.nameLabel.text = "Portfolio \(number)"
        self.liquidityLabel.text = "Avail. for investment 34 USD"
        self.valueLabel.text = "3 204 USD"
        self.percentageLabel.text = number % 2 == 0 ? "4,09 %" : "-2,47 %"
        self.percentageLabel.textColor = number % 2 == 0 ? UIColor.cfColor(.dodgerBlue) : UIColor.cfColor(.geraldineRed)
        
        self.iconImageView.image = number <= 2 ? UIImage(named: "iconPieChart_\(number)") : UIImage(named: "iconPieChart_1")
    }
    
    func setup(number: Int) {
        self.style(number: number)
    }
}
