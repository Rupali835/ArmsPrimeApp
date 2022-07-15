//
//  FIRRemoteConfig.swift
//  HarsimranKaur
//
//  Created by Pankaj Bawane on 24/10/19.
//  Copyright © 2019 ArmsprimeMedia. All rights reserved.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

class FIRRemoteConfig {
    
    static let shared: FIRRemoteConfig = FIRRemoteConfig()
    
    var hasConfigFetchedAndActivated: Bool = false
    var hasConfigFetched: Bool = false
    fileprivate let remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        // Configure for dev mode if we need it
        #if DEBUG
        let expirationDuration: TimeInterval = 0
        let settings = RemoteConfigSettings()
        remoteConfig.configSettings = settings
        #else
        let expirationDuration: TimeInterval = 900
        #endif
        
        // Set default values and keys
        remoteConfig.setDefaults([
            RemoteConfigKeys.isReferralEnableIos.rawValue: false as NSObject
            ])
        
        // TimeInterval is set to expirationDuration here, indicating the next fetch request will use
        // data fetched from the Remote Config service, rather than cached parameter values, if cached
        // parameter values are more than expirationDuration seconds old. See Best Practices in the
        // README for more information.
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { [weak self](status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self?.hasConfigFetched = true
                self?.remoteConfig.activate(completionHandler: { (error) in
                    // ...
                    if error == nil {
                        print("Config activated!")
                        self?.hasConfigFetchedAndActivated = true
                    } else {
                        print("Config not activated!")
                        print("Error: \(error?.localizedDescription ?? "No error available.")")
                    }
                })
            } else {
                print("Config not fetched!")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    fileprivate func getConfigValueFor(key: RemoteConfigKeys) -> RemoteConfigValue? {
        return remoteConfig.configValue(forKey: key.rawValue)
    }
}

fileprivate enum RemoteConfigKeys: String {
    case isReferralEnableIos = "isReferralEnableIos"
    case isGameZoneEnable = "isGamezopEnabled"
}

struct RemoteConfigValues {
    static var isReferralEnableIos: Bool {
        return FIRRemoteConfig.shared.getConfigValueFor(key: .isReferralEnableIos)?.boolValue ?? false
    }

    static var isGameZoneEnable: Bool {
        return FIRRemoteConfig.shared.getConfigValueFor(key: .isGameZoneEnable)?.boolValue ?? false
    }
}
