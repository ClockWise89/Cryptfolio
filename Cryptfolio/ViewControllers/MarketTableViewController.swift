//
//  MarketTableViewController.swift
//  Cryptfolio
//
//  Created by Christopher Eliasson on 2017-08-12.
//  Copyright © 2017 Celiasson. All rights reserved.
//

import UIKit

class MarketTableViewController: UITableViewController {
    
    var assets: [Asset] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0) // Adjust for the status bar
        
        self.tableView.register(AssetTableViewCell.getNib(), forCellReuseIdentifier: Constants.Cells.asset)
        self.fetchAssets()
    }
    
    private func fetchAssets() {
        ApiManager.shared.cryptoCompareService.coinList().then { assets -> Void in
            self.assets = assets
            self.tableView.reloadData()
            
            }.catch{ error in
                // Handle error
        }
    }

}

extension MarketTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.Cells.asset, for: indexPath) as! AssetTableViewCell
        cell.setup(asset: self.assets[indexPath.row])
        
        return cell
    }
}
