//
//  WebService.swift
//  Desiplex
//
//  Created by developer2 on 19/08/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class WebServiceApp: NSObject {
    var loaderIndicator: NVActivityIndicatorView!
    var webTask: URLSessionTask? = nil
    var isCloud = false
    var showInternetProblem = true
    var loaderView: UIView? = nil
    var apiName = ""
    var params : [String:AnyObject]? = nil
    var completionBlock: ((Bool, String?, [String:Any]?)->())? = nil
    let timeOut: TimeInterval = Double.infinity
    var type: WebServiceType = .get
    let boundary = "Boundary-\(UUID().uuidString)"
    var shouldPrintLog = false
    var shouldAutoAddArtistId = true
    var shouldAutoAddExtraParams = true
    
    enum WebServiceType {
        case get
        case post
        case agora
        case multipart
        case put
    }
    
    init(showInternetProblem: Bool, isCloud: Bool, loaderView: UIView?) {
        
        self.showInternetProblem = showInternetProblem
        self.loaderView = loaderView
        self.isCloud = isCloud
  
    }
    func agora() {
        guard let urlString = apiName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        let username = Constants.AgoraUsername
        let password = Constants.AgoraPassword
        
        let loginString = NSString(format: "%@:%@", username, password)
        
        let loginData = loginString.data(using: String.Encoding.utf8.rawValue)
        guard let base64LoginString = loginData?.base64EncodedString() else { return }
        let headers = ["Authorization":"Basic \(base64LoginString)"]
        
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        self.executeRequest(request: request)
    }
    func execute(type: WebServiceType, name: String, params: [String:AnyObject]?, uploadFileKey: String? = nil, uploadData: Data? = nil, completion: ((Bool, String?, [String:Any]?)->())?) {
        
        self.completionBlock = completion
        
        if !Reachability.isConnectedToNetwork(){
            
            if showInternetProblem {
                
                self.completionBlock?(false, stringConstants.errNoInternet, nil)
            }
            
            return
        }
        
        self.apiName = name
        self.params = params
        self.type = type
        
        if type == .get {
            
            get()
        }
        
        if type == .post {
            
            post()
        }
        if type == .agora {
            
            agora()
        }
       
    }
    
    

    
    private func post() {
        
        var postData: Data? = nil
        
        if shouldAutoAddExtraParams {
            addExtraParameters()
        }
        
        do {
            postData = try JSONSerialization.data(withJSONObject: self.params!, options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        
        let url = ((self.isCloud == true) ? Constants.cloud_base_url : Constants.App_BASE_URL) + self.apiName
        
        guard let urlAPI = URL(string: url) else { return }
        
        var request = URLRequest(url: urlAPI)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        self.executeRequest(request: request)
    }
    
    
    
    private func get() {
        
        var url = ((self.isCloud == true) ? Constants.cloud_base_url : Constants.App_BASE_URL) + self.apiName
        
        if shouldAutoAddExtraParams {
            addExtraParameters()
        }
        
        var strParams = ""
        
        if self.params != nil {
            
            for i in 0..<params!.keys.count {
                
                let key = (params! as NSDictionary).allKeys[i] as! String
                
                let value = params![key]
                
                if strParams.isEmpty {
                    
                    strParams = strParams + "?\(key)=\(value!)"
                }
                else{
                    
                    strParams = strParams + "&\(key)=\(value!)"
                }
            }
        }
        
        url = url + strParams
        
        guard let urlAPI = URL(string: url) else { return }
        
        let request = URLRequest(url: urlAPI)
        
        self.executeRequest(request: request)
    }
    

    

    
    private func executeRequest(request: URLRequest) {
        
        if !Reachability.isConnectedToNetwork() {
            
            if showInternetProblem {
                
                self.completionBlock?(false, stringConstants.errNoInternet, nil)
            }
            
            return
        }
        
        var delay = 0.0
        
        
        
        var finalRequest = request
        
        if type != .agora {
            
            finalRequest.timeoutInterval = timeOut
            
            var dictHeaders = getHeaders()
            
            if type == .multipart {
                
                if let body = request.httpBody {
                    
                    dictHeaders["Content-Length"] = "\(body.count)"
                }
            }
            
            finalRequest.allHTTPHeaderFields = dictHeaders
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            self.loadRequest(finalRequest)
        }
    }
    
    func loadRequest(_ request: URLRequest) {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        webTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                
//                self.loader?.hide()
                
                if error == nil {
                    
                    if let responseData = data {
                        
                        do {
                            
                            guard let dictData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                                
                                self.completionBlock?(false, stringConstants.errServerProblem, nil)
                                
                                print("error reponse = \(String(data: responseData, encoding: String.Encoding.utf8) ?? "")")
                                
                                return
                            }
                            
                            self.printLog(response: dictData as Any)
                            
                            self.completionBlock?(true, nil, dictData)
                            
                        } catch {
                            
                            self.printLog(response: (String(data: responseData, encoding: String.Encoding.utf8) ?? ""))
                            
                            print(error.localizedDescription)
                            self.completionBlock?(false, stringConstants.errServerProblem, nil)
                        }
                    }
                    else {
                        
                        self.completionBlock?(false, stringConstants.errServerProblem, nil)
                    }
                }
                else {
                    
                    self.completionBlock?(false, stringConstants.errServerProblem, nil)
                }
            }
        })
        
        webTask?.resume()
    }
    
    private func getHeaders() -> [String: String] {
        
        var dictParams = ["ApiKey": Constants.API_KEY]
        
        if type == .multipart {
            
            dictParams["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        }
        else {
            
            dictParams["Content-Type"] = "application/json"
        }
       
        dictParams["Authorization"] = Constants.TOKEN
        dictParams["artistid"] = Constants.CELEB_ID
        dictParams["product"] = Constants.product
        
        if let version = macros.appVersion {
            
            dictParams["version"] = version
            dictParams["v"] = version
        }
        
        dictParams["platform"] = Constants.PLATFORM_TYPE
        dictParams["DeviceIp"] = utility.getIPAddress()
        dictParams["DeviceId"] = Constants.DEVICE_ID
        dictParams["DeviceOsVersion"] = UIDevice.current.systemVersion
        dictParams["DeviceModel"] = UIDevice.current.name

        
//        headers mai
//        DeviceId:33aaaecb97105246
//        DeviceIp:12.7.02.01
//        DeviceOsVersion:1.02
//        DeviceModel:ios
        
        return dictParams
    }
    
    func cancel() {
        
        self.webTask?.cancel()
        self.webTask = nil
        
//        self.loader?.hide()
    }
    
    private func addExtraParameters() {
        
        if self.params == nil {
            
            self.params = [String: AnyObject]()
        }
        
        if let version = macros.appVersion {
            
            self.params?["v"] = version as AnyObject
        }
        
        self.params?["platform"] = Constants.PLATFORM_TYPE as AnyObject
        
        if shouldAutoAddArtistId {
            
            self.params?["artist_id"] = Constants.CELEB_ID as AnyObject
        }
        
        //self.params?["visibility"] = webConstants.visibility as AnyObject
        //self.params?["visiblity"] = webConstants.visibility as AnyObject
    }
    
    private func printLog(response: Any) {
        
//        if webConstants.isForAppStore { return }
        
        if !self.shouldPrintLog { return }
        
        let url = type == .agora ? self.apiName : (self.isCloud ? Constants.cloud_base_url : Constants.App_BASE_URL) + self.apiName
        print("_______________________________________________________________")
        print("API: \(url)")
        print("________")
        print("HEADERS: \(getHeaders())")
        print("________")
        print("Parameters: ")
        print(self.type == .multipart ? "can not print for multipart request" : self.params as Any)
        print("________")
        print("Response: ")
        print(response as Any)
        print("_______________________________________________________________")
    }
}
