//
//  XMPPController.swift
//  Karan Kundra
//
//  Created by RazrTech2 on 16/04/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import Foundation
import XMPPFramework

enum XMPPControllerError: Error {
    case wrongUserJID
}

protocol MessageDelegate: NSObjectProtocol {
    func messageReceived(_ message: [String: Any]?)
    func presenceReceived(_ presence: XMPPPresence)
}

class XMPPController: NSObject {
    var xmppStream: XMPPStream
    var xmppRoom: XMPPRoom!
    weak var messageDelegate: MessageDelegate?
    
    let hostName: String
    let userJID: XMPPJID
    let hostPort: UInt16
    let password: String
    let userName: String
    var currentUsersCount : Int!
    
    init(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws {
        self.userName = userJIDString
        let userJIDName = "\(userJIDString)@razrooh.com"
        guard let userJID = XMPPJID(string: userJIDName) else {
            throw XMPPControllerError.wrongUserJID
        }
        
        self.hostName = hostName
        self.userJID = userJID
        self.hostPort = hostPort
        self.password = password
        
        // Stream Configuration
        self.xmppStream = XMPPStream()
        self.xmppStream.hostName = hostName
        self.xmppStream.hostPort = hostPort
        self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
        self.xmppStream.myJID = userJID
        
        super.init()
        
        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    func connect() {
        if !self.xmppStream.isDisconnected {
            return
        }
        
        try! self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
    }
    
    func disconnect() {
        if !self.xmppStream.isConnected {
            return
        }
        
        self.xmppStream.disconnect()
    }
    
    func joinOrCreateRoom() {
        let roomMemory = XMPPRoomMemoryStorage()
        var roomJID: XMPPJID?
        if let artistKey = ArtistConfiguration.sharedInstance().key {
            roomJID = XMPPJID(string: "\(artistKey)@conference.razrooh.com")
        } else {
            roomJID = XMPPJID(string: "poonam@conference.razrooh.com")
        }
        
        self.xmppRoom = XMPPRoom(roomStorage: roomMemory!, jid: roomJID!, dispatchQueue: DispatchQueue.main)
        self.xmppRoom?.activate(self.xmppStream)
        let history = XMLElement(name: "history")
        history.addAttribute(withName: "maxstanzas", stringValue: "0")
        self.xmppRoom?.join(usingNickname: self.userName, history: history, password: nil)
        self.xmppRoom?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    func createUUID() -> String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid) as String
        return uuidString;
    }
}


extension XMPPController: XMPPStreamDelegate, XMPPRoomDelegate {
    
    func xmppStreamDidConnect(_ stream: XMPPStream) {
        print("Stream: Connected")
        
        if stream.supportsAnonymousAuthentication {
            do {
               try stream.authenticateAnonymously()
            } catch {
                print(error)
            }
        } else {
            do {
                try stream.authenticate(withPassword: self.password)
            } catch {
                print(error)
            }
        }
        
        
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        self.joinOrCreateRoom()
        self.xmppStream.send(XMPPPresence())
        print("Stream: Authenticated")
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        if self.xmppStream.supportsInBandRegistration {
            do {
                self.xmppStream.myJID = XMPPJID(string: userName + "@razrooh.com")
                try self.xmppStream.register(withPassword: "123456")
            } catch {
                print(error)
            }
        }
    }
    
    func xmppStreamDidRegister(_ sender: XMPPStream) {
        do {
            try sender.connect(withTimeout: XMPPStreamTimeoutNone)
        }catch {
            print(error)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.joinOrCreateRoom()
        })
        
        self.xmppStream.send(XMPPPresence())
    }
    
    func xmppStream(_ sender: XMPPStream, didNotRegister error: DDXMLElement) {
        
        let errorXML: [DDXMLElement] = error.elements(forName: "error")
        
        let errorCode = errorXML[0].attribute(forName: "code")?.stringValue
        let regError = "ERROR :- \(error.description)"
        let alert = UIAlertView(title: "Registration with XMPP Failed!", message: regError, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
        if (errorCode == "409") {
            alert.message = "Username Already Exists!"
        }
        alert.show()
    }
    
    func xmppRoom(_ sender: XMPPRoom, didReceive message: XMPPMessage, fromOccupant occupantJID: XMPPJID) {
        print(sender.roomJID)
        
        if let messages = message.body {
            let messageDict = ["message": messages]
            //            as [String: Any]
            if messages != ""{
                self.messageDelegate?.messageReceived(messageDict)
            }
        }
    }
    
    
    func xmppRoomDidJoin(_ sender: XMPPRoom) {
        
        sender.fetchMembersList()
        print("Room Joined")
    }
    
    func xmppRoomDidLeave(_ sender: XMPPRoom) {
        print("Room leave")
    }
    
    
    func xmppRoomDidCreate(_ sender: XMPPRoom) {
        print("room created")
    }
    
    
    func xmppRoom(_ sender: XMPPRoom, didFetchMembersList items: [Any]) {
        currentUsersCount = items.count
        print(items)
    }
    
    func xmppRoom(_ sender: XMPPRoom, didNotFetchMembersList iqError: XMPPIQ) {
        print(iqError)
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        
        self.messageDelegate?.presenceReceived(presence)
    }
    
    
}

