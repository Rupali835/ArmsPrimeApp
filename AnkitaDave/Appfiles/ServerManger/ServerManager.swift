//
//  ServerManager.swift
//  Karan Kundra
//
//  Created by RazrTech2 on 20/03/18.
//  Copyright © 2018 RazrTech2. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

let requestTimeOut: TimeInterval = 60*60*24

enum Result<ValueType, ErrorType> {
    case success(ValueType)
    case failure(ErrorType)
}


class ServerManager {
    
    
    let networkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    
    let boundary = "Boundary-\(UUID().uuidString)"
    
    let timeOut: TimeInterval = Double.infinity

    let defaultManager: Alamofire.SessionManager = {
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "localhost:3443": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = requestTimeOut
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
    }()
    
  
    
    var deviceid = Constants.DEVICE_ID
    
    
    var deviceip = utility.getIPAddress()
    var headers: HTTPHeaders {
        get {
            
            var deviceID = String()
            var ipAdd = String()
            if let deviceid = Constants.DEVICE_ID{
                deviceID = deviceid
            }
            if  let ipaddress = utility.getIPAddress() {
               ipAdd = ipaddress
            }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": Constants.TOKEN,
                "ApiKey": Constants.API_KEY,
                "ArtistId": Constants.CELEB_ID,
                "Platform": Constants.PLATFORM_TYPE,
                "platform": Constants.PLATFORM_TYPE,
                "V": Constants.VERSION,
                "DeviceId"     : deviceID,
                "DeviceIp"    : ipAdd
                ]
            return headers
        }
    }
    //MARK:-
    class func sharedInstance() -> ServerManager {
        struct Static {
            static let sharedInstance = ServerManager()
        }
        return Static.sharedInstance
    }
    func postRequest(postData: Parameters?, apiName: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
        
        let localHeaders = headers
        let urlString = "\(Constants.App_BASE_URL)\(apiName)"
        print("api url =>\(urlString)")
        print("param =>\(postData)")
        print("header =>\(localHeaders)")
        
        defaultManager.request(urlString, method: .post, parameters: postData ?? nil, encoding: JSONEncoding.default, headers: localHeaders).validate().responseSwiftyJSON{
                response in
                switch response.result {
                case .success(let data):
                    closure(.success(data))
                case .failure(let error):
                    closure(.failure(error))
                }
        }
    }
    
    func multipart(params: Parameters, apiName: String, extraHeader: JSON?, completionBlock: ((Bool, String?, [String:Any]?)->())?) {

                        

        var postData = Data()

        

        let lineBreak = "\r\n"

                            

        for (key, value) in params {

            

            let paramName = key

            

            if let file = value as? Data {

                

                print("--- key = \(key), value = Data, fileSize = \(Double(file.count/(1024*1024))) MB")

                

                let contentType = "image/jpg"

                

                let timeStamp = Int64(Date().timeIntervalSince1970 * 1000)

                let fileName = "\(timeStamp).jpg"

                

                postData.append("--\(boundary + lineBreak)")

                postData.append("Content-Disposition:form-data;name=\"\(paramName)\";filename=\"\(fileName)\"\(lineBreak)")

                

                postData.append("Content-Type:\(contentType + lineBreak + lineBreak)")

                

                postData.append(file)

                postData.append(lineBreak)

            }

            else if let arr = value as? Array<AnyObject> {

                

                for i in 0..<arr.count {

                    

                    let item = arr[i]

                    

                    postData.append("--\(boundary + lineBreak)")

                    postData.append("Content-Disposition:form-data;name=\"\(paramName)[\(i)]\"\(lineBreak + lineBreak)")

                    postData.append("\(item)\(lineBreak)")

                }

            }

            else {

                

                print("--- key = \(key), value = \(value)")

                

                postData.append("--\(boundary + lineBreak)")

                postData.append("Content-Disposition:form-data;name=\"\(paramName)\"\(lineBreak + lineBreak)")

                postData.append("\(value)\(lineBreak)")

            }

        }

        

        postData.append("--\(boundary)--\(lineBreak)")

        

        let urlString = "\(Constants.App_BASE_URL)\(apiName)"

        

        guard let urlAPI = URL(string: urlString) else { return }

        

        var request = URLRequest(url: urlAPI)

        request.httpMethod = "POST"

        request.httpBody = postData

        

        request.timeoutInterval = timeOut

        

        var dictHeaders = headers

        

        dictHeaders["Content-Length"] = "\(postData.count)"

        

        dictHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"

        

        request.allHTTPHeaderFields = dictHeaders

                

        let session = URLSession(configuration: URLSessionConfiguration.default)

        

        let webTask = session.dataTask(with: request, completionHandler: { (data, response, error) in

                        

            DispatchQueue.main.async {

                

                print(String(data: data ?? Data(), encoding: String.Encoding.utf8))

                                

                if error == nil {

                    

                    if let responseData = data {

                        

                        do {

                            

                            guard let dictData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {

                                

                                completionBlock?(false, stringConstants.serverProblem, nil)

                                

                                print("error reponse = \(String(data: responseData, encoding: String.Encoding.utf8) ?? "")")

                                

                                return

                            }

                            

                            completionBlock?(true, nil, dictData)

                            

                        } catch {

                                                        

                            completionBlock?(false, stringConstants.serverProblem, nil)

                        }

                    }

                    else {

                        

                        completionBlock?(false, stringConstants.serverProblem, nil)

                    }

                }

                else {

                    

                    

                    completionBlock?(false, stringConstants.somethingWentWrong, nil)

                }

            }

        })

        

        webTask.resume()

    }
    
    func getRequestCustomerId(postData: Parameters?, apiName: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
        let localHeaders = headers
        var urlString = "\(Constants.CustomerId_URL)\(apiName)"
        
         urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
            defaultManager.request(urlString, method: .get, parameters: postData, encoding: JSONEncoding.default, headers: localHeaders).validate().responseSwiftyJSON{
                response in
                switch response.result {
                case .success(_):
                    if let result = response.result.value {
                        closure(.success(result))
                    }
                case .failure(let error):
                    closure(.failure(error))
                }
            }
    }
    
    func getRequest(postData: Parameters?, apiName: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
        let localHeaders = headers
        var urlString = "\(Constants.App_BASE_URL)\(apiName)"
        
         urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
            defaultManager.request(urlString, method: .get, parameters: postData, encoding: JSONEncoding.default, headers: localHeaders).validate().responseSwiftyJSON{
                response in
                switch response.result {
                case .success(_):
                    if let result = response.result.value {
                        closure(.success(result))
                    }
                case .failure(let error):
                    closure(.failure(error))
                }
            }
    }
    
    func getRequestFromCDN(postData: Parameters?, apiName: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
      
        let headers: HTTPHeaders = [
                    "Content-type": "application/json",
                    "ApiKey": Constants.API_KEY,
                    ]
   
        var urlString = "\(Constants.cloud_base_url)\(apiName)"
        print("social junction url \(urlString)")
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
            defaultManager.request(urlString, method: .get, parameters: postData, encoding: JSONEncoding.default, headers: headers).validate().responseSwiftyJSON{
                response in
                switch response.result {
                case .success(_):
                    if let result = response.result.value {
                        closure(.success(result))
                    }
                case .failure(let error):
                    closure(.failure(error))
                }
            }
    }
    
    
    func inAppValidation(postData: Parameters?, url: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
            defaultManager.request(url, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: nil).validate().responseSwiftyJSON { response in
                switch response.result {
                case .success(_):
                    if let result = response.result.value {
                        closure(.success(result))
                    }
                    
                case .failure(let error):
                    closure(.failure(error))
                }
            }
    }
    
    func getRequestAgora(postData: Parameters?, apiName: String, extraHeader: HTTPHeaders?, closure: @escaping (Result<JSON, Error>) -> Void) {
        
        var urlString = apiName
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let username = Constants.AgoraUsername
        let password = Constants.AgoraPassword
        let loginString = NSString(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8.rawValue)
        let base64LoginString = loginData?.base64EncodedString()
        let extraHeader : HTTPHeaders = ["Authorization":"Basic \(base64LoginString!)"]
        
        let request = defaultManager.request(urlString, method: .get, parameters: postData, encoding: JSONEncoding.default, headers: extraHeader).validate()
        
        request.responseSwiftyJSON{
            response in
            switch response.result {
            case .success(_):
                if let result = response.result.value {
                    closure(.success(result))
                }
            case .failure(let error):
                closure(.failure(error))
            }
        }
    }
    func getRequestFromUpcomingEvent(postData: Parameters?, apiName: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
            "ApiKey": Constants.API_KEY,
        ]
        
        var urlString = "\(apiName)"
        print("social junction url \(urlString)")
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        defaultManager.request(urlString, method: .get, parameters: postData, encoding: JSONEncoding.default, headers: headers).validate().responseSwiftyJSON{
            response in
            switch response.result {
            case .success(_):
                if let result = response.result.value {
                    closure(.success(result))
                }
            case .failure(let error):
                closure(.failure(error))
            }
        }
    }
    //MARK:- Update View and share count
    func updateShareViewCount(contentId: String, apiName: String, closure: @escaping (Result<JSON, Error>) -> Void) {
        
        var urlString = Constants.App_BASE_URL+apiName
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        print("called \(urlString)")
        let headers: HTTPHeaders = [
            "Authorization": Constants.TOKEN,
            "ApiKey": Constants.API_KEY,
        ]
        /*
         content_id      (Required)
         artist_id       (Required)
         platform        (Optional) (android | ios | web) [Default : android]
         */
        let params = ["content_id" : contentId , "platform" : "ios","artist_id" : Constants.CELEB_ID]
        
        let request = defaultManager.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate()
        
        request.responseSwiftyJSON{
            response in
            switch response.result {
            case .success(_):
                if let result = response.result.value {
                    closure(.success(result))
                }
            case .failure(let error):
                closure(.failure(error))
            }
        }
    }
//    func getBucketListing() {
//
//        ServerManager.sharedInstance().getRequest(postData:nil , apiName: Constants.HOME_SCREEN_DATA, extraHeader: nil) { (response) in
//            switch response.result {
//            case .success(_):
//                if let result = response.result.value {
//
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: result!, options: .mutableContainers) as? NSDictionary
//
//                        if let parseJSON = json {
//                            DispatchQueue.main.async {
//                                let dict : NSMutableDictionary = parseJSON["data"]  as! NSMutableDictionary
//                                let arrData =  dict.object(forKey: "list") as! NSMutableArray
//                                let bucketsArray = [List]()
//                                for var dict in arrData{
//                                    let list : List = List.init(dictionary: dict as! NSDictionary)!
//                                    self.bucketsArray?.append(list)
//                                }
//
//                                BucketValues.bucketContentArr = arrData
//                                self.displayLayout()
//                                self.addBucketListingToDatabase()
//                            }
//                        }
//                    } catch let error as NSError {
//                        print(error)
//                    }
//                }
//
//            case .failure(let error):
//
//
//            }
//
//
//        }
//
//
//    }
    
}
