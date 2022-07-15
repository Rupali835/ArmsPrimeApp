//
//  AgoraRTMConnection.swift
//  Producer
//
//  Created by developer2 on 27/03/20.
//  Copyright © 2020 developer2. All rights reserved.
//

import UIKit
import AgoraRtmKit

@objc protocol AgoraRTMConnectionDelegate {
    
    @objc optional func didReceivedRequest(invitation: AgoraRtmRemoteInvitation)
    @objc optional func didCancelledRequest(invitation: AgoraRtmRemoteInvitation)
    @objc optional func didRefusedRequest(invitation: AgoraRtmRemoteInvitation)
    @objc optional func didAcceptedRequest(invitation: AgoraRtmLocalInvitation, response: String?)
    @objc optional func didSentInvitation(with errorCode:AgoraRtmInvitationApiCallErrorCode)
    @objc optional func didLoggedIn(with errorCode: AgoraRtmLoginErrorCode)
    @objc optional func didLoggedOut(with errorCode: AgoraRtmLogoutErrorCode)
    @objc optional func didCancelledInvitation(with errorCode: AgoraRtmInvitationApiCallErrorCode)
    @objc optional func didReceivedCallEndRequest()
    @objc optional func didExpiredRequest()
}

class AgoraRTMConnection: NSObject {
    
    static let shared = AgoraRTMConnection()
    
    weak var delegate: AgoraRTMConnectionDelegate? = nil
    
    var rtmConnection: AgoraRtmKit? = nil
    
    var token = "006b6012ab300ca484587d6b4e3ae80f6edIAA5RFAYBksqyRNMmG9BAu6+e4tn0uzPhCAv973q/NoaEmgmVuAAAAAAEAAxYm2ti2qMXgEAAQCKaoxe"
    
    var username = "kashyap"
    
    var arrInvitations = [AgoraRtmRemoteInvitation]()
    
    var sentInvitation:AgoraRtmLocalInvitation? = nil
    
    var isLoggedIn = false
    
    var isConnected = false
    var artistConfig = ArtistConfiguration.sharedInstance()
    enum InvitationType: String {
        case oneToone = "oneToone"
        case multi = "multi"
    }
    
    enum commercialType: String {
        case paid = "paid"
        case free = "free"
    }
    
    enum commandType: String {
        
        case endCall = "endCall"
    }
}

// MARK: - Utility Methods
extension AgoraRTMConnection {
    
    func startConnection() {
        
        if rtmConnection == nil {
            
            rtmConnection = AgoraRtmKit(appId: artistConfig.agora_id!, delegate: self)
            
            rtmConnection?.getRtmCall()?.callDelegate = self
        }
    }
    
    func login() {
        
        rtmConnection?.login(byToken: token, user: CustomerDetails.custId!, completion: { [weak self] (code) in
            
            if code == .ok || code == .alreadyLogin {
                
                print("connected")
                
                self?.isLoggedIn = true
            }
            else {
                
                if code == .invalidToken {
                    
                    print("------ Invalid RTM Token --------")
                }
                
                if code == .invalidAppId {
                    
                    print("------ Invalid RTM APP Id --------")
                }
                
                self?.isLoggedIn = false
            }
            
            self?.delegate?.didLoggedIn?(with: code)
        })
    }
    
    func logout() {
                
        rtmConnection?.logout(completion: { [weak self] (code) in
            
            if code == .ok {
                
                print("logout")
                
                self?.isLoggedIn = false
            }
            
            self?.delegate?.didLoggedOut?(with: code)
        })
        
        sentInvitation = nil
    }
    
    func cancelInvitations(_ isLogout: Bool = false) {
        
        if let invitation = sentInvitation {
            
            rtmConnection?.rtmCallKit?.cancel(invitation, completion: { [weak self] (code) in
                
                self?.delegate?.didCancelledInvitation?(with: code)
                
                if isLogout {
                    
                    self?.logout()
                }
            })
        }
        else {
            
            if isLogout {
                
                logout()
            }
        }
    }
    
