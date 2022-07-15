//
//  ProceedToPayViewController.swift
//  VideoGreetings
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import UIKit

import CoreSpotlight
import MobileCoreServices
import SafariServices


class ProceedToPayViewController: UIViewController {
    // MARK: - Constants.
    
    // MARK: - Properties.
    var requestParameters: Dictionary<String, Any>?
    var doesSelectedDateResultInsufficientTime: Bool = false
    fileprivate let containerHeight: CGFloat = 320
    
    // MARK: - IBOutlets.
    @IBOutlet weak var coinsStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var coinsInstructionLabel: UILabel!
    @IBOutlet weak var proceedToPayButton: UIButton!
    @IBOutlet weak var rechargeInstructionLabel: UILabel!
    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var rechargeNowView: UIView!
    @IBOutlet weak var rechargeInfoLabel: UILabel!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionLabelForInsufficientDeadline: UILabel!
    @IBOutlet weak var insufficientTimeButtonsStack: UIStackView!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var insufficientTimeProceedButton: UIButton!
    @IBOutlet weak var requiredCoinsButtonLabel: UILabel!
    @IBOutlet weak var payButtonLabel: UILabel!
    @IBOutlet weak var proceedButtonStackView: UIStackView!
    var projects:[[String]] = []

    // MARK: - View Lifecycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rechargeInfoLabel.text = ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG ? nil : "You do not have sufficient coins. Please recharge."
        rechargeInfoLabel.isHidden = ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG
        containerHeightConstraint.constant = ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG ? containerHeight - 20.0 : containerHeight
        
        if doesSelectedDateResultInsufficientTime {
            setupViewForInsufficientDuration()
        } else {
           setupViewForRecommendedDuration()
        }
        projects.append( [String ( rechargeInfoLabel.text ?? "")] )
        projects.append( [String ( (ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG ? nil : "You do not have sufficient coins. Please recharge.") ?? "")] )

        index(item: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if containerView.alpha != 1.0 {
            presentView()
        }
    }
    
    // MARK: - IBActions.
    @IBAction func didTapProceedToPay(_ sender: UIButton) {
        if ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG {
            didCallSendVGRequestAPI()
        } else {
            ShoutoutConfig.InAppNavigation.toPurchaseCoin(inViewController: self)
        }
    }
    
    @IBAction func didTapRechargeNow(_ sender: UIButton) {
        ShoutoutConfig.InAppNavigation.toPurchaseCoin(inViewController: self)
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismissView()
    }
}

