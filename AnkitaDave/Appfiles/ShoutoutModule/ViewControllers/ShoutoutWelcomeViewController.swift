//
//  ShoutoutWelcomeViewController.swift
//  AnveshiJain
//
//  Created by Apple on 14/10/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit
import AVKit

import CoreSpotlight
import MobileCoreServices
import SafariServices

class ShoutoutWelcomeViewController: BaseViewController {
    
    // MARK: - Constants.
    
    // MARK: - Properties.
    var navigateTo: ShoutoutWelcomeNavigation?
    var greetingTitle: String?
    var projects:[[String]] = []

    // MARK: - IBOutlets.
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var greetingsTitle: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var requestVGInfoLabel: UILabel!
    @IBOutlet weak var enterRoomButton: UIButton!
    @IBOutlet weak var termsAndCondButton: UIButton!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var howItWorksLabel: UILabel!
    
    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkbox.isSelected = ShoutoutConfig.UserDefaultsManager.hasUserAcceptedShoutoutTerms()
        coinsLabel.text = "\(ShoutoutConfig.coinsToRequestVG)"
        projects.append( [String ((ShoutoutConfig.coinsToRequestVG))] )
        index(item: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !ShoutoutConfig.isUserLoggedIn() {
            ShoutoutConfig.UserDefaultsManager.updateShoutoutTermsAcceptStatus(status: false)
        }
    }
    
    // MARK: - IBActions.
    @IBAction func didTapCheckbox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        ShoutoutConfig.UserDefaultsManager.updateShoutoutTermsAcceptStatus(status: sender.isSelected)
    }
    
    @IBAction func didTapTermsAndCond(_ sender: UIButton) {
        openTermsAndCond()
    }
    func loginPopPopd() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPopPopViewController") as! LoginPopPopViewController
            self.addChild(popOverVC)
            popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            popOverVC.textLabel.text = "Hey there! log in right now to connect with me"
            popOverVC.coinsView.isHidden = true
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
    }
    @IBAction func didTapHowItWorks(_ sender: UIButton) {
        ShoutoutUtilities.playVideoInAVPlayerController(videoUrl: ShoutoutConfig.howItWorksVideoURL, viewController: self, delegate: self)
    }
    
    @IBAction func didTapEnterRoom(_ sender: UIButton) {
        if !checkbox.isSelected {
            Alert.show(in: self, title: "", message: "Please agree to terms and conditions.", actionTitle: "Okay", cancelTitle: nil, comletionForAction: nil)
            return
        }
        
        if !ShoutoutConfig.isUserLoggedIn() {
           loginPopPopd()
            ShoutoutConfig.UserDefaultsManager.updateShoutoutTermsAcceptStatus(status: false)
            return
        }
        
        ShoutoutConfig.UserDefaultsManager.updateWelcomeScreenVisibility(shouldShow: false)
        
        let greetingsLandingPage = Storyboard.videoGreetings.instantiateViewController(viewController: VideoGreetingsViewController.self)
        greetingsLandingPage.greetingTitle = greetingTitle
        
        // Handle Navigation when VC is in the TabBarController.
        if var viewControllers = tabBarController?.viewControllers, let index = viewControllers.firstIndex(where: { $0 is ShoutoutWelcomeViewController }), let tabItem = tabBarItem {
            
            greetingsLandingPage.tabBarItem = tabItem
            viewControllers[index] = greetingsLandingPage
            
            tabBarController?.viewControllers = viewControllers
            
            // Handle Navigation when VC is in the NavigationController.
        } else if var viewControllers = navigationController?.viewControllers, let _ = viewControllers.firstIndex(where: { $0 is ShoutoutWelcomeViewController }) {
            
            viewControllers.removeAll { $0 is ShoutoutWelcomeViewController }
            
            if let navigateToVC = navigateTo {
                switch navigateToVC {
                case .toRequestGreeting:
                    viewControllers.append(greetingsLandingPage)
                case .toMyGreetings:
                    viewControllers.append(Storyboard.videoGreetings.instantiateViewController(viewController: MyGreetingsViewController.self))
                }
            } else {
                viewControllers.append(greetingsLandingPage)
            }
            
            navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
}

// MARK: - Custom Methods
extension ShoutoutWelcomeViewController {
    fileprivate func setupView() {
        
        title = greetingTitle
        
        greetingsTitle.text = greetingTitle?.localizedCapitalized ?? "Celebyte"
        projects.append( [String ((greetingsTitle.text ?? ""))] )
               projects.append( [String ((greetingTitle?.localizedCapitalized ?? "Celebyte"))] )
               
               index(item: 0)
        // Fonts.
        howItWorksLabel.font = ShoutoutFont.regular.withSize(size: .smaller)
        coinsLabel.font = ShoutoutFont.regular.withSize(size: .medium)
        //greetingsTitle.font = ShoutoutFont.regular.withSize(size: .smaller) // Set italic.
        //requestVGInfoLabel.font = ShoutoutFont.medium.withSize(size: .medium).italic // Set italic.
        enterRoomButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .medium)
        termsAndCondButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .medium)
        termsAndCondButton.setAttributedTitle("Terms & Conditions".underlinedAtrributed(font: ShoutoutFont.regular.withSize(size: .small), color: UIColor.white), for: .normal)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.artistConfigLoaderHandler = { [weak self] hasConfigLoaded in
                if hasConfigLoaded == true {
                    self?.coinsLabel.text = "\(ShoutoutConfig.coinsToRequestVG)"
                }
            }
        }
        
        navigationItem.rightBarButtonItems = nil
    }
    
    fileprivate func openTermsAndCond() {
        let termsAndCond = Storyboard.videoGreetings.instantiateViewController(viewController: TermsAndCondWebViewController.self)
        termsAndCond.termsCondAcceptHandler = { [weak self] (_) in
            self?.checkbox.isSelected = ShoutoutConfig.UserDefaultsManager.hasUserAcceptedShoutoutTerms()
        }
        let navigationCont = NavigationBarUtils.setupNavigationController(rootViewController: termsAndCond)
        present(navigationCont, animated: true, completion: nil)
    }
}

extension ShoutoutWelcomeViewController: AVPlayerViewControllerDelegate { }

enum ShoutoutWelcomeNavigation {
    case toRequestGreeting
    case toMyGreetings
}

// MARK: - Custom Methods.
extension ShoutoutWelcomeViewController {
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

