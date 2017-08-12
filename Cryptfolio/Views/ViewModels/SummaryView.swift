//
//  SummaryView.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit

@IBDesignable
class SummaryView: UIView {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
 
    var view : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
    }
    
    func xibSetup() {
        self.view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        self.view.frame = bounds
        
        // Make the view stretch with containing view
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(self.view)
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func style(shouldBePercentage: Bool) {
        // Temporary bool just for show
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        if shouldBePercentage {
            self.topLabel.text = "Total ROI this year"
            self.middleLabel.text = "12,45 %"
            self.middleLabel.textColor = UIColor.cfColor(.dodgerBlue)
            self.bottomLabel.text = "394 USD"
        } else {
            self.topLabel.text = "Total value"
            self.middleLabel.text = "15 345 USD"
            self.middleLabel.textColor = UIColor.cfColor(.black)
            self.bottomLabel.text = "Avail. for investment \n1 541 USD"
        }
    }
}
