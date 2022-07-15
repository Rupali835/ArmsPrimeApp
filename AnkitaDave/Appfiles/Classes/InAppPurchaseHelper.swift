//
//  InAppPurchaseHelper.swift
//  Poonam Pandey
//
//  Created by Razrtech3 on 13/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import StoreKit
import SwiftyJSON

protocol StoreRequestIAPPorotocol
{
    func transactionCompletedForRequest(PRODUCT_ID : JSON, receipt: String, currencyCode: String)
    func generateTemperaryOrder(_ product: SKProduct)
}



public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()


open class InAppPurchaseHelper : NSObject  {
    
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    static let IAPHelperFaildNotification = "IAPHelperFaildNotification"
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    var delegate : StoreRequestIAPPorotocol?
    var currentViewController : UIViewController!
    var currencyCode = "INR"
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        
        // Note: Chetan this call is shifted into the app delegate due to issue of observer - check the link http://greensopinion.com/2017/03/22/This-In-App-Purchase-Has-Already-Been-Bought.html - Where what mention is firbase set observer first AND then this observer get set so add this obserer first into the app delegate before firsbase configuration
        
        //        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension InAppPurchaseHelper {
    
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        completionHandler(false, [])
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        self.currencyCode = product.priceLocale.currencyCode ?? "INR"
//        self.delegate.generateTemperaryOrder(product)
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return true
    }
    
    public func restorePurchases() {
    }
}

extension InAppPurchaseHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension InAppPurchaseHelper: SKPaymentTransactionObserver {
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("paymentQueueRestoreCompletedTransactionsFinished")
        let transactions: [SKPaymentTransaction] = queue.transactions
        print("restore count = \(transactions.count)")
        if (transactions.count > 0) {
            handleUpdatedTransactions(transactions: transactions)
        }
    }
    
    private func handleUpdatedTransactions(transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        handleUpdatedTransactions(transactions: transactions)
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        self.deliverProduct(product: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError? {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperFaildNotification), object: transaction.error?.localizedDescription ?? "")
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperFaildNotification), object: "Transaction fail")
        }
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperFaildNotification), object: "Transaction fail")
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperPurchaseNotification), object: identifier)
    }
    
    
    //MARK: Deliver Product
    
    func deliverProduct(product : String)
    {
        self.validateReceipt { status in
            
            if status
            {
                print(product)
            }
            else
            {
                print("Something bad happened")
            }
        }
    }
    
    //MARK: Receipt Validation
    
    func validateReceipt(completion : @escaping (_ status : Bool) -> ())  {
        
        let receiptUrl = Bundle.main.appStoreReceiptURL
        
        let receipt: Data = try! Data(contentsOf: receiptUrl!)

        let receiptdata: String = receipt.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        
        let dict = ["receipt-data" : receiptdata]

        ServerManager.sharedInstance().inAppValidation(postData: dict, url: ReceiptURL.production.rawValue, extraHeader: nil) { result in
            switch result {
            case .success(let value):
                
                if !value["status"].boolValue, receiptdata != nil, self.currencyCode != nil{
                    self.delegate?.transactionCompletedForRequest(PRODUCT_ID: value, receipt: receiptdata, currencyCode: self.currencyCode)
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperFaildNotification), object: "Something went wrong")
                }
            case .failure(let error):
                print(error)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: InAppPurchaseHelper.IAPHelperFaildNotification), object: error.localizedDescription)
            }
        }
    }
    
    func sendToServer(PRODUCT_ID: JSON, receipt: String, currencyCode: String, completion: @escaping (_ status: Bool, _ productId: JSON, _ receipt: String, _ currencyCode: String)-> ()) {
        
    }
    
    
    func handleData(responseDatas : Data, completion : (_ status : Bool) -> ())
    {
        if let json = try! JSONSerialization.jsonObject(with: responseDatas, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
        {
            if let value = json.value(forKeyPath: "status") as? Int
            {
                if value == 0
                {
                    completion(true)
                }
                else
                {
                    completion(false)
                }
            }
            else
            {
                completion(false)
            }
        }
    }
}


enum ReceiptURL : String
{
    case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    case production = "https://buy.itunes.apple.com/verifyReceipt"
    case myServer = "your server"
    
}
