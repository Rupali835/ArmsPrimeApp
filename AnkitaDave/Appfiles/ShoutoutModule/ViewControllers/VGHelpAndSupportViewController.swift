//
//  HelpAndSupportViewController.swift
//  VideoGreetings
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import SafariServices

class VGHelpAndSupportViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    
    // MARK: - IBOutlets.
    @IBOutlet var tableHeader: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var issueTextView: UITextView!
    @IBOutlet weak var orderIdTitleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var writeIssueTitleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    var projects:[[String]] = []

    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    // MARK: - IBActions.
    @IBAction func didTapSubmit(_ sender: UIButton) {
    }
}

// MARK: - Custom Methods.
extension VGHelpAndSupportViewController {
    fileprivate func setupView() {
        title = "Help and Support".uppercased()
        projects.append( [ ("Help and Support")] )
        index(item: 0)
        tableHeader.frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 800.0)
        tableView.tableHeaderView = tableHeader
    }
}

// MARK: - UITableView DataSource and Delegate methods.
extension VGHelpAndSupportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withCell: HelpAndSupportTableViewCell.self) else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Custom Methods.
extension VGHelpAndSupportViewController {
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
