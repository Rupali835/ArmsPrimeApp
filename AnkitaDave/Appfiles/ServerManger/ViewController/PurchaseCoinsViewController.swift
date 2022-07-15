//
//  PurchaseCoinsViewController.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 13/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyJSON
import SwiftyStoreKit
import MoEngage

class PurchaseCoinsViewController: BaseViewController {
    
    @IBOutlet weak var accountBalHeaderLabel: UILabel!
    @IBOutlet weak var coinListTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var privacyPolicyButton: UIButton!
//    @IBOutlet weak var purchaseCoinsTableView: UITableView!
//    @IBOutlet weak var historyView: UIView!
    //    var activity : UIActivityIndicatorView?
    
    @IBOutlet weak var coinInfoButton: UIButton!
    
    
    @IBOutlet weak var legalInfoLabel: UILabel!
    
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBOutlet weak var condtButton: UIButton!
    
    @IBOutlet weak var flowButton: UIButton!
    @IBOutlet weak var refundButton: UIButton!
    
    var pakages = [Package]() {
        didSet {
            coinListTableView.reloadData()
        }
    }
    var products = [SKProduct]()
    var currentProduct = SKProduct()
    var coins = 0
    var UpdatedCoins:String!
    var currentPackage:String!
    var updatedDate:String!
    var temporaryIds = [String]()

    //    var progressHUD = ProgressHUD(text: "loading...")
    private var overlayView = LoadingOverlay.shared
    var selectedIndex: IndexPath?
    var previousIndex: IndexPath?
    
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var historyButton: UIButton!
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    var exmpleForSomeoneElseView : UIView!
    
    @IBOutlet weak var heightOfScreen: NSLayoutConstraint!
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setProfileImageOnBarButton(onlyLiveButton: true)

        balanceView.layer.cornerRadius = 4
//        self.historyView.layer.cornerRadius = historyView.frame.size.width / 2
//        self.historyView.layer.masksToBounds = false
//        self.historyView.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
//        self.navigationItem.title = "Recharge wallet"

        self.coinListTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")

        self.setNavigationView(title: "Recharge wallet")
       
        getPackage()
        
        // CoinPackagesList.store.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCoins(_:)), name: NSNotification.Name(rawValue: "updatedCoins"), object: nil)
        
        coinListTableView.delegate = self
        coinListTableView.dataSource = self
//        if #available(iOS 10.0, *) {
//            coinListTableView.refreshControl = UIRefreshControl()
//            coinListTableView.refreshControl?.addTarget(self, action: #selector(PurchaseCoinsViewController.reload), for: .valueChanged)
//            coinListTableView.refreshControl?.tintColor = hexStringToUIColor(hex: MyColors.refreshControlTintColor)
//        } else {
//            //             Fallback on earlier versions
//        }
        //self.purchaseCoinsTableView.isScrollEnabled = false
        self.coinListTableView.rowHeight =  60
        
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseCoinsViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseCoinsViewController.handleFaildNotification(_:)),
                                               name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperFaildNotification),
                                               object: nil)
        currentBalanceLabel.text = "\(CustomerDetails.coins ?? 0)"
