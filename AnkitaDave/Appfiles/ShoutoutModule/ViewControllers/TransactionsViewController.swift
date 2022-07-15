//
//  TransactionsViewController.swift
//  AnveshiJain
//
//  Created by Apple on 04/10/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    fileprivate var passbookList: [PassbookList] = [] {
        didSet {
            if passbookList.count > 0 {
                tableView.hideNoDataView()
            }
            tableView.reloadData()
        }
    }
    fileprivate var totalItems: Int?
    fileprivate var pageNumber: Int = 0
    fileprivate var selectedPassbookFilter: PassbookFilterTypes = .all
    fileprivate var selectedItem: (row: Int, shouldExpand: Bool)?
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var hasLoadedOfflineData: Bool = false
    
    // MARK: - IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var walletBalanceTitle: UILabel!
    @IBOutlet weak var accountBalanceTitle: UILabel!
    @IBOutlet weak var rechargeWalletTitleLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var rechargeWalletView: UIView!
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        didFetchCustomerPassbook(filter: .all, showLoader: true)
        
        webUpdateWalletBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        coinsLabel.text = "\(ShoutoutConfig.currentCoins)"
    }
    
    // MARK: - IBActions.
    @IBAction func didTapFilter(_ sender: UIButton) {
        let filterOptions = SelectionDataSource(section: nil, rows: PassbookFilterTypes.allFilters.map { $0.filterTitle() }.map { SelectionRow(title: $0)})
        let selectionProperties = SelectionViewProperties()
        selectionProperties.backgroundColor = .black//UIColor.lightGray
        selectionProperties.textColor = UIColor.white
        selectionProperties.font = ShoutoutFont.light.withSize(size: .small)
        selectionProperties.doneFont = ShoutoutFont.regular.withSize(size: .small)
        selectionProperties.rowHeight = 65.0
        
        let selectionMenu = SelectionView(anchorView: sender, type: .filter, dataSource: [filterOptions], properties: selectionProperties)
        selectionMenu.show(preSelectedIndices: [IndexPath(row: selectedPassbookFilter.index(), section: 0)]) { [unowned self] (selectedIndices) in
            // Reset Pagination and fetch list.
            guard let selectedIndex = selectedIndices?.first?.row else { return }
            self.selectedItem = (0, false)
            self.selectedPassbookFilter = PassbookFilterTypes.filterForIndex(index: selectedIndex)
            self.didFetchCustomerPassbook(filter: self.selectedPassbookFilter, resetAndFetch: true, showLoader: true)
        }
    }
    
    @IBAction func didTapRechargeNow(_ sender: UIButton) {
        let rechargeVC = Storyboard.main.instantiateViewController(viewController: PurchaseCoinsViewController.self)
        navigationController?.pushViewController(rechargeVC, animated: true)
    }
    
    @IBAction func didTapInfo(_ sender: UIButton) {
        
    }
}

