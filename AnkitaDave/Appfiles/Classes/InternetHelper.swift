//
//  InternetHelper.swift
//  ppConsumer
//
//  Created by Razr on 04/11/17.
//  Copyright © 2017 Razr. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import UIKit
import SystemConfiguration

// Internet Vaidation Helper...
//public class Reachability {
//    
//    let networkReachabilityManager = NetworkReachabilityManager(host: "www.google.com")
//   
//    
//    
//    
//    
//    static let networkSharedInstance = Reachability()
//    
//    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
//    
//    func startNetworkReachabilityObserver() {
//        reachabilityManager?.listener = { status in
//            switch status {
//            case .notReachable:
//                print("NOT reachable")
//            case .reachable(.ethernetOrWiFi):
//                print("The network is reachable over wifi connection")
//            case .reachable(.wwan):
//                print("The network is reachable over the WWAN connetion")
//            default:
//                print("Unkown list")
//            }
//        }
//        reachabilityManager?.startListening()
//    }
//    
//    
////    class func isConnectedToNetwork() -> Bool {
////
////        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
////        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
////        zeroAddress.sin_family = sa_family_t(AF_INET)
////
////        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
////            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
////                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
////            }
////        }
////
////        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
////        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
////            return false
////        }
////
////        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
////        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
////        let ret = (isReachable && !needsConnection)
////
////        return ret
////    }
//    
//
//    class func isConnectedToNetwork() -> Bool {
//
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//
//
//
//        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
//                SCNetworkReachabilityCreateWithAddress(nil, $0)
//            }
//
//        }) else {
//
//            return false
//        }
//
//        var flags: SCNetworkReachabilityFlags = []
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
//            return false
//        }
//
//        let isReachable = flags.contains(.reachable)
//        let needsConnection = flags.contains(.connectionRequired)
//        return (isReachable && !needsConnection)
//
//    }
//
//
//    class func checkInternetConnectivity() -> Bool {
//
//        if Reachability.isConnectedToNetwork() == true {
//            //            print("Internet connection OK")
//            return true
//        } else {
//            print("Internet connection FAILED")
//            return false
//
//        }
//    }
////
////    class func isConnectedToNetwork() -> Bool {
////
////        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
////        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
////        zeroAddress.sin_family = sa_family_t(AF_INET)
////
////        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
////            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
////                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
////            }
////        }
////
////        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
////        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
////            return false
////        }
////
////        /* Only Working for WIFI
////         let isReachable = flags == .reachable
////         let needsConnection = flags == .connectionRequired
////
////         return isReachable && !needsConnection
////         */
////
////        // Working for Cellular and WIFI
////        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
////        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
////        let ret = (isReachable && !needsConnection)
////
////        return ret
////
////    }
//}



