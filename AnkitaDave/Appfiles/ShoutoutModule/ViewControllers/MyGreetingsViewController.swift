//
//  MyGreetingsViewController.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import Shimmer

import CoreSpotlight
import MobileCoreServices
import SafariServices

class MyGreetingsViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    fileprivate var pageNumber: Int = 0
    fileprivate var selectedFilter: GreetingListFilter = .all
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate var totalItems: Int?
    fileprivate var shimmers: [FBShimmeringView] = []
    fileprivate var greetingList: [GreetingList] = [] {
        didSet {
            if greetingList.count > 0 {
                tableView.hideNoDataView()
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - IBOutlets.
    @IBOutlet var filterView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    var projects:[[String]] = []

    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = " "
        // Do any additional setup after loading the view.
        setupView()
        showPlaceholderView()
        didFetchGreetingList(filter: .all, resetAndFetch: true)
    }
    
    // MARK: - IBActions.
    @IBAction func didTapFilter(_ sender: UIButton) {
        
        let filterOptions = SelectionDataSource(section: nil, rows: GreetingListFilter.allValues.map { $0.rawValue }.map { SelectionRow(title: $0)})
        let selectionProperties = SelectionViewProperties()
        selectionProperties.backgroundColor = UIColor.darkGray
        selectionProperties.textColor = UIColor.white
        selectionProperties.font = ShoutoutFont.regular.withSize(size: .small)
        selectionProperties.doneFont = ShoutoutFont.medium.withSize(size: .small)
        
        let selectionMenu = SelectionView(anchorView: sender, type: .filter, dataSource: [filterOptions], properties: selectionProperties)
        selectionMenu.show(preSelectedIndices: [IndexPath(row: selectedFilter.index(), section: 0)]) { [unowned self] (selectedIndices) in
            if let index = selectedIndices?.first?.row {
                self.selectedFilter = GreetingListFilter.filterForIndex(index: index)
                self.didFetchGreetingList(filter: self.selectedFilter, resetAndFetch: true, showLoader: true)
            }
        }
    }
}

// MARK: - Custom Methods.
extension MyGreetingsViewController {
    fileprivate func setupView() {
        title = "My Requests"
        projects.append( [String ("My Greetings")] )

        view.setGradientBackground()
        placeholderView.setGradientBackground()
        refreshControl.addTarget(self, action: #selector(refreshGreetingsData(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(#imageLiteral(resourceName: "VG_Filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(didTapFilterBarButton(_:)), for: .touchUpInside)
        let filterBarItem = UIBarButtonItem(customView: filterButton)
        navigationItem.rightBarButtonItem = filterBarItem
        
        // Placeholder View.
        placeholderView.subviews.forEach { (subView) in
            let shimmer = FBShimmeringView(frame: subView.frame)
            shimmer.contentView = subView
            placeholderView.addSubview(shimmer)
            shimmers.append(shimmer)
            index(item: 0)

        }
    }
    
    fileprivate func showPlaceholderView() {
        placeholderView.isHidden = false
        shimmers.forEach { (shimmer) in
            shimmer.isShimmering = true
        }
    }
    
    fileprivate func hidePlaceholderView() {
        placeholderView.isHidden = true
        shimmers.forEach { (shimmer) in
            shimmer.isShimmering = false
        }
    }
    
    @objc fileprivate func refreshGreetingsData(_ sender: Any) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] () in
            self.didFetchGreetingList(filter: self.selectedFilter, resetAndFetch: true, showLoader: true)
        }
    }
    
    @objc fileprivate func didTapFilterBarButton(_ sender: UIButton) {
        let filterOptions = SelectionDataSource(section: nil, rows: GreetingListFilter.allValues.map { $0.rawValue }.map { SelectionRow(title: $0)})
        let selectionProperties = SelectionViewProperties()
        selectionProperties.backgroundColor = .black//UIColor.lightGray
        selectionProperties.textColor = UIColor.white
        selectionProperties.font = ShoutoutFont.light.withSize(size: .small)
        selectionProperties.doneFont = ShoutoutFont.regular.withSize(size: .small)
        selectionProperties.rowHeight = 65.0
        selectionProperties.offset = CGPoint(x: 5.0, y: -5.0)
        
        let selectionMenu = SelectionView(anchorView: sender, type: .filter, dataSource: [filterOptions], properties: selectionProperties)
        selectionMenu.show(preSelectedIndices: [IndexPath(row: selectedFilter.index(), section: 0)]) { [unowned self] (selectedIndices) in
            if let index = selectedIndices?.first?.row {
                self.selectedFilter = GreetingListFilter.filterForIndex(index: index)
                self.didFetchGreetingList(filter: self.selectedFilter, resetAndFetch: true, showLoader: true)
            }
        }
    }
}

