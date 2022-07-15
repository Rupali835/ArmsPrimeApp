//
//  PurchaseCoinOnLiveViewController.swift
//  AnveshiJain
//
//  Created by Bhavesh Chaudhari on 02/06/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import MoEngage

class PurchaseCoinOnLiveViewController: BaseViewController {

    // MARK: - outlet declaration
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var coinListTableView: UITableView!
    @IBOutlet weak var currentBalanceLabel: UILabel!

    // MARK: - variable declaration
    var selectedIndex: IndexPath?
    var UpdatedCoins:String!
    var updatedDate:String!
    var currentPackage:String!
    private var overlayView = LoadingOverlay.shared
    var pakages = [Package]() {
        didSet {
            coinListTableView.reloadData()
        }
    }
    var products = [SKProduct]()

    // MARK: - ViewController Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.roundCorners(corners: [.topLeft,.topRight], radius: 10.0)
        self.coinListTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        self.coinListTableView.isHidden = true

        if let savedPackages = getSavedPackages() {
            self.showLoader()
            self.pakages = savedPackages
            self.reload()
        } else {
            getPackage()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCoins(_:)), name: NSNotification.Name(rawValue: "updatedCoins"), object: nil)
        self.coinListTableView.rowHeight =  60

        self.view.removeGradient()
        loaderIndicator.center = CGPoint(x: view.center.x, y: 300/2)
        loaderIndicator.color = .white
