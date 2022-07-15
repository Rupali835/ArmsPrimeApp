//
//  OrderDetailsViewController.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

import CoreSpotlight
import MobileCoreServices
import SafariServices


class OrderDetailsViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    var orderType: GreetingOrderType?
    
    // MARK: - IBOutlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helpButton: UIButton!
    var projects:[[String]] = []
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    // MARK: - IBActions.
    @IBAction func didTapHelp(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "HelpAndSupportViewController") as! HelpAndSupportViewController
        if let order = orderType {
            switch order {
            case .request(_, let data):
                resultViewController.PurchaseId = data?.passbook_id ?? ""
            default: break
            }
        }

        resultViewController.isFromShoutout = true
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
}

// MARK: - Custom Methods.
extension OrderDetailsViewController {
    fileprivate func setupView() {
        title = "Order Details"
        projects.append( [("Order Details")] )

        self.view.setGradientBackground()
        tableView.registerNib(withCell: VGRequestDetailsTableViewCell.self)
        tableView.registerNib(withCell: VGPaymentSuccessfulTableViewCell.self)
        tableView.registerNib(withCell: VGPendingTableViewCell.self)
        tableView.registerNib(withCell: VGApprovedTableViewCell.self)
        tableView.registerNib(withCell: VGFeedbackTableViewCell.self)
        tableView.registerNib(withCell: VGDeclinedTableViewCell.self)
        tableView.registerNib(withCell: VGSendDetailsTableViewCell.self)
        tableView.registerNib(withCell: VGDeclinedTableViewCell.self)
        tableView.registerNib(withCell: VGReplySentTableViewCell.self)
        tableView.registerNib(withCell: VGReceivedTableViewCell.self)
        
        helpButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .small)
        helpButton.setAttributedTitle("Need Help?".underlinedAtrributed(font: ShoutoutFont.regular.withSize(size: .small), color: UIColor.white), for: .normal)
        projects.append( [String ("Need Help?")] )
         index(item: 0)
    }
}

// MARK: - UITableView DataSource and Delegate methods.
extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderType?.totalCells() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let order = orderType, let cell = order.getCell(tableView: tableView, indexPath: indexPath) else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is VGReceivedTableViewCell, let order = orderType {
            let viewGreeting = Storyboard.videoGreetings.instantiateViewController(viewController: ViewVideoGreetingViewController.self)
            
            switch order {
            case .request(_, let data):
                viewGreeting.greetingData = data
                
            default: break
            }
            
            //navigationController?.pushViewController(viewGreeting, animated: true)
        }
    }
}

// MARK: - Custom Methods.
extension OrderDetailsViewController {
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
