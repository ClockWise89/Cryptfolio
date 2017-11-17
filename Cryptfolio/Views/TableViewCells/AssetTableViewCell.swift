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
    var containerView: UIView!
    var didSetupConstraints = false

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add subviews
        self.containerView = UIView()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.clipsToBounds = true
        self.addSubview(self.containerView)
        
        self.iconImageView = UIImageView()
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.iconImageView)
        
        self.tickerLabel = UILabel()
        self.tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tickerLabel.textAlignment = .left
        self.containerView.addSubview(self.tickerLabel)
        
        self.fullnameLabel = UILabel()
        self.fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.fullnameLabel)
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        
        if (!self.didSetupConstraints) {
            self.iconImageView.autoSetDimensions(to: CGSize(width: 34.0, height: 34.0))
            self.iconImageView.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
            self.iconImageView.autoAlignAxis(.horizontal, toSameAxisOf: self)
            
            self.containerView.autoAlignAxis(.horizontal, toSameAxisOf: self)
            self.containerView.autoPinEdge(toSuperviewMargin: .top)
            self.containerView.autoPinEdge(toSuperviewMargin: .bottom)
            self.containerView.autoPinEdge(.left, to: .right, of: self.iconImageView, withOffset: 8.0)
            self.containerView.autoPinEdge(toSuperviewMargin: .right)
    
            self.fullnameLabel.autoPinEdge(toSuperviewEdge: .top)
            self.fullnameLabel.autoPinEdge(toSuperviewMargin: .right)
            self.fullnameLabel.autoPinEdge(toSuperviewEdge: .left)
            self.fullnameLabel.autoPinEdge(.bottom, to: .top, of: self.tickerLabel)
            
            self.tickerLabel.autoPinEdge(toSuperviewEdge: .right)
            self.tickerLabel.autoPinEdge(toSuperviewEdge: .left)
            self.tickerLabel.autoPinEdge(toSuperviewEdge: .bottom)
            self.tickerLabel.autoMatch(.width, to: .width, of: self.fullnameLabel)
            
            self.didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        DDLogError("Init(coder:) has not been implemented")
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        self.tickerLabel.font = UIFont(name: self.tickerLabel.font.fontName, size: 12.0)
        self.fullnameLabel.font = UIFont(name: self.fullnameLabel.font.fontName, size: 14.0)
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