    func sendInvitation(to userId:String, type: InvitationType, requestType: commercialType, requestId: String) {
        
        if isLoggedIn == false {
            
            utility.showToast(msg: stringConstants.errorRTMConnectionIssue)
            
            return
        }
        
        if isConnected == false {
            
            utility.showToast(msg: stringConstants.errorRTMConnectionIssue)
            
            return
        }
        
        let invitation = AgoraRtmLocalInvitation(calleeId: userId)
        
        setUserInfo(invitation, type: type, requestType: requestType, requestId: requestId)
        
        rtmConnection?.rtmCallKit?.send(invitation, completion: { [weak self] (code) in
            
            if code == .ok {
                
                print("invitation sent")
                
                self?.sentInvitation = invitation
            }
            
            self?.delegate?.didSentInvitation?(with: code)
        })
    }
    
    func setUserInfo(_ invitation: AgoraRtmLocalInvitation, type: InvitationType, requestType: commercialType, requestId: String) {
        
        var dictUser = [String:String]()
        
        if let name = CustomerDetails.firstName {
            
            dictUser["name"] = name
        }
                
        if let picture = CustomerDetails.picture {
            
            dictUser["photo"] = picture
        }
        
        if let custId = CustomerDetails.custId {
            
            dictUser["id"] = custId
        }
        
        dictUser["request_type"] = type.rawValue
        
        dictUser["commercial_type"] = requestType.rawValue
        
        dictUser["request_id"] = requestId
        
        if let request = AgoraCallRequest.object(dictUser) {
            
            if let jsonString = request.toJSONString() {
                
                invitation.content = jsonString
            }
        }
    }
}

// MARK: - Call Delegate Methods
extension AgoraRTMConnection: AgoraRtmCallDelegate {
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationReceived remoteInvitation: AgoraRtmRemoteInvitation) {
        
        if let content = remoteInvitation.content {
            
            if content == commandType.endCall.rawValue {
                
                delegate?.didReceivedCallEndRequest?()
            }
            else {
                
                arrInvitations.insert(remoteInvitation, at: 0)
                
                self.delegate?.didReceivedRequest?(invitation: remoteInvitation)
            }
        }
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationCanceled remoteInvitation: AgoraRtmRemoteInvitation) {
        
        arrInvitations.removeAll { (invite) -> Bool in
            
            return invite.callerId == remoteInvitation.callerId
        }
        
        self.delegate?.didCancelledRequest?(invitation: remoteInvitation)
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationRefused remoteInvitation: AgoraRtmRemoteInvitation) {
        
        self.sentInvitation = nil
        self.delegate?.didRefusedRequest?(invitation: remoteInvitation)
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationAccepted remoteInvitation: AgoraRtmRemoteInvitation) {
        
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationAccepted localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        
        print("----localInvitationAccepted----")
        
        self.delegate?.didAcceptedRequest?(invitation: localInvitation, response: response)
    }
    
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationFailure localInvitation: AgoraRtmLocalInvitation, errorCode: AgoraRtmLocalInvitationErrorCode) {
        
        sentInvitation = nil
        
        self.delegate?.didExpiredRequest?()
    }
}

// MARK: - Web Service Methods
extension AgoraRTMConnection: AgoraRtmDelegate {
    
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
                
        if state == .connected {
            
            isConnected = true
        }
        else {
            
            isConnected = false
        }
    }
}

// MARK: - AgoraRtmRemoteInvitation Extension
extension AgoraRtmLocalInvitation {
    
    var requestContent : AgoraCallRequest? {
        
        if let data = self.content?.data(using: .utf8) {
        
           if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String], let request = AgoraCallRequest.object(dict) {
                
                return request
            }
        }
        
        return nil
    }
}

extension AgoraRtmRemoteInvitation {
     
    var requestContent : AgoraCallRequest? {
        
        if let data = self.content?.data(using: .utf8) {
        
           if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String], let request = AgoraCallRequest.object(dict) {
                
                return request
            }
        }
        
        return nil
    }
}