// MARK: - Web services.
extension MyGreetingsViewController {
    fileprivate func didFetchGreetingList(filter: GreetingListFilter, resetAndFetch: Bool = false, showLoader: Bool = false) {
        if resetAndFetch {
            pageNumber = 0
            greetingList.removeAll()
        }
        
        pageNumber = pageNumber + 1
        var parameters: [String: Any] = ["page": pageNumber]
        
        if filter != .all {
            parameters["txn_type"] = filter.keyForFilter()
        }
        if showLoader {
            ShoutoutConfig.inAppShowLoader()
        }
        WebService.shared.callGetMethod(endPoint: .greetingList, parameters: parameters, responseType: VGGreetingsResponseModel.self) { [weak self] (response, error) in
            DispatchQueue.main.async {
                 if showLoader {
                                   ShoutoutConfig.inAppHideLoader()
                               }
            }
            self?.hidePlaceholderView()
            self?.totalItems = response?.data?.paginate?.total
            
            if let greetings = response?.data?.list, greetings.count > 0 {
                self?.greetingList.append(contentsOf: greetings)
            } else if (self?.greetingList.count ?? 0) <= 0 {
                var errorMessage = "No Greetings Found"
                if let internetError = error as? WebServiceError, internetError == .internetError {
                    errorMessage = AlertMessages.internetConnectionError
                }
                self?.tableView.showNoDataView(title: errorMessage, color: .white)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.loaderAtFooter(show: false)
                self?.refreshControl.endRefreshing()
            }
        }
    }
}

// MARK: - UITableView DataSource and Delegate methods.
extension MyGreetingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return greetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withCell: MyGreetingsTableViewCell.self) else { return UITableViewCell() }
        
        cell.greetingData = greetingList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetails = Storyboard.videoGreetings.instantiateViewController(viewController: OrderDetailsViewController.self)
        orderDetails.orderType = greetingList[indexPath.row].order
        navigationController?.pushViewController(orderDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let totalElements = totalItems, totalElements > (indexPath.row + 1), indexPath.row == greetingList.count - 1 {
            
            tableView.loaderAtFooter(show: true)
            didFetchGreetingList(filter: selectedFilter)
        }
    }
}

fileprivate enum GreetingListFilter: String {
    case all = "All"
    case received = "Received"
    case pending = "Pending"
    case denied = "Declined"
    
    func keyForFilter() -> String {
        switch self {
        case .all:
            return ""
        case .received:
            return OrderStatusKeys.completed
        case .pending:
            return OrderStatusKeys.pending
        case .denied:
            return OrderStatusKeys.denied
        }
    }
    
    func index() -> Int {
        return GreetingListFilter.allValues.index(of: self) ?? GreetingListFilter.allValues.count - 1
    }
    
    static let allValues: [GreetingListFilter] = [.received, .pending, .denied, .all]
    
    static func filterForIndex(index: Int)-> GreetingListFilter {
        return index < GreetingListFilter.allValues.count ? GreetingListFilter.allValues[index] : GreetingListFilter.all
    }
}

// MARK: - Custom Methods.
extension MyGreetingsViewController {
    func index(item:Int) {
        
        let project = projects[item]
        let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attrSet.title = project[0]
        //attrSet.contentDescription = project[1]
        attrSet.contentDescription = project[0]
        
        let item = CSSearchableItem(
            uniqueIdentifier: "\(item)",
            domainIdentifier: "kho.arthur",
            attributeSet: attrSet )
        
        CSSearchableIndex.default().indexSearchableItems( [item] )
        { error in
            
            if let error = error
            { print("Indexing error: \(error.localizedDescription)")
            }
            else
            { print("Search item successfully indexed.")
            }
        }
        
    }
    
    
    func deindex(item:Int) {
        
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"])
        { error in
            
            if let error = error
            { print("Deindexing error: \(error.localizedDescription)")
            }
            else
            { print("Search item successfully removed.")
            }
        }
        
    }
     
}
