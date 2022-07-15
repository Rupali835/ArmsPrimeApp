//
//  VideoGreetingsViewController.swift
//  VideoGreetings
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit
import AVKit

import CoreSpotlight
import MobileCoreServices
import SafariServices

class VideoGreetingsViewController: BaseViewController {

    // MARK: - Constants.
    
    // MARK: - Properties.
    fileprivate var greetingsStats: GreetingStats?
    fileprivate var greetingsStatsData: VGGreetingUsageStatsModel?
    var greetingTitle: String?
     var projects:[[String]] = []
    // MARK: - IBOutlets.
    @IBOutlet weak var requestGreetingsButton: UIButton!
    @IBOutlet weak var sendGreetingsButton: UIButton!
    @IBOutlet weak var requestVGCoinLabel: UILabel!
    @IBOutlet weak var sendVGCoinLabel: UILabel!
    @IBOutlet weak var tAndCButton: UIButton!
    @IBOutlet weak var sendVGDescription: UILabel!
    @IBOutlet weak var myGreetingLabel: UILabel!
    @IBOutlet weak var requestVGDescription: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var greetingNotificationLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var howItWorksButton: UIButton!
    @IBOutlet weak var requestButtonTitleLabel: UILabel!
    @IBOutlet weak var poweredByLabel: UILabel!
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationView(title: "CELEBYTE")
        projects.append( [ ("CELEBYTE")] )
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        requestVGCoinLabel.text = "\(ShoutoutConfig.coinsToRequestVG)"
        if ShoutoutConfig.isUserLoggedIn() {
            didFetchGreetingUsageStats()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        requestGreetingsButton.centerImageAndTitleVertically()
        sendGreetingsButton.centerImageAndTitleVertically()
    }
    
    // MARK: - IBActions.
    @IBAction func didTapRequestVG(_ sender: UIButton) {
        if !ShoutoutConfig.isUserLoggedIn() {
           self.loginPopPop()
            return
        }
        
        if let remainingGreetingQuota = greetingsStats?.quota_remaining, remainingGreetingQuota > 0 {
            let requestGreeting = Storyboard.videoGreetings.instantiateViewController(viewController: RequestGreetingViewController.self)
            navigationController?.pushViewController(requestGreeting, animated: true)
        } else {
            let waitList = Storyboard.videoGreetings.instantiateViewController(viewController: WaitListViewController.self)
            waitList.greetingsStatsData = greetingsStatsData
            navigationController?.pushViewController(waitList, animated: true)
        }
    }
    
    @IBAction func didTapSendVG(_ sender: UIButton) {
    }
    
    @IBAction func didTapCheckbox(_ sender: UIButton) {
    }
    
    @IBAction func didTapMyGreetings(_ sender: UIButton) {
        let myGreetings = Storyboard.videoGreetings.instantiateViewController(viewController: MyGreetingsViewController.self)
        navigationController?.pushViewController(myGreetings, animated: true)
    }
    
    @IBAction func didTapHowItWorks(_ sender: UIButton) {
        ShoutoutUtilities.playVideoInAVPlayerController(videoUrl: ShoutoutConfig.howItWorksVideoURL, viewController: self, delegate: self)
    }
    
    @IBAction func didTapTermsAndConditions(_ sender: UIButton) {
        openTermsAndCond()
    }
}

// MARK: - Custom Methods.
extension VideoGreetingsViewController {
    fileprivate func setupView() {
        
        requestVGDescription.text = "Request personalized viedo message from \(ShoutoutConfig.artistName)"
        requestVGCoinLabel.text = "\(ShoutoutConfig.coinsToRequestVG)"
        
        backgroundImageView.image = ShoutoutConfig.vgHomeBackgroundImage
        
        requestVGDescription.font = ShoutoutFont.regular.withSize(size: .small)
        requestVGCoinLabel.font = ShoutoutFont.medium.withSize(size: .medium)
        requestGreetingsButton.titleLabel?.font = ShoutoutFont.medium.withSize(size: .small)
        sendVGDescription.font = ShoutoutFont.regular.withSize(size: .small)
        sendVGCoinLabel.font = ShoutoutFont.medium.withSize(size: .medium)
        sendGreetingsButton.titleLabel?.font = ShoutoutFont.medium.withSize(size: .small)
        requestButtonTitleLabel.font = ShoutoutFont.medium.withSize(size: .small)
        
        myGreetingLabel.font = ShoutoutFont.regular.withSize(size: .small)
        tAndCButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .small)
        howItWorksButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .small)
        howItWorksButton.setAttributedTitle("Watch Personalized Video".underlinedAtrributed(font: ShoutoutFont.regular.withSize(size: .small)), for: .normal)
        greetingNotificationLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        
        requestGreetingsButton.centerImageAndTitleVertically()
        sendGreetingsButton.centerImageAndTitleVertically()
        projects.append( [String (greetingTitle?.localizedCapitalized ?? "Celebyte")] )
                      projects.append( [String ( requestVGDescription.text ?? "")] )
                      projects.append( [String ("Request personalized video greetings from \(ShoutoutConfig.artistName)")] )
                      projects.append( [String ("\(ShoutoutConfig.coinsToRequestVG)")] )
                      projects.append( [ ("How it works")] )
                      index(item: 0)
        checkboxButton.isSelected = ShoutoutConfig.UserDefaultsManager.hasUserAcceptedShoutoutTerms()
        poweredByLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.artistConfigLoaderHandler = { [weak self] hasConfigLoaded in
                if hasConfigLoaded == true {
                    self?.requestVGCoinLabel.text = "\(ShoutoutConfig.coinsToRequestVG)"
                }
            }
        }
    }
    
    fileprivate func openTermsAndCond() {
        let termsAndCond = Storyboard.videoGreetings.instantiateViewController(viewController: TermsAndCondWebViewController.self)
        termsAndCond.termsCondAcceptHandler = { [weak self] (_) in
            self?.checkboxButton.isSelected = ShoutoutConfig.UserDefaultsManager.hasUserAcceptedShoutoutTerms()
        }
        let navigationCont = NavigationBarUtils.setupNavigationController(rootViewController: termsAndCond)
        present(navigationCont, animated: true, completion: nil)
    }
}

// MARK: - Web Services.
extension VideoGreetingsViewController {
    fileprivate func didFetchGreetingUsageStats() {
        let paramters = ["artist_id": ShoutoutConfig.artistID,
                         "platform": ShoutoutConfig.platform,
                         "v": ShoutoutConfig.version]
        
        WebService.shared.callGetMethod(endPoint: .greetingsUsageStats, parameters: paramters, responseType: VGGreetingUsageStatsModel.self, showLoader: true) { [weak self] (response, error) in
        
            if let greetingsStats = response?.data?.shoutout {
                self?.greetingsStats = greetingsStats
            }
            self?.greetingsStatsData = response
        }
    }
}

// MARK: - AVPlayerViewController Delegate.
extension VideoGreetingsViewController: AVPlayerViewControllerDelegate { }

// MARK: - Custom Methods.
extension VideoGreetingsViewController {
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
