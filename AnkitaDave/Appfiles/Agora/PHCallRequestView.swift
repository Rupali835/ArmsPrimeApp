//
//  PHCallRequestView.swift
//  Producer
//
//  Created by developer2 on 10/04/20.
//  Copyright © 2020 developer2. All rights reserved.
//

import UIKit
import AgoraRtmKit

@objc protocol PHCallRequestDelegate {
    
    func didSelectedShowRequest()
    func didSelectedCloseRequestCall()
    func didTimeoutCall()
}

class PHCallRequestView: UIView {
    
    @IBOutlet weak var btnRequests: UIButton!
    @IBOutlet weak var imgViewProfilePic: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var videoCallLabel: UILabel!

    
    var timerRequestTimeout: Timer? = nil
    var requestTimeout : Int64 = ArtistConfiguration.sharedInstance().oneToOne?.duration ?? 60
    var requestTimeoutCounter : Int64 = 0
    
    var timerSendRequestTimeout: Timer? = nil
    var sendRequestTimeout : Int64 = 60 // 5 Min
    var sendRequestTimeoutCounter : Int64 = 0
    
    var request: AgoraRtmRemoteInvitation? = nil
    
    weak var delegate: PHCallRequestDelegate? = nil
        
    override func awakeFromNib() {
        
        setLayoutAndDesigns()
    }
}

// MARK: - IBActions
extension PHCallRequestView {
    
    @IBAction func btnRequestClicked() {
        
        delegate?.didSelectedShowRequest()
    }
    
    @IBAction func btnCloseCallClicked() {
        
        delegate?.didSelectedCloseRequestCall()
    }
}

// MARK: - Utility Methods
extension PHCallRequestView {
    
    func setLayoutAndDesigns() {
        
        setDurationLabel()
        
        imgViewProfilePic.contentMode = .scaleAspectFill
        imgViewProfilePic.makeCirculaer = true
                
        setLayoutWithoutCall()
    }
    
    func setLayoutWithCall() {
        
        requestTimeoutCounter = requestTimeout
        
        lblDuration.isHidden = false
        videoCallLabel.isHidden = true

        imgViewProfilePic.isHidden = false
        
        btnRequests.isHidden = true
        
        setDurationLabel()
        
        setRequestDetails()
        
        startRequestTimeOutTimer()
    }
    
    func setLayoutWithoutCall() {
        
        request = nil
        
        stopRequestTimeOutTimer()
        
        lblDuration.isHidden = true
        videoCallLabel.isHidden = false
        imgViewProfilePic.isHidden = true
        
        btnRequests.isHidden = false
            
        requestTimeoutCounter = 0
       
        setDurationLabel()
        
        imgViewProfilePic.image = UIImage(named: "profile_placeholder_small")
        
        stopSendRequestTimeOutTimer()
    }
    
    func startRequestCall(_ request: AgoraRtmRemoteInvitation) {
        
        self.request = request
        
        setLayoutWithCall()
    }
    
    func setRequestDetails() {
        
        if let imgURL = ArtistConfiguration.sharedInstance().photo, imgURL.count > 0 {
            
            imgViewProfilePic.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "profile_placeholder_small"), options: .highPriority, context: [:])
        }
        else {
            
            imgViewProfilePic.image = UIImage(named: "profile_placeholder_small")
        }
    }
    
    func setDurationLabel() {
        
        lblDuration.text = utility.getTimeString(Int(requestTimeoutCounter))
    }
}

// MARK: - Request Timer Methods
extension PHCallRequestView {
    
    func startRequestTimeOutTimer() {
        
        stopRequestTimeOutTimer()
        
        timerRequestTimeout = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRequestTimeOutTimer), userInfo: nil, repeats: true)
    }
    
    func stopRequestTimeOutTimer() {
        
        if timerRequestTimeout != nil {
            
            if timerRequestTimeout!.isValid {
                
                timerRequestTimeout?.invalidate()
            }
        }
    }
    
    @objc func updateRequestTimeOutTimer() {
        
        requestTimeoutCounter = requestTimeoutCounter - 1
        
        if requestTimeoutCounter < 0 {
            
            stopRequestTimeOutTimer()
            
            delegate?.didTimeoutCall()
        }
        else {
            
            setDurationLabel()
        }
    }
}

// MARK: - Send Request Button Enable/Disable Timer Methods
extension PHCallRequestView {
    
    func startSendRequestTimeOutTimer() {
        
        stopSendRequestTimeOutTimer()
        
        timerSendRequestTimeout = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSendRequestTimeOutTimer), userInfo: nil, repeats: true)
        
        disableSendRequestBtn()
    }
    
    func stopSendRequestTimeOutTimer() {
        
        if timerSendRequestTimeout != nil {
            
            if timerSendRequestTimeout!.isValid {
                
                timerSendRequestTimeout?.invalidate()
                
                timerSendRequestTimeout = nil
            }
        }
        
        enableSendRequestBtn()
    }
    
    @objc func updateSendRequestTimeOutTimer() {
        
        sendRequestTimeoutCounter = sendRequestTimeoutCounter + 1
        
        if sendRequestTimeoutCounter > sendRequestTimeout {
            
            stopSendRequestTimeOutTimer()
        }
    }
    
    func enableSendRequestBtn() {
        
        btnRequests.alpha = 1.0
    }
    
    func disableSendRequestBtn() {
        
        btnRequests.alpha = 0.6
    }
}