//        headerView.addBorderWithCornerRadius(width: 1, cornerRadius: 0, color: .lightGray)


                NotificationCenter.default.addObserver(self, selector: #selector(PurchaseCoinsViewController.handlePurchaseNotification(_:)),
                                                       name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperPurchaseNotification),
                                                       object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(PurchaseCoinsViewController.handleFaildNotification(_:)),
                                                       name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperFaildNotification),
                                                       object: nil)
        currentBalanceLabel.attributedText = generateBalanceAttributedString(with: CustomerDetails.coins, capHeight: Int(currentBalanceLabel.font.capHeight))


        //        reload()
                // Do any additional setup after loading the view.

                SKPaymentQueue.default().restoreCompletedTransactions()
    }

    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           GlobalFunctions.screenViewedRecorder(screenName: "Live Buy Coins Screen")
    }

    // MARK: - Custom method
    private func generateBalanceAttributedString(with balance: Int, capHeight: Int) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "Balance: ")
        let loveAttachment = NSTextAttachment()
        loveAttachment.image = UIImage(named: "armsCoin")
        loveAttachment.bounds = CGRect(x: 0, y: (capHeight - 20) / 2, width: 20, height: 20)
        attributedString.append(NSAttributedString(attachment: loveAttachment))
        attributedString.append(NSAttributedString(string: " \(balance)"))
        return attributedString
    }

    @objc func updateCoins(_ notification: NSNotification) {
        if let coins = notification.userInfo?["updatedCoins"] as? Int {
//            self.currentBalanceLabel.text = "\(coins)"
             currentBalanceLabel.attributedText = generateBalanceAttributedString(with: coins, capHeight: Int(currentBalanceLabel.font.capHeight))
            CustomerDetails.coins = coins
            let database = DatabaseManager.sharedInstance
            database.updateCustomerCoins(coinsValue: coins)
        }
    }

       private func getPackage() {
            if Reachability.isConnectedToNetwork() == true {
                print("start get package")
                self.showLoader()
                ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.getPackages + Constants.artistId_platform, extraHeader: nil) { (result) in
                    switch result {
                    case .success(let data):
    //                    print(data)
                        DispatchQueue.main.async {
                            self.coinListTableView.isHidden = true
                        }
                        if (data["error"] as? Bool == true) {

    //                        CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Failed to load packages from CDN. Error: \(data["error"])", extraParamDict: nil)
                            self.stopLoader()

//                            self.showToast(message: "Something went wrong. Please try again!")
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
                            self.savePackage(packages: self.pakages)
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

    private func savePackage(packages: [Package], encoder: JSONEncoder = JSONEncoder())  {
        if let encoded = try? encoder.encode(packages) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultKey.inAppPackages.rawValue)
        }
    }


    private func getSavedPackages(with decoder: JSONDecoder = JSONDecoder()) -> [Package]? {
        if let savedPackages = UserDefaults.standard.object(forKey: UserDefaultKey.inAppPackages.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedPackages = try? decoder.decode([Package].self, from: savedPackages) {
                return loadedPackages
            }
        }
        return nil
    }

     @objc func reload() {
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
                    self?.coinListTableView.isHidden = false
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

   private func setUpdatedPackage() {
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
              //  self.heightOfScreen.constant = CGFloat(344 + (60 * self.products.count))
                self.coinListTableView.reloadData()
            }

        }
}

extension PurchaseCoinOnLiveViewController: UITableViewDataSource {

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
        cell.viewState = .fromLiveView
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

extension PurchaseCoinOnLiveViewController: UITableViewDelegate {
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
//        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: false, applicationUsername: "Anveshi Jain", simulatesAskToBuyInSandbox: true) { (result) in
//            switch result {
//            case .success(let product):
//                self.verifyReceipt(product: product)
//                print("Purchase Success: \(product.productId)")
//            case .error(let error):
//                self.overlayView.hideOverlayView()
//                let payloadDict = NSMutableDictionary()
//                payloadDict.setObject("\(product.productIdentifier)" , forKey: "in_app_purchase_product_id" as NSCopying)
//                payloadDict.setObject(product.localizedPrice ?? "", forKey: "transaction_price" as NSCopying)
//                payloadDict.setObject(error.code.rawValue, forKey: "error_code" as NSCopying)
//                //                payloadDict.setObject("", forKey: "error_code" as NSCopying)
//                switch error.code {
//                case .unknown:
//                    self.showToast(message: "Unknown error. Please contact Apple support")
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Unknown error. Please contact Apple support.", extraParamDict: payloadDict)
//                    print("Unknown error. Please contact support")
//                case .clientInvalid:
//                    self.showToast(message: "Not allowed to make the payment")
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Not allowed to make the payment", extraParamDict: payloadDict)
//                    print("Not allowed to make the payment")
//                case .paymentCancelled:
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Payment cancelled.", extraParamDict: payloadDict)
//                    self.showToast(message: "Payment Cancelled")
//                    break
//                case .paymentInvalid: print("The purchase identifier was invalid")
//
//                CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The purchase identifier was invalid", extraParamDict: payloadDict)
//                case .paymentNotAllowed:
//                    self.showToast(message: "The device is not allowed to make the payment")
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The device is not allowed to make the payment", extraParamDict: payloadDict)
//                    print("The device is not allowed to make the payment")
//                case .storeProductNotAvailable: print("The product is not available in the current storefront")
//                CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The product is not available in the current storefront", extraParamDict: payloadDict)
//                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
//                CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Access to cloud service information is not allowed", extraParamDict: payloadDict)
//                case .cloudServiceNetworkConnectionFailed:
//                    self.showToast(message: "Could not connect to the network")
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Could not connect to the network", extraParamDict: payloadDict)
//                    print("Could not connect to the network")
//                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
//                CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "User has revoked permission to use this cloud service", extraParamDict: payloadDict)
//                default: break
//                }
//            }
//        }
//
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
//                    self.showToast(message: "Something went wrong. Please contact support")
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Unknown error. Please contact Apple support.", extraParamDict: payloadDict)
                    print("Unknown error. Please contact support")
                case .clientInvalid:
//                    self.showToast(message: "Not allowed to make the payment")
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Not allowed to make the payment", extraParamDict: payloadDict)
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Payment cancelled.", extraParamDict: payloadDict)
//                    self.showToast(message: "Payment Cancelled")
                    break
                case .paymentInvalid: print("The purchase identifier was invalid")

               CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The purchase identifier was invalid", extraParamDict: payloadDict)
                case .paymentNotAllowed:
//                    self.showToast(message: "The device is not allowed to make the payment")
                   CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The device is not allowed to make the payment", extraParamDict: payloadDict)
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                     CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "The product is not available in the current storefront", extraParamDict: payloadDict)
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                     CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Failed", reason: "Access to cloud service information is not allowed", extraParamDict: payloadDict)
                case .cloudServiceNetworkConnectionFailed:
//                    self.showToast(message: "Could not connect to the network")
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
//                    self.showToast(message: "Something went wrong. Please try again!")

//                    let payloadDict = NSMutableDictionary()
//                    payloadDict.setObject(packageId , forKey: "in_app_purchase_product_id" as NSCopying)
//                    payloadDict.setObject(purchaseDetails.product.localizedPrice ?? "0", forKey: "transaction_price" as NSCopying)
//                     payloadDict.setObject(purchaseDetails.transaction.transactionIdentifier ?? "00", forKey: "vendor_order_id" as NSCopying)
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.callAPI_CoinPurchase, action: "", status: "Failed", reason: "Something went wrong. Please try again!", extraParamDict: payloadDict)
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
                        self.currentBalanceLabel.attributedText = self.generateBalanceAttributedString(with: availableCoins, capHeight: Int(self.currentBalanceLabel.font.capHeight))
//                        self.currentBalanceLabel.text = "\(availableCoins)"
                        self.UpdatedCoins = "\(availableCoins)"
                        let updatedAt = data["data"]["order"]["updated_at"].string
                        self.updatedDate = updatedAt
                        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.coins ?? 0, forKey: "wallet_balance")

                    }

