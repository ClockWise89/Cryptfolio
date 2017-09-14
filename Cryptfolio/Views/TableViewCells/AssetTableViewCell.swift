//
//  AssetTableViewCell.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import Kingfisher
import CocoaLumberjack

class AssetTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!

    class func getNib() -> UINib {
        return UINib(nibName: "AssetTableViewCell", bundle: nil)
    }
    
    private func style() {
        // style
    }
    
    func setup(coin: Coin) {
        if let url = URL(string: Constants.Urls.imageUrl + coin.imageUrl) {
            self.iconImageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        } else {
            DDLogDebug("Could not create url from imageview")
        }
        
        self.tickerLabel.text = coin.ticker
        self.fullnameLabel.text = coin.fullname
    }
}
