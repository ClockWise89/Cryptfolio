//
//  HoldingsViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit
import PureLayout

class HoldingsViewController: UIViewController {
    var portfolioTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.style()
        self.portfolioTableView.register(PortfolioTableViewCell.getNib(), forCellReuseIdentifier: Constants.Cells.portfolio)
        self.portfolioTableView.delegate = self
        self.portfolioTableView.dataSource = self
    }
    
    private func setupViews() {
        // Setup tableView
        self.portfolioTableView = UITableView()
        self.portfolioTableView.delegate = self
        self.portfolioTableView.dataSource = self
        self.view.addSubview(self.portfolioTableView);
        
        // Setup constraints for tableView
        self.portfolioTableView.autoPinEdgesToSuperviewEdges()
    }
    
    private func style() {
        self.view.backgroundColor = UIColor.cfColor(.mineShaft)
        self.portfolioTableView.layer.cornerRadius = 5.0
        self.portfolioTableView.clipsToBounds = true
    }
}


// MARK: - UITableViewDelegate and UITableViewDataSource
extension HoldingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.portfolio, for: indexPath) as! PortfolioTableViewCell
        cell.setup(number: indexPath.row)
        
        return cell
    }
}