//                    let payloadDict = NSMutableDictionary()
//                    payloadDict.setObject(packageId , forKey: "in_app_purchase_product_id" as NSCopying)
//                    payloadDict.setObject(purchaseDetails.product.localizedPrice ?? "0", forKey: "transaction_price" as NSCopying)
//                    payloadDict.setObject(purchaseDetails.transaction.transactionIdentifier ?? "00", forKey: "vendor_order_id" as NSCopying)
//                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.callAPI_CoinPurchase, action: "", status: "Success", reason: "", extraParamDict: payloadDict)
                    let payloadDict = NSMutableDictionary()
                    payloadDict.setObject(purchaseDetails.product.productIdentifier , forKey: "in_app_purchase_product_id" as NSCopying)
                    payloadDict.setObject(purchaseDetails.product.localizedPrice ?? "0", forKey: "transaction_price" as NSCopying)
                    payloadDict.setObject(0, forKey: "error_code" as NSCopying)
                    CustomMoEngage.shared.sendEvent(eventType: MoEventType.purchaseCoinPackage, action: "", status: "Success", reason: "", extraParamDict: payloadDict)
                        MoEngage.sharedInstance().setUserAttribute(CustomerDetails.coins ?? 0, forKey: "wallet_balance")
                    self.view.removeFromSuperview()
//                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseCionsHistoryViewController") as! PurchaseCionsHistoryViewController
//                    //self.addChild(popOverVC)
//
//                    popOverVC.packagePrice = self.currentPackage
//                    popOverVC.updatedBalance = self.UpdatedCoins
//                    popOverVC.dateAndTime = self.updatedDate
//                    popOverVC.venderId = purchaseDetails.transaction.transactionIdentifier ?? ""
//                    self.navigationController?.pushViewController(popOverVC, animated: false)
//                    popOverVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//                    self.view.addSubview(popOverVC.view)
//                    popOverVC.didMove(toParent: self)
                    //                    let alertController = UIAlertController(title: "Coins purchased successfully", message: "", preferredStyle: .alert)
                    //                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    //                    alertController.addAction(okAction)
                    //                    self.present(alertController, animated: true, completion: nil)

                }
            case .failure(let error):
                self.overlayView.hideOverlayView()
                //self.stopLoader()
//                let payloadDict = NSMutableDictionary()
//                payloadDict.setObject(packageId , forKey: "in_app_purchase_product_id" as NSCopying)
//                payloadDict.setObject(purchaseDetails.product.localizedPrice ?? "0", forKey: "transaction_price" as NSCopying)
//                payloadDict.setObject(purchaseDetails.transaction.transactionIdentifier ?? "00", forKey: "vendor_order_id" as NSCopying)
//                CustomMoEngage.shared.sendEvent(eventType: MoEventType.callAPI_CoinPurchase, action: "", status: "Failed", reason: error.localizedDescription, extraParamDict: payloadDict)
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
