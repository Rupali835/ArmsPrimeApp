//
//  WaitListViewController.swift
//  VideoGreetings
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import SafariServices

class WaitListViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    var greetingsStatsData: VGGreetingUsageStatsModel?
    var peopleInWaitlist: Int = 157
    var projects:[[String]] = []

    
    // MARK: - IBOutlets.
    @IBOutlet weak var waitListTitleLabel: UILabel!
    @IBOutlet weak var joinWaitListButton: UIButton!
    @IBOutlet weak var waitListDescriptionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    // MARK: - IBActions.
    @IBAction func didTapJoinWaitlist(_ sender: UIButton) {
        let requestGreeting = Storyboard.videoGreetings.instantiateViewController(viewController: RequestGreetingViewController.self)
        navigationController?.pushViewController(requestGreeting, animated: true)
    }
    
    fileprivate func setupView() {
        backgroundImageView.image = ShoutoutConfig.waitListBackgroundImage
        //backgroundImageView.addGradientOverlay(direction: .bottomToTop, scale: 0.6)
        
        waitListTitleLabel.font = ShoutoutFont.regular.withSize(size: .large)
        waitListDescriptionLabel.font = ShoutoutFont.regular.withSize(size: .largeTitle)
        joinWaitListButton.titleLabel?.font = ShoutoutFont.bold.withSize(size: .medium)
        
        //waitListDescriptionLabel.text = "\(peopleInWaitlist) People ahead of you!"
        waitListDescriptionLabel.text = greetingsStatsData?.message ?? "You are on waitlist\nPlease come back again"
        
        // Hide waitlist Button and Label.
        joinWaitListButton.isHidden = true
        waitListTitleLabel.isHidden = true
        projects.append( [ ("Greetings Status")] )
        projects.append( [String (waitListDescriptionLabel.text ?? "" )] )
        projects.append( [String (greetingsStatsData?.message ?? "You are on waitlist\nPlease come back again")] )

        index(item: 0)
    }
}

// MARK: - Custom Methods.
extension WaitListViewController {
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

