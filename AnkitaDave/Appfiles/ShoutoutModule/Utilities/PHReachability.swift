//
//  PHReachability.swift
//  desiplex
//
//  Created by developer2 on 20/08/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import UIKit
//import Reachability


class PHReachability: NSObject {
    
    static let shared = PHReachability()
    
    private var reachability: Reachability? = nil
    
    var isConnectedToInternet: Bool {
        
        if  reachability?.connection == Reachability.Connection.none {
            
            return false
        }
        else {
            
            return true
        }
    }
    
    func startObserver() {
        
        reachability = try! Reachability(hostname: "www.google.com")
                
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }        
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
//        case .unavailable:
//            print("Network not unavailable")
        }
    }
}
