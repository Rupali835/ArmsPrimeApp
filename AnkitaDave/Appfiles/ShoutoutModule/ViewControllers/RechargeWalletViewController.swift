//
//  RechargeWalletViewController.swift
//  VideoGreetings
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

class RechargeWalletViewController: UIViewController {
    // MARK: - Constants.
    fileprivate let coins: [String] = ["120", "250", "500", "1000", "1500"]
    fileprivate let costOfCoins: [String] = ["₹650", "₹1000", "₹1450", "₹1900", "₹2300", "₹3000"]
    
    // MARK: - Properties.
    
    // MARK: - IBOutlets.
    @IBOutlet var tableHeader: UIView!
    @IBOutlet weak var coinsInWalletLabel: UILabel!
    @IBOutlet var tableFooter: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    // MARK: - IBActions.
    @IBAction func didTapRechargeNow(_ sender: UIButton) {
    }
}

// MARK: - Custom Methods.
extension RechargeWalletViewController {
    fileprivate func setupView() {
        title = "Recharge Wallet".uppercased()
        
        tableHeader.frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 150.0)
        tableFooter.frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 70.0)
        
        tableView.tableHeaderView = tableHeader
        tableView.tableFooterView = tableFooter
    }
}

// MARK: - UITableView DataSource and Delegate methods.
extension RechargeWalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withCell: RechargeWalletTableViewCell.self) else { return UITableViewCell() }
        
        cell.coinsLabel.text = coins[indexPath.row]
        cell.costLabel.text = costOfCoins[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

