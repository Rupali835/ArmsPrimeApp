//  CoinPackagesList.swift
//  Karan Kundrra Official
//  Created by RazrTech2 on 11/05/18.
//  Copyright © 2018 RazrTech2. All rights reserved.

import Foundation
public struct CoinPackagesList {
    
    public static let coins42 = "\(Constants.appBundleID).42_"
    public static let coins108 = "\(Constants.appBundleID).108"
    public static let coins297 = "\(Constants.appBundleID).297"
    public static let coins850 = "\(Constants.appBundleID).850"
    public static let coins502 = "\(Constants.appBundleID).502"
    public static let coins2552 = "\(Constants.appBundleID).2552"
    public static let coins4288 = "\(Constants.appBundleID).4288"
    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [CoinPackagesList.coins42, CoinPackagesList.coins108, CoinPackagesList.coins297, CoinPackagesList.coins850, CoinPackagesList.coins2552, CoinPackagesList.coins4288, CoinPackagesList.coins502]
    
    
    static let productIdentifiersList: Set<ProductIdentifier> = [CoinPackagesList.coins42, CoinPackagesList.coins108, CoinPackagesList.coins297, CoinPackagesList.coins850, CoinPackagesList.coins2552, CoinPackagesList.coins4288, CoinPackagesList.coins502]
    
    public static let store = InAppPurchaseHelper(productIds: CoinPackagesList.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