// MARK: - Custom Methods.
extension TransactionsViewController {
    fileprivate func setupView() {
        
        title = "Wallet"
        self.view.setGradientBackground()
        rechargeWalletView.setGradientBackground()
        
        accountBalanceTitle.font = ShoutoutFont.medium.withSize(size: .custom(18.0))
        coinsLabel.font = ShoutoutFont.bold.withSize(size: .custom(20.0))
        coinsLabel.text = "\(ShoutoutConfig.currentCoins)"
        historyLabel.font = ShoutoutFont.bold.withSize(size: .custom(20.0))
        rechargeWalletTitleLabel.font = ShoutoutFont.bold.withSize(size: .medium)
        
        refreshControl.addTarget(self, action: #selector(refreshTransactionsData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
    }
    
    @objc fileprivate func refreshTransactionsData(_ sender: Any) {
        
        didFetchCustomerPassbook(filter: selectedPassbookFilter, resetAndFetch: true, showLoader: false)
    }
}

// MARK: - Web Services.
extension TransactionsViewController {
    fileprivate func didFetchCustomerPassbook(filter: PassbookFilterTypes, resetAndFetch: Bool = false, showLoader: Bool = false) {
        
        if resetAndFetch {
            pageNumber = 0
            passbookList.removeAll()
        }
        
        pageNumber = pageNumber + 1
        var parameters: [String: Any] = ["artist_id": ShoutoutConfig.artistID,
                          "platform": ShoutoutConfig.platform,
                          "page": pageNumber]
        if filter != .all {
            parameters["txn_type"] = filter.keyForFilter()
        }
        
        WebService.shared.callGetMethod(endPoint: .customerPassbook, parameters: parameters, responseType: PassbookResponseModel.self, showLoader: showLoader) { [weak self] (response, error) in
            
            self?.totalItems = response?.data?.paginate_data?.total
            
            if let passbook = response?.data?.list, passbook.count > 0 {
                // Filter passbook list to remove invalid Passbook Objects having nil data.
                let filteredPassbook = passbook.filter { $0.total_coins != nil }
                self?.passbookList.append(contentsOf: filteredPassbook)
                self?.hasLoadedOfflineData = false
                for (index, passbookItem) in filteredPassbook.enumerated() {
                    let shouldDeletePreviousOfflinePassbook = ((parameters["page"] as? Int) == 1) && (index == 0) && (self?.selectedPassbookFilter == .all)
                    DatabaseManager.sharedInstance.savePassbookListLocally(transaction: passbookItem, deletePreviousData: shouldDeletePreviousOfflinePassbook)
                }
            } else if (self?.passbookList.count ?? 0) <= 0 {
                if let internetError = error as? WebServiceError, internetError == .internetError {
                    if let offlinePassbookList = DatabaseManager.sharedInstance.getLocallySavedPassbookList(), offlinePassbookList.count > 0  {
                        self?.passbookList = offlinePassbookList
                        self?.hasLoadedOfflineData = true
                    }
                } else {
                    self?.tableView.showNoDataView(title: "No Transaction History", color: .white)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.loaderAtFooter(show: false)
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UITableView DataSource and Delegate Methods.
extension TransactionsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passbookList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandedHeight: CGFloat = 170.0
        let normalHeight: CGFloat = 85.0
        
        if let item = selectedItem {
            if item.row == indexPath.row {
                
                return item.shouldExpand ? expandedHeight : normalHeight
            } else {
                return normalHeight
            }
        } else {
           
            return normalHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withCell: TransactionsTableViewCell.self) else { return UITableViewCell() }
        
        var isExpanded: Bool = false
        
        if selectedItem?.row == indexPath.row {
            isExpanded = selectedItem?.shouldExpand ?? false
        }
        cell.configureCell(data: passbookList[indexPath.row], isExpanded: isExpanded)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if passbookList[indexPath.row].txn_type == PassbookFilterTypes.paid.rawValue {
            let cell = tableView.cellForRow(at: indexPath) as? TransactionsTableViewCell
            
            if let item = selectedItem {
                
                if item.row == indexPath.row {
                    selectedItem = (indexPath.row, !item.shouldExpand)
                } else {
                    let previousCell = tableView.cellForRow(at: IndexPath(row: item.row, section: 0)) as? TransactionsTableViewCell
                    previousCell?.setupArrow(type: passbookList[item.row].txn_type, isExpanded: false)
                    selectedItem = (indexPath.row, true)
                }
            } else {
                selectedItem = (indexPath.row, true)
            }
            
            cell?.setupArrow(type: passbookList[indexPath.row].txn_type, isExpanded: selectedItem?.shouldExpand ?? false)
            
            tableView.beginUpdates()
            tableView.endUpdates()
        } else {
//            let transactionDetails = Storyboard.videoGreetings.instantiateViewController(viewController: TransactionDetailsViewController.self)
//            transactionDetails.passbookData = passbookList[indexPath.row]
//            navigationController?.pushViewController(transactionDetails, animated: true)
            let mainstoryboad:UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
            let transactionDetails = mainstoryboad.instantiateViewController(withIdentifier: "TransactionsDetailsViewController") as! TransactionsDetailsViewController
            transactionDetails.passbookData = passbookList[indexPath.row]
            navigationController?.pushViewController(transactionDetails, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        if let totalElements = totalItems, totalElements > (indexPath.row + 1), indexPath.row == passbookList.count - 1, hasLoadedOfflineData == false {
            
            tableView.loaderAtFooter(show: true)
            didFetchCustomerPassbook(filter: selectedPassbookFilter)
        }
    }
}

enum PassbookFilterTypes: String {
    case paid = "paid"
    case added = "added"
    case received = "received"
    case all = "all"
    
    static func status(for string: String?) -> PassbookFilterTypes? {
        guard let type = string else { return nil }
        
        switch type {
        case PassbookFilterTypes.paid.rawValue:
            return PassbookFilterTypes.paid
        case PassbookFilterTypes.added.rawValue:
            return PassbookFilterTypes.added
        case PassbookFilterTypes.received.rawValue:
            return PassbookFilterTypes.received
        default:
            return nil
        }
    }
    
    func keyForFilter() -> String {
        switch self {
        case .all:
            return ""
        case .paid:
            return PassbookFilterTypes.paid.rawValue
        case .added:
            return PassbookFilterTypes.added.rawValue
        case .received:
            return PassbookFilterTypes.received.rawValue
        }
    }
    
    func filterTitle() -> String {
        switch self {
        case .all:
            return "All"
        case .paid:
            return "Spending"
        case .added:
            return "Added"
        case .received:
            return "Received"
        }
    }
    
    func index() -> Int {
        return PassbookFilterTypes.allFilters.index(of: self) ?? PassbookFilterTypes.allFilters.count - 1
    }
    
    static let allFilters: [PassbookFilterTypes] = [.all, .received, .paid, .added]
    
    static func filterForIndex(index: Int)-> PassbookFilterTypes {
        return index < PassbookFilterTypes.allFilters.count ? PassbookFilterTypes.allFilters[index] : PassbookFilterTypes.all
    }
}

// MARK: - Web Service Methods
extension TransactionsViewController {
    
    func webUpdateWalletBalance() {
        
        ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.getCoins, extraHeader: nil) { [weak self] (result) in
            switch result {
            case .success(let data):
                print(data)
                
                if (data["error"] as? Bool == true) {
                    // self.showToast(message: "Something went wrong. Please try again!")
                    return
                }
                else {
                    
                    if let coins = data["data"]["coins"].int {
                        
                        CustomerDetails.coins = coins
                        
                        let database = DatabaseManager.sharedInstance
                        database.updateCustomerCoins(coinsValue: coins)
                        
                        let coinDict:[String: Int] = ["updatedCoins": coins]
                                   
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatedCoins"), object: nil, userInfo: coinDict)
                        
                        self?.coinsLabel.text = "\(ShoutoutConfig.currentCoins)"
                    }
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