// MARK: - Custom Methods.
extension ProceedToPayViewController {
    fileprivate func setupView() {
        backgroundImageView.image = ShoutoutConfig.proceedToPayBackgroundImage
        //backgroundImageView.addGradientOverlay(direction: .bottomToTop, scale: 0.6)
        
        coinsLabel.font = ShoutoutFont.bold.withSize(size: .custom(30.0))
        coinsInstructionLabel.font = ShoutoutFont.medium.withSize(size: .large)
        proceedToPayButton.titleLabel?.font = ShoutoutFont.bold.withSize(size: .large)
        cancelButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .large)
        insufficientTimeProceedButton.titleLabel?.font = ShoutoutFont.bold.withSize(size: .large)
        goBackButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .large)
        payButtonLabel.font = ShoutoutFont.bold.withSize(size: .large)
        requiredCoinsButtonLabel.font = ShoutoutFont.bold.withSize(size: .large)
        instructionLabelForInsufficientDeadline.font = ShoutoutFont.medium.withSize(size: .small)
        
        rechargeInstructionLabel.font = ShoutoutFont.light.withSize(size: .small)
        rechargeButton.titleLabel?.font = ShoutoutFont.regular.withSize(size: .medium)
        
        coinsLabel.text = "\(ShoutoutConfig.coinsToRequestVG)"
        coinsInstructionLabel.text = "\(ShoutoutConfig.coinsToRequestVG) coins will be deducted from your wallet.\nSure, you want to proceed?"
        projects.append( [String (  coinsLabel.text ?? "")] )
                  projects.append( [String ( "\(ShoutoutConfig.coinsToRequestVG)")] )
                  projects.append( [String (  coinsInstructionLabel.text ?? "")] )
                  projects.append( [String ( "\(ShoutoutConfig.coinsToRequestVG) coins will be deducted from your wallet.\nSure, you want to proceed?")] )
                  index(item: 0)
        
        rechargeNowView.isHidden = true
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        containerView.alpha = 0.0
        
        // Add Tap gesture to the view to dismiss on tap.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewOnTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func navigateToOrderDetails(greetingData: GreetingList) {
        // Handle Navigation Stack.
        guard let presentingNavController = presentingViewController as? UINavigationController else { return }
        
        var viewControllerStack = presentingNavController.viewControllers
        
        viewControllerStack.removeAll(where:  { ($0 is ProceedToPayViewController || $0 is RequestGreetingViewController || $0 is WaitListViewController) ? true : false })
        
        let orderDetails = Storyboard.videoGreetings.instantiateViewController(viewController: OrderDetailsViewController.self)
        orderDetails.orderType = greetingData.order
        let myGreetings = Storyboard.videoGreetings.instantiateViewController(viewController: MyGreetingsViewController.self)
        
        viewControllerStack.append(contentsOf: [myGreetings, orderDetails])
        
        dismiss(animated: false) {
            presentingNavController.setViewControllers(viewControllerStack, animated: true)
        }
    }
    
    fileprivate func setupViewForInsufficientDuration() {
        instructionLabelForInsufficientDeadline.isHidden = false
        insufficientTimeButtonsStack.isHidden = false
        proceedButtonStackView.isHidden = ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG ? false : true
        insufficientTimeProceedButton.setTitle(ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG ? "" : "RECHARGE", for: .normal)
        requiredCoinsButtonLabel.text = "\(ShoutoutConfig.coinsToRequestVG)"
        projects.append( [String (  requiredCoinsButtonLabel.text ?? "")] )
               projects.append( [String ( "\(ShoutoutConfig.coinsToRequestVG)")] )
               index(item: 0)
        proceedToPayButton.isHidden = true
        coinsInstructionLabel.isHidden = true
        coinsStackView.isHidden = true
    }
    
    fileprivate func setupViewForRecommendedDuration() {
        let payButtonTitle = ShoutoutConfig.currentCoins >= ShoutoutConfig.coinsToRequestVG ? "PROCEED TO PAY" : "RECHARGE"
        
        proceedToPayButton.setTitle(payButtonTitle, for: .normal)
        proceedToPayButton.setTitle(payButtonTitle, for: .selected)
        proceedToPayButton.setTitle(payButtonTitle, for: .highlighted)
        
        instructionLabelForInsufficientDeadline.isHidden = true
        insufficientTimeButtonsStack.isHidden = true
        proceedButtonStackView.isHidden = true
    }
    
    fileprivate func presentView() {
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.alpha = 1.0
            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    fileprivate func dismissView() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.containerView.alpha = 0.0
        }, completion:{ [weak self] (finished) in
            if finished {
                self?.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    @objc fileprivate func dismissViewOnTap(_ recognizer: UITapGestureRecognizer) {
        dismissView()
    }
}

// MARK: - Web Services.
extension ProceedToPayViewController {
    fileprivate func didCallSendVGRequestAPI() {
        guard let parameters = requestParameters else { return }
        
        WebService.shared.callPostMethod(endPoint: .greetingRequest, parameters: parameters, responseType: VGRequestResponseModel.self, showLoader: true) { [weak self] (response, error) in
            if let greetingData = response?.data?.shoutout?.greetingData {
                
                Alert.show(in: self, title: "", message: response?.message, cancelTitle: nil, autoDismiss: true) { action in
                    if response?.error == false {
                        ShoutoutConfig.inAppHandleUpdateCoins(coins: response?.data?.passbook?.coins_after_txn)
                        self?.navigateToOrderDetails(greetingData: greetingData)
                    }
                }
            } else if (response?.errorMessages?.count ?? 0) > 0, let errorMessage = response?.errorMessages?.first {
                Alert.show(in: self, title: "", message: errorMessage, cancelTitle: nil, comletionForAction: nil)
            } else {
                Alert.show(in: self, title: "", message: "Something went wrong.", cancelTitle: nil, comletionForAction: nil)
            }
        }
    }
}

extension ProceedToPayViewController: UIGestureRecognizerDelegate, CAAnimationDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view ? true : false
    }
}

// MARK: - Custom Methods.
extension ProceedToPayViewController {
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
