//
//  PHStickerLoader.swift
//  AnveshiJain
//
//  Created by developer2 on 31/03/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class PHStickerLoader: NSObject {
    
    static let shared = PHStickerLoader()
    
    var arrStickers = [CommentSticker]()
    var stickerPrice = 0
    var isCallingAPI = false
    
    private override init() {}
    
    func loadStickers() {
        
        if !isCallingAPI {
            
            getStickers()
        }
    }
    
    private func getStickers() {
        
        if Reachability.isConnectedToNetwork() {
            
            self.isCallingAPI = true
            
            ServerManager.sharedInstance().getRequest(postData: nil, apiName: Constants.COMMENT_GIFTS + Constants.artistId_platform + "&type=paid&live_type=directline" , extraHeader: nil, closure: { (result) in
                
                self.isCallingAPI = false
              
                switch result {
                    
                case .success(let data):
                    print(data)
                    
                    if data["error"].boolValue{
                        
                        return
                    }
                    else {
                        
                        if let resultArray : Array = data["data"]["list"].arrayObject {
                            
                            if let stickerPrice = data["data"]["stickers_price"].int {
                               
                                self.stickerPrice = stickerPrice
                            }
                            
                            if let stickers = CommentSticker.object(resultArray) {

                                self.arrStickers.removeAll()
                                self.arrStickers.append(contentsOf: stickers)
                            }
                            
                            Notifications.stickersLoaded.post(object: nil)
                            
                            print("resultArray ------------------")
                            print(resultArray)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
            
        } else
        {
            
        }
    }
}
