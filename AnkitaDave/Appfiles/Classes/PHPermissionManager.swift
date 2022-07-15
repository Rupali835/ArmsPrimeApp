//
//  PermissionManager.swift
//  ArmsProducerApp
//
//  Created by developer2 on 20/07/19.
//  Copyright © 2019 Razrcorp . All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum PermissionType {
    
    case camera
    case photoLibrary
    case microphone
    case location
    case audioRecord
}

class PHPermissionManager: NSObject {
    
    // Required params
    var permissionType : PermissionType? = nil
    var controller: UIViewController? = nil
    var isAutoHandleNoPermissionEnabled = false
    var completionBlock: ((Bool)->())? = nil
    var locationManager: CLLocationManager? = nil

    // MARK: - Main Methods
    func askForPermission() {
        
        if let permissionType = self.permissionType {
            
            switch permissionType {
            case .camera:
                askForCameraPermission()
            case .photoLibrary:
                askForPhotoLibraryPermission()
            case .microphone:
                askForMicrophonePermission()
            case .location:
                askForLocationPermission()
            case .audioRecord :
                askForAudioRecordPermission()
            }
        }
    }
    
    func isPermissionEnabled(autoAskPermission: Bool)
    {
        if let permissionType = self.permissionType {
            
            switch permissionType {
            case .camera:
                isCameraPermissionGiven(autoAskPermission)
            case .photoLibrary:
                isPhotoLibraryPermissionGiven(autoAskPermission)
            case .microphone:
                isCameraPermissionGiven(autoAskPermission)
            case .location:
                isLocationPermissionGiven(autoAskPermission)
            case .audioRecord :
                isAudioRecordPermissionGiven(autoAskPermission)
            }
        }
    }
    
