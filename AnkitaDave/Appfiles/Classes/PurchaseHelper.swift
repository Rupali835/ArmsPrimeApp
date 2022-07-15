//
//  PurchaseHelper.swift
//  ScarlettRose
//
//  Created by RazrTech2 on 29/10/18.
//  Copyright © 2018 RazrTech. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

class PurchaseHelper {
    
    
    static let shared = PurchaseHelper()
    
    var dataTasks: [URL: URLSessionDataTask] = [:]
    var products = [SKProduct]()
    var pakages = [Package]()
    
//MARK:-
    func completeTransaction(productId: String, transaction: PaymentTransaction) {
        SwiftyStoreKit.retrieveProductsInfo(CoinPackagesList.productIdentifiersList) { result in
            if result.retrievedProducts.count > 0 {
                self.products = Array(result.retrievedProducts)
                if let product = self.products.first(where: {$0.productIdentifier == productId}) {
                    self.getPackage(product: product, transaction: transaction)
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }
    
    func getPackage(product: SKProduct, transaction: PaymentTransaction) {
        if Reachability.isConnectedToNetwork() == true {
            ServerManager.sharedInstance().getRequestFromCDN(postData: nil, apiName: Constants.getPackages + Constants.artistId_platform, extraHeader: nil) { (result) in
                switch result {
                case .success(let data):
                    print(data)
                    if (data["error"].bool == true) {
                        return
                        
                    } else {
                        if let pakages = data["data"]["list"].array {
                            for pakage in pakages {
                                if let packageDictionary = pakage.dictionaryObject {
                                    let pak = Package(dictionary: packageDictionary)
                                    self.pakages.append(pak)
                                }
                            }
                            self.verifyReceipt(product: product, transaction: transaction)
                        }
                        print(data)
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else
        {
            print(Constants.NO_Internet_MSG)
        }
    }
    
    func verifyReceipt(product: SKProduct, transaction: PaymentTransaction) {
        // Old key: 08be034e34494f898070397aedf42099
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: AppConstants.storeKitMasterSharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                self.fetchReceipt(product: product, receipt: receipt, transaction: transaction)
                print("Verify receipt success: \(receipt)")
            case .error(let error):
                print("Verify receipt failed: \(error)")
            }
        }
    }
    
    func fetchReceipt(product: SKProduct, receipt: ReceiptInfo, transaction: PaymentTransaction) {
        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = receiptData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        self.notifyServer(product: product, receipt: receipt, encryptedReceipt: receiptString ?? "1234465", transaction: transaction)
    }
    
    func notifyServer(product: SKProduct, receipt: ReceiptInfo, encryptedReceipt: String, transaction: PaymentTransaction) {
        if let value = pakages.first(where: {$0.sku == product.productIdentifier}) {
            print(value)
            self.purchasePakage(purchaseDetails: product, packageId: value.id, receipt: encryptedReceipt, transaction: transaction)
        }
    }
    
    func purchasePakage(purchaseDetails: SKProduct, packageId: String, receipt: String, transaction: PaymentTransaction) {
        
        let parameters = ["package_id": packageId,
                          "transaction_price": purchaseDetails.localizedPrice ?? "0",
                          "receipt":receipt,
                          "currency_code": purchaseDetails.priceLocale.currencyCode ?? "INR" ,
                          "vendor_order_id": transaction.transactionIdentifier ?? "00",
                          "env": Constants.environment,"v":Constants.VERSION] as [String : Any]
        print(parameters)
        ServerManager.sharedInstance().postRequest(postData: parameters, apiName: Constants.getOrderStatus, extraHeader: nil) { (result) in
            switch result {
            case .success(let data):
                print(data)
                if (data["error"].bool == true) {
                    return
                } else {
                    SwiftyStoreKit.finishTransaction(transaction)
                    if let availableCoins = data["data"]["available_coins"].int {
                        let coinDict:[String: Int] = ["updatedCoins": availableCoins]
                        CustomerDetails.coins = availableCoins
                        let database = DatabaseManager.sharedInstance
                        database.updateCustomerCoins(coinsValue: availableCoins)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatedCoins"), object: nil, userInfo: coinDict)
//                        self.currentBalanceLabel.text = "\(availableCoins)"
                        
                    }
                    let alertController = UIAlertController(title: "Coins purchased successfully", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