//        reload()
        // Do any additional setup after loading the view.
        
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        
        accountBalHeaderLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
        currentBalanceLabel.font = UIFont(name: AppFont.light.rawValue, size: 20.0)
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font :UIFont(name: "Raleway-Regular", size: 14.0)!,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,.foregroundColor:BlackThemeColor.yellow]
        
        let attributeString1 = NSMutableAttributedString(string: "What are Coins?",
                                                         attributes: yourAttributes)
        coinInfoButton.setAttributedTitle(attributeString1, for: .normal)
        
        
        legalInfoLabel.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        privacyButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        condtButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        refundButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
        flowButton.titleLabel?.font = UIFont(name: AppFont.regular.rawValue, size: 14.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GlobalFunctions.screenViewedRecorder(screenName: "Purchase Coins Screen")
        
    }

    @IBAction func didTapHistoryButton(_ sender: UIButton) {
        let transaction = Storyboard.videoGreetings.instantiateViewController(viewController: TransactionsViewController.self)
        navigationController?.pushViewController(transaction, animated: true)
    }
    
    func getPackage() {
        if Reachability.isConnectedToNetwork() == true {
            print("start get package")
            self.showLoader()
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.getPackages + Constants.artistId_platform, extraHeader: nil) { (result) in
                switch result {
                case .success(let data):
//                    print(data)
                    
                    if (data["error"] as? Bool == true) {
                       
//                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Failed to load packages from CDN. Error: \(data["error"])", extraParamDict: nil)
                        self.stopLoader()
                        self.showToast(message: "Something went wrong. Please try again!")
                        return
                        
                    } else {
                        var receivedPackages = [Package]()
                        if let pakages = data["data"]["list"].array {
                            for pakage in pakages {
                                if let packageDictionary = pakage.dictionaryObject {
                                    let pak = Package(dictionary: packageDictionary)
                                    receivedPackages.append(pak)
                                }
                            }
                        }
                        self.pakages = receivedPackages
                        self.reload()
//                        print(data)
                        print("get package called")
//                        self.stopLoader() //test
                        
                    }
                case .failure(let error):
                    self.stopLoader()
                    print(error)
                 
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: nil)
                }
            }
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
            
        }
    }
    func setUpdatedPackage() {
        let applePackage = products
        products = [SKProduct]()
        for product in applePackage {
            for package in pakages {
                if package.sku == product.productIdentifier {
                    products.append(product)
                    break
                }
            }
        }
        
//        self.products = applePackage.sorted(by: {($0.price.compare($1.price) == ComparisonResult.orderedAscending)})
        print("sort array @@@@@@ \(self.products.count)")
         DispatchQueue.main.async { [unowned self] in
            self.heightOfScreen.constant = CGFloat(344 + (60 * self.products.count))
            self.coinListTableView.reloadData()
        }
        
    }
    //MARK:-
    @objc func handleFaildNotification(_ notification: Notification) {
        guard let failureReason = notification.object as? String else { return }
        self.overlayView.hideOverlayView()
        print(failureReason)
        self.stopLoader()
      
//        CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: failureReason, extraParamDict: nil)
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        print(productID)
        print("called hundle purchase method")
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
//            coinListTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade) test
        }
    }
    
    //MARK:- Loader

    //MARK:- All button Action
    
    @IBAction func whatAreCoinAction(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "wallet_coin_info", extraParamDict: nil)
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoinsInformationViewController") as! CoinsInformationViewController
        
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.exmpleForSomeoneElseView = popOverVC.view
        self.exmpleForSomeoneElseView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.view.frame.size.height)
        self.view.addSubview(self.exmpleForSomeoneElseView)
        popOverVC.didMove(toParent: self)
    }
    func addCloseButton() {
        let button   = UIButton(type: UIButton.ButtonType.system) as UIButton
        //        button.backgroundColor = UIColor.black
        let image = UIImage(named: "closeIcon") as UIImage?
        button.frame = CGRect(x: 20, y: 75, width: 35, height: 35)
        //        button.layer.cornerRadius = button.frame.height/2
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(btnPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        button.isHidden = false
    }
    
    @objc func btnPressed(sender: UIButton!) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true

        sender.isHidden = true
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "wallet_privacy_policy", extraParamDict: nil)
        if Reachability.isConnectedToNetwork() {

            let armsPrimeWebView = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
            var str = ArtistConfiguration.sharedInstance().static_url?.privacy_policy ?? "http://www.armsprime.com/arms-prime-privacy-policy.html"
            if str.count == 0 {
                str = "http://www.armsprime.com/arms-prime-privacy-policy.html"
            }
            armsPrimeWebView.openUrl = str
            armsPrimeWebView.navigationTitle = "Privacy Policy"

            self.navigationController?.pushViewController(armsPrimeWebView, animated: true)

        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    @IBAction func historyButton(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "WalletPaginationViewController") as! WalletPaginationViewController
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    @IBAction func termsConditions(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "wallet_term_n_condtn", extraParamDict: nil)
        if Reachability.isConnectedToNetwork() {
            let armsPrimeWebView = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
            var str = ArtistConfiguration.sharedInstance().static_url?.terms_conditions ?? "http://armsprime.com/terms-conditions.html"
            if str.count == 0 {
                str = "http://armsprime.com/terms-conditions.html"
            }
            armsPrimeWebView.openUrl = str
            armsPrimeWebView.navigationTitle = "Terms & Conditions"

            self.navigationController?.pushViewController(armsPrimeWebView, animated: true)
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    @IBAction func cancellationRefundPolicy(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "wallet_refund", extraParamDict: nil)
        if Reachability.isConnectedToNetwork() {
            let armsPrimeWebView = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
            var str = ArtistConfiguration.sharedInstance().static_url?.cancellation_refund_policy ?? "http://www.armsprime.com/cancellation-refund-policy.html"
            if str.count == 0 {
                str = "http://www.armsprime.com/cancellation-refund-policy.html"
            }
            armsPrimeWebView.openUrl = str
            armsPrimeWebView.navigationTitle = "Cancellation & refund"
            self.navigationController?.pushViewController(armsPrimeWebView, animated: true)
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
    @IBAction func processFlow(_ sender: Any) {
        CustomMoEngage.shared.sendEventUIComponent(componentName: "wallet_processFlow", extraParamDict: nil)
        if Reachability.isConnectedToNetwork() {
            let armsPrimeWebView = Storyboard.main.instantiateViewController(viewController: WebViewViewController.self)
            var str = ArtistConfiguration.sharedInstance().static_url?.process_flow ?? "http://www.armsprime.com/process-flow.html"
            if str.count == 0 {
                str = "http://www.armsprime.com/process-flow.html"
            }
            armsPrimeWebView.openUrl = str
            armsPrimeWebView.navigationTitle = "Process flow"
            self.navigationController?.pushViewController(armsPrimeWebView, animated: true)
        } else
        {
            self.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    
//    @objc func reload() {
//        products = []
//        print("reload method before request product")
////        coinListTableView.reloadData() test
//        
//        if Reachability.isConnectedToNetwork() {
//            print("start request product api")
//            CoinPackagesList.store.requestProducts{success, products in
//                print("response of request product api")
//                if success {
//                    if let unsortedProducts = products?.sorted(by: {($0.price.compare($1.price) == ComparisonResult.orderedAscending)}) {
//                        self.products = unsortedProducts
//                    }
//                    DispatchQueue.main.async {
//                         self.coinListTableView.reloadData() //test
//                    }
//                   
//                    self.stopLoader() //new
//                     print("reload method after request product")
//                } else {
//                
////                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Error in loading packages from App Store.", extraParamDict: nil)
//                    
//                    print("Error in loading packages from App Store.")
//                }
//                
//                if #available(iOS 10.0, *) {
//                    self.coinListTableView.refreshControl?.endRefreshing()
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        } else {
//            self.coinListTableView.refreshControl?.endRefreshing()
//            self.showToast(message: Constants.NO_Internet_MSG)
//        }
//    }
    @objc func reload()  {
    products = []
    print("reload method before request product")
    //        coinListTableView.reloadData() test
    
    if Reachability.isConnectedToNetwork() {
    print("start request product api")
    CoinPackagesList.store.requestProducts{success, products in
    print("response of request product api")
    if success {
    if let unsortedProducts = products?.sorted(by: {($0.price.compare($1.price) == ComparisonResult.orderedAscending)}) {
    self.products = unsortedProducts
    }
    self.setUpdatedPackage()
        
        DispatchQueue.main.async { [weak self] in
            self?.coinListTableView.reloadData() //test
               self?.stopLoader() //new
        }
   
    print("reload method after request product")
    } else {
    
    //                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Error in loading packages from App Store.", extraParamDict: nil)
    print("Error in loading packages from App Store.")
    }
    
    if #available(iOS 10.0, *) {
        DispatchQueue.main.async { [weak self] in
            self?.coinListTableView.refreshControl?.endRefreshing()
        }
    
    } else {
    // Fallback on earlier versions
    }
    }
    } else {
         DispatchQueue.main.async { [weak self] in
    self?.coinListTableView.refreshControl?.endRefreshing()
    self?.showToast(message: Constants.NO_Internet_MSG)
        }
    }
    }
    @objc func updateCoins(_ notification: NSNotification) {
        if let coins = notification.userInfo?["updatedCoins"] as? Int {
            self.currentBalanceLabel.text = "\(coins)"
            CustomerDetails.coins = coins
            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: coins)
        }
    }
}

//MARK: - UITableViewDataSource
extension PurchaseCoinsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row called.....")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        cell.product = product
        cell.viewState = .fromPurchaseView
        cell.buyButtonHandler = { product in
            CoinPackagesList.store.buyProduct(product)
        }
        
        if selectedIndex != nil {
            if indexPath.row == selectedIndex?.row {
                cell.priceView.backgroundColor = .white
                cell.PriceLabel.textColor = BlackThemeColor.darkBlack
            } else {
                 cell.priceView.backgroundColor = .clear
                cell.PriceLabel.textColor = BlackThemeColor.white
            }
        }
        
        return cell
    }
}
//MARK: - UITableViewDelegate
extension PurchaseCoinsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("called did select")
        if !self.checkIsUserLoggedIn() {
             self.loginPopPop()
            return
        }
        
        let product = products[indexPath.row]
         selectedIndex = indexPath
        DispatchQueue.main.async { [weak self] in
            self?.coinListTableView.reloadData() //test
        }
        self.currentPackage = product.localizedTitle
        self.overlayView.showOverlay(view: self.view)
       print("skproduct \(product.productIdentifier)")
        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: false) { (result) in
             print("purchase product result\(result)")
            switch result {
            case .success(let product):
                print("got success and received product \(product.productId)")
                self.verifyReceipt(product: product)
                print("Purchase Success: \(product.productId)")
            case .error(let error):
                self.overlayView.hideOverlayView()
                let payloadDict = NSMutableDictionary()
                payloadDict.setObject("\(product.productIdentifier)" , forKey: "in_app_purchase_product_id" as NSCopying)
                payloadDict.setObject(product.localizedPrice ?? "", forKey: "transaction_price" as NSCopying)
                payloadDict.setObject(error.code.rawValue, forKey: "error_code" as NSCopying)
//                payloadDict.setObject("", forKey: "error_code" as NSCopying)
                switch error.code {
                case .unknown:
                    self.showToast(message: "Something went wrong. Please contact support")
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Unknown error. Please contact Apple support.", extraParamDict: payloadDict)
                    print("Unknown error. Please contact support")
                case .clientInvalid:
                    self.showToast(message: "Not allowed to make the payment")
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Not allowed to make the payment", extraParamDict: payloadDict)
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Payment cancelled.", extraParamDict: payloadDict)
                    self.showToast(message: "Payment Cancelled")
                    break
                case .paymentInvalid: print("The purchase identifier was invalid")

               CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The purchase identifier was invalid", extraParamDict: payloadDict)
                case .paymentNotAllowed:
                    self.showToast(message: "The device is not allowed to make the payment")
                   CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The device is not allowed to make the payment", extraParamDict: payloadDict)
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                     CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The product is not available in the current storefront", extraParamDict: payloadDict)
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                     CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Access to cloud service information is not allowed", extraParamDict: payloadDict)
                case .cloudServiceNetworkConnectionFailed:
                    self.showToast(message: "Could not connect to the network")
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Could not connect to the network", extraParamDict: payloadDict)
                    print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "User has revoked permission to use this cloud service", extraParamDict: payloadDict)
                default: break
                }
            }
        }
    }
   
    func verifyReceipt(product: PurchaseDetails) {
        print("verify Receipt 1")
        // Newly created Master Shared Secret Key: 6a50086eb4234ebbb753417c7957f2ff
        // Old Key: 08be034e34494f898070397aedf42099
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: AppConstants.storeKitMasterSharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                
                if let receiptInfo: NSArray = receipt["latest_receipt_info"] as? NSArray {
                    let lastReceipt = receiptInfo.lastObject as! NSDictionary
                    print(lastReceipt)
                }
                
                self.fetchReceipt(product: product, receipt: receipt)
                print("Verify receipt success: \(receipt)")
            case .error(let error):

                self.overlayView.hideOverlayView()
                print("Verify receipt failed: \(error.localizedDescription)")
                let payloadDict = NSMutableDictionary()
                payloadDict.setObject("\(product.product.productIdentifier)" , forKey: "in_app_purchase_product_id" as NSCopying)
                payloadDict.setObject(product.product.localizedPrice ?? "", forKey: "transaction_price" as NSCopying)
                payloadDict.setObject("", forKey: "error_code" as NSCopying)
                CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Payment receipt verification failed: \(error.localizedDescription)", extraParamDict: payloadDict)
            }
        }
    }
    
    func fetchReceipt(product: PurchaseDetails, receipt: ReceiptInfo) {
         print("fetch Receipt 2")
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = receiptData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        self.notifyServer(product: product, receipt: receipt, encryptedReceipt: receiptString ?? "12345")
    }
    
    func notifyServer(product: PurchaseDetails, receipt: ReceiptInfo, encryptedReceipt: String) {
        print(product)
        print(receipt)
        print("notify server 3")
        if let value = pakages.first(where: {$0.sku == product.productId}) {
            print("notify server \(value)")
            self.purchasePakage(purchaseDetails: product, packageId: value.id, receipt: encryptedReceipt)
        }
        
    }
    
    func purchasePakage(purchaseDetails: PurchaseDetails, packageId: String, receipt: String) {
         print("purchase package 4")
        let parameters = ["package_id": packageId,
                          "transaction_price": purchaseDetails.product.localizedPrice ?? "0",
                          "receipt":receipt,
                          "currency_code": purchaseDetails.product.priceLocale.currencyCode ?? "INR" ,
                          "vendor_order_id": purchaseDetails.transaction.transactionIdentifier ?? "00",
                          "env": Constants.environment,"v":Constants.VERSION] as [String : Any]
        print(parameters)
        ServerManager.sharedInstance().postRequest(postData: parameters, apiName: Constants.getOrderStatus, extraHeader: nil) { (result) in
            switch result {
            case .success(let data):
                print("purchase package response \(data)")
                self.overlayView.hideOverlayView()
                if (data["error"].bool == true) {
                    self.showToast(message: "Something went wrong. Please try again!")

                    let payloadDict = NSMutableDictionary()
                    payloadDict.setObject(purchaseDetails.product.productIdentifier , forKey: "in_app_purchase_product_id" as NSCopying)
                    payloadDict.setObject(purchaseDetails.product.localizedPrice ?? "0", forKey: "transaction_price" as NSCopying)
                    payloadDict.setObject(9999, forKey: "error_code" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Response data null or error value true", extraParamDict: payloadDict)
                    return
                    
                } else {
                    SwiftyStoreKit.finishTransaction(purchaseDetails.transaction)
                    if let availableCoins = data["data"]["available_coins"].int {
                        let coinDict:[String: Int] = ["updatedCoins": availableCoins]
                        CustomerDetails.coins = availableCoins
                        let database = DatabaseManager.sharedInstance
                        database.updateCustomerCoins(coinsValue: availableCoins)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: coinDict)
                        self.currentBalanceLabel.text = "\(availableCoins)"
                        self.UpdatedCoins = "\(availableCoins)"
                        let updatedAt = data["data"]["order"]["updated_at"].string
                        self.updatedDate = updatedAt
                        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.coins ?? 0, forKey: "wallet_balance")
                    }

                    let payloadDict = NSMutableDictionary()
                    payloadDict.setObject(purchaseDetails.product.productIdentifier , forKey: "in_app_purchase_product_id" as NSCopying)
                    payloadDict.setObject(purchaseDetails.product.localizedPrice ?? "0", forKey: "transaction_price" as NSCopying)
                    payloadDict.setObject(0, forKey: "error_code" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Success", reason: "", extraParamDict: payloadDict)
                        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.coins ?? 0, forKey: "wallet_balance")
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseCionsHistoryViewController") as! PurchaseCionsHistoryViewController
                    //self.addChild(popOverVC)
                    
                    popOverVC.packagePrice = self.currentPackage
                    popOverVC.updatedBalance = self.UpdatedCoins
                    popOverVC.dateAndTime = self.updatedDate
                    popOverVC.venderId = purchaseDetails.transaction.transactionIdentifier ?? ""
                    self.navigationController?.pushViewController(popOverVC, animated: false)

                }
            case .failure(let error):
                self.overlayView.hideOverlayView()

                let payloadDict = NSMutableDictionary()
                payloadDict.setObject(purchaseDetails.product.productIdentifier , forKey: "in_app_purchase_product_id" as NSCopying)
                payloadDict.setObject(purchaseDetails.product.localizedPrice ?? "0", forKey: "transaction_price" as NSCopying)
                payloadDict.setObject(9999, forKey: "error_code" as NSCopying)
                CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
                print(error)
            }
        }
    }
}
