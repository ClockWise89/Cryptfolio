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
import PureLayout

class AssetTableViewCell: UITableViewCell {

    var iconImageView: UIImageView!
    var tickerLabel: UILabel!
    var fullnameLabel: UILabel!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.iconImageView = UIImageView()
        self.addSubview(self.iconImageView)
        
        self.iconImageView.autoPinEdge(toSuperviewMargin: .left)
        self.iconImageView.autoPinEdge(toSuperviewMargin: .top)
        self.iconImageView.autoSetDimensions(to: CGSize(width: 30.0, height: 30.0))
        
        self.tickerLabel = UILabel()
        self.addSubview(self.tickerLabel)
        
        self.tickerLabel.autoPinEdge(toSuperviewMargin: .bottom)
        self.tickerLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 8)
        self.tickerLabel.autoPinEdge(.top, to: .bottom, of: self.iconImageView, withOffset: 2.0)
        self.tickerLabel.autoAlignAxis(.horizontal, toSameAxisOf: self.iconImageView)
        self.tickerLabel.autoSetDimension(.width, toSize: 40.0)
        self.tickerLabel.autoSetDimension(.height, toSize: 14.5)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        DDLogDebug("Init(coder:) has not been implemented")
        fatalError("init(coder:) has not been implemented")
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
        //self.fullnameLabel.text = coin.fullname
    }
}
