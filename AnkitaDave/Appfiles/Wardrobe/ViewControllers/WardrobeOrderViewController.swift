//
//  WardrobeOrderViewController.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 21/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import UIKit

class WardrobeOrderViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var vwNoOrder: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    // MARK: - Properties
    fileprivate var pageNumber: Int = 0
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var totalItems: Int?
    fileprivate var arrOrderList: [OrderList] = [] {
        didSet {
            if arrOrderList.count > 0 {
                vwNoOrder.isHidden = true
            }
            tblView.reloadData()
        }
    }
 
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        didFetchOrderList(resetAndFetch: true)
    }
}

// MARK: - Custom Methods
extension WardrobeOrderViewController {
    
    fileprivate func setupView() {
        
        title = "My Orders"
//        view.removeGradient()
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        setUpTableView()
    }
    
    fileprivate func setUpTableView() {
        
        tblView.registerNib(withCell: WardrobeOrderTableViewCell.self)
        tblView.delegate = self
        tblView.dataSource = self
        tblView.layoutMargins = UIEdgeInsets.zero
        tblView.separatorInset = UIEdgeInsets.zero
        tblView.refreshControl = refreshControl
    }
    
    @objc fileprivate func refreshOrderData(_ sender: Any) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] () in
            self.didFetchOrderList(resetAndFetch: true)
        }
    }
    
    @objc fileprivate func didTapHelpButton(_ sender: UIButton) {
        
        let helpAndSupportVC = Storyboard.main.instantiateViewController(viewController: HelpAndSupportViewController.self)
        
        if let id = arrOrderList[sender.tag]._id {
            helpAndSupportVC.PurchaseId = id
        }
        
        helpAndSupportVC.isFromTransDetails = true
        self.navigationController?.pushViewController(helpAndSupportVC, animated: true)
    }
}

// MARK: - UITableView DataSource and Delegate Methods
extension WardrobeOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WardrobeOrderTableViewCell.identifier, for: indexPath) as! WardrobeOrderTableViewCell
        
        cell.configurCell(order: arrOrderList[indexPath.row])
        
        cell.btnHelp.tag = indexPath.row
        cell.btnHelp.addTarget(self, action: #selector(didTapHelpButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        if let totalElements = totalItems, totalElements > (indexPath.row + 1), indexPath.row == arrOrderList.count - 1 {
            
            tableView.loaderAtFooter(show: true)
            didFetchOrderList()
        }
    }
}

// MARK: - Web Services
extension WardrobeOrderViewController {
    
    fileprivate func didFetchOrderList(resetAndFetch: Bool = false) {
        
        if resetAndFetch {
            pageNumber = 0
            arrOrderList.removeAll()
        }
        
        pageNumber = pageNumber + 1
        let parameters: [String: Any] = ["page": pageNumber]
        
        WebServiceHelper.shared.callGetMethod(endPoint: Constants.ordersList, parameters: parameters, responseType: OrdersResponseModel.self, showLoader: false) { [weak self] (response, error) in
            
            self?.totalItems = response?.data?.paginate_data?.total
 
            if let orders = response?.data?.lists, orders.count > 0 {
                self?.arrOrderList.append(contentsOf: orders)
            } else if (self?.arrOrderList.count ?? 0) <= 0 {
                self?.vwNoOrder.isHidden = false
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tblView.loaderAtFooter(show: false)
                self?.refreshControl.endRefreshing()
            }
        }
    }
}