    // MARK: - Camera Permission Methods
    private func askForCameraPermission() {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (isGranted) in
            
            DispatchQueue.main.async {
                
                if !isGranted && self.isAutoHandleNoPermissionEnabled {
                    
                    self.showPermissionNotGivenAlert()
                    return
                }
                
                self.completionBlock?(isGranted)
            }
        }
    }
    
    private func isCameraPermissionGiven(_ autoAskPermission: Bool) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case .authorized:
            completionBlock?(true)
            
        case .denied:
            
            if isAutoHandleNoPermissionEnabled {
                
                showPermissionNotGivenAlert()
                break
            }
            completionBlock?(false)
        
        case .restricted:
            completionBlock?(false)
        case .notDetermined :
            
            if autoAskPermission {
                
                askForCameraPermission()
            }
            
        default:
            completionBlock?(false)
        }
    }
    
    // MARK: - Camera Permission Methods
    private func askForPhotoLibraryPermission() {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            DispatchQueue.main.async {
                
                if status == .denied && self.isAutoHandleNoPermissionEnabled {
                    
                    self.showPermissionNotGivenAlert()
                    return
                }
                
                self.completionBlock?(true)
            }
        }
    }
    
    private func isPhotoLibraryPermissionGiven(_ autoAskPermission: Bool) {
        
       let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            completionBlock?(true)
            
        case .denied:
            
            if isAutoHandleNoPermissionEnabled {
                
                showPermissionNotGivenAlert()
                break
            }
            completionBlock?(false)
            
        case .restricted:
            completionBlock?(false)
        case .notDetermined :
            
            if autoAskPermission {
                
                askForPhotoLibraryPermission()
            }
            
        default:
            completionBlock?(false)
        }
    }
    
    // MARK: - Microphone/Record Permission Methods
    private func askForMicrophonePermission() {
        
        AVAudioSession.sharedInstance().requestRecordPermission { (isGranted) in
            
            DispatchQueue.main.async {
                
                if !isGranted && self.isAutoHandleNoPermissionEnabled {
                    
                    self.showPermissionNotGivenAlert()
                    return
                }
                
                self.completionBlock?(isGranted)
            }
        }
    }
    
    private func isMicrophonePermissionGiven(_ autoAskPermission: Bool) {
        
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case .granted:
            completionBlock?(true)
            
        case .denied:
            
            if isAutoHandleNoPermissionEnabled {
                
                showPermissionNotGivenAlert()
                break
            }
            completionBlock?(false)
            
        case .undetermined :
            
            if autoAskPermission {
                
                askForCameraPermission()
            }
            
        default:
            completionBlock?(false)
        }
    }
    
    // MARK: - Microphone Permission Methods
    private func askForLocationPermission() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func isLocationPermissionGiven(_ autoAskPermission: Bool) {
        
        let status =  CLLocationManager.authorizationStatus()
        
        switch(status) {
        
        case .authorizedAlways, .authorizedWhenInUse:
            
            completionBlock?(true)
            
            break
            
        case .notDetermined:
            
            if autoAskPermission {
                
                askForLocationPermission()
            }
            
            break
            
        case .restricted:
            
            if isAutoHandleNoPermissionEnabled {
                
                showPermissionNotGivenAlert()
                break
            }
            completionBlock?(false)
            
            break
            
        case .denied:
            
            if isAutoHandleNoPermissionEnabled {
                
                showPermissionNotGivenAlert()
                break
            }
            completionBlock?(false)
            
        @unknown default:
            
            completionBlock?(false)
        }
    }
    
    // MARK: - Audio Record Permission Methods
    private func askForAudioRecordPermission() {
        
        AVAudioSession.sharedInstance().requestRecordPermission({ (isGranted) in
            
            DispatchQueue.main.async {
                
                if !isGranted && self.isAutoHandleNoPermissionEnabled {
                    
                    self.showPermissionNotGivenAlert()
                    return
                }
                
                self.completionBlock?(isGranted)
            }
        })
    }
    
    private func isAudioRecordPermissionGiven(_ autoAskPermission: Bool) {
        
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case .granted:
            completionBlock?(true)
            
        case .denied:
            
            if isAutoHandleNoPermissionEnabled {
                
                showPermissionNotGivenAlert()
                break
            }
            completionBlock?(false)
            
        default:
            completionBlock?(false)
        }
    }
    
    
    // MARK: - Utility Methods
    private func showPermissionNotGivenAlert() {

        if let inViewController = self.controller {
            
            let msg = getMessageForNoPermission()
            
            let alertNoPermission = UIAlertController(title: "Permission Error!", message: msg, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                
                DispatchQueue.main.async {

                    self.completionBlock?(false)
                }
            }
            
            let settingAction = UIAlertAction(title: "Go to settings", style: UIAlertAction.Style.default) { (action) in
                
                DispatchQueue.main.async {

                    self.goToPermissionSettings()
                    self.completionBlock?(false)
                }
            }
            
            alertNoPermission.addAction(cancelAction)
            alertNoPermission.addAction(settingAction)
            
            inViewController.present(alertNoPermission, animated: true, completion: nil)
        }
    }
    
    private func getMessageForNoPermission() -> String {
        
        switch self.permissionType! {
        case .camera:
            return "You have not given access for camera, Please enable permission from system settings."
        case .photoLibrary:
            return "You have not given access for photo library, Please enable permission from system settings."
        case .microphone:
            return "You have not given access for microphone, Please enable permission from system settings."
        case .location:
            return "You have not given access for Location Services, Please enable permission from system settings."
        case .audioRecord :
            return "You have not given permission to record audio, Please enable permission from system settings."
        }
    }
    
    private func goToPermissionSettings() {
        
        let settingURL = getPermissionSettingURL()
        
        if UIApplication.shared.canOpenURL(settingURL) {
            
            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
        }
    }

    private func getPermissionSettingURL() -> URL {
        
        let appSettings = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)
        
        return appSettings!
    }
}

extension PHPermissionManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch(status)
        {
        case .authorizedAlways, .authorizedWhenInUse:
            
            self.completionBlock?(true)
            break
            
        case .notDetermined:
            
            completionBlock?(false)
            break
            
        case .restricted:
            
            if self.isAutoHandleNoPermissionEnabled {
                
                self.showPermissionNotGivenAlert()
            }
            
            break
            
        case .denied:
            
            if self.isAutoHandleNoPermissionEnabled {
                
                self.showPermissionNotGivenAlert()
            }
            
        @unknown default:
            
            completionBlock?(false)
        }
        
        manager.stopUpdatingLocation()
    }
}
