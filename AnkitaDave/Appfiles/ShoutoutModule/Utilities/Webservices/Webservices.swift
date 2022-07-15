//
//  Webservices.swift
//  VideoGreetings
//
//  Created by Apple on 24/09/19.
//  Copyright © 2019 Pankaj Bawane. All rights reserved.
//

import Foundation

//typealias WebServiceCompletion<T> = (_ response: T?, _ error: Error?) -> ()
//typealias WebServiceDownloadHandler = (_ progress: Float) -> ()

class WebService: NSObject, URLSessionDelegate, URLSessionDownloadDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    // Public properties.
    public static let shared = WebService()
    
    // Private.
    fileprivate let printLog: Bool = true
    
    // Download.
    fileprivate var downloadProgressHandler: WebServiceDownloadHandler?
    fileprivate var downloadCompletionHandler: WebServiceCompletion<URL>?
    
    fileprivate var headers: Dictionary<String, String> {
        var headers: Dictionary<String, String> = ["ApiKey": ShoutoutConfig.apiKey, "Content-Type": "application/json"]
        headers["platform"] = ShoutoutConfig.platform
        headers["Authorization"] = ShoutoutConfig.authToken
        headers["ArtistId"] = ShoutoutConfig.artistID
        headers["version"] = ShoutoutConfig.version
        
        return headers
    }
    
    // Disable instantiation.
    private override init() {
         super.init()
    }
    
    func cancel() {
        
        /*self.webTask?.cancel()
        self.webTask = nil  SHRIRAM
        
        self.loader?.hide()*/
    }
    
    // Get.
    func callGetMethod<T: Codable>(endPoint: WebEndpoints, parameters: Dictionary<String, Any>?, responseType: T.Type, showLoader: Bool = false, completion: @escaping WebServiceCompletion<T>) {
        
        if !ShoutoutConfig.inAppCheckIsConntectedToInternet() {
            completion(nil, WebServiceError.internetError)
            return
        }
        
        var parameterSufix: String = ""
        
        if let parameter = parameters {
            for (_, info) in parameter.enumerated() {
                if parameterSufix == "" {
                    parameterSufix = parameterSufix + "?\(info.key)=\(info.value)"
                } else {
                    parameterSufix = parameterSufix + "&\(info.key)=\(info.value)"
                }
            }
        }
            
            var defaultParameters = ["platform": ShoutoutConfig.platform]
            defaultParameters["Authorization"] = ShoutoutConfig.authToken
            defaultParameters["ArtistId"] = ShoutoutConfig.artistID
            defaultParameters["version"] = ShoutoutConfig.version
            
            for (_, info) in defaultParameters.enumerated() {
                if parameterSufix == "" {
                    parameterSufix = parameterSufix + "?\(info.key)=\(info.value)"
                } else {
                    parameterSufix = parameterSufix + "&\(info.key)=\(info.value)"
                }
            }
        
        guard let url = URL(string: ShoutoutConfig.baseUrl + endPoint.rawValue + parameterSufix) else {
            completion(nil, WebServiceError.invalidUrl)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        
        didCallWebService(request: urlRequest, responseType: T.self, parameters: parameters, showLoader: showLoader, completion: completion)
    }
    
    // Post.
    func callPostMethod<T: Codable>(endPoint: WebEndpoints, parameters: Dictionary<String, Any>?, responseType: T.Type, showLoader: Bool = false, completion: @escaping WebServiceCompletion<T>) {
        
        if !ShoutoutConfig.inAppCheckIsConntectedToInternet() {
            completion(nil, WebServiceError.internetError)
            return
        }
        
        guard let url = URL(string: ShoutoutConfig.baseUrl + endPoint.rawValue) else {
            completion(nil, WebServiceError.invalidUrl)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers
        
        if let parameter = parameters {
            do {
                let postData = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
                urlRequest.httpBody = postData
            } catch {
                completion(nil, error)
            }
        }
        
        didCallWebService(request: urlRequest, responseType: T.self, parameters: parameters, showLoader: showLoader, completion: completion)
    }
    
    // Download.
    func downloadFile(url: String?, parameters: Dictionary<String, Any>?, showLoader: Bool = false, downloadProgress: @escaping WebServiceDownloadHandler, completion: @escaping WebServiceCompletion<URL>) {
        
        if !ShoutoutConfig.inAppCheckIsConntectedToInternet() {
            completion(nil, WebServiceError.internetError)
            return
        }
        
        guard let urlString = url,
            let downloadUrl = URL(string: urlString) else {
                completion(nil, WebServiceError.invalidUrl)
                return
        }
        
        if showLoader {
            ShoutoutConfig.inAppShowLoader()
        }
        
        downloadProgressHandler = downloadProgress
        downloadCompletionHandler = completion
        let urlRequest = URLRequest(url: downloadUrl)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        let _ = session.downloadTask(with: urlRequest).resume()
    }
    
    // Request.
    fileprivate func didCallWebService<T: Codable>(request: URLRequest, responseType: T.Type, parameters: Dictionary<String, Any>?, showLoader: Bool = false, completion: @escaping WebServiceCompletion<T>) {

        if showLoader {
            ShoutoutConfig.inAppShowLoader()
        }
        _ = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if showLoader {
                    ShoutoutConfig.inAppHideLoader()
                }
                guard let dataReceived = data else {
                    completion(nil, error ?? WebServiceError.unknownError)
                    return
                }
                
                if self?.printLog == true {
                    let dictData = try? JSONSerialization.jsonObject(with: dataReceived, options: [])
                    self?.printLog(response: dictData as Any, url: response?.url?.absoluteString, parameters: parameters)
                }
                
                do {
                    let responseReceived = try JSONDecoder().decode(T.self, from: dataReceived)
                    completion(responseReceived, nil)
                } catch {
                    completion(nil, error)
                }
            }
            
        }.resume()
    }
    
    fileprivate func printLog(response: Any, url: String?, parameters: [String: Any]?) {
        
        print("_______________________________________________________________")
        print("API: \(url ?? "Unknown API")")
        print("________")
        print("Parameters: ")
        print(parameters as Any)
        print("________")
        print("Response: ")
        print(response as Any)
        print("_______________________________________________________________")
    }
}

extension WebService {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten / totalBytesExpectedToWrite)
        downloadProgressHandler?(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        ShoutoutConfig.inAppHideLoader()
        downloadProgressHandler?(1.0)
        downloadCompletionHandler?(location, nil)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        ShoutoutConfig.inAppHideLoader()
        if error != nil {
            downloadCompletionHandler?(nil, error)
        }
    }
}

//enum WebServiceError: Error {
//    case invalidUrl
//    case unknownError
//    case internetError
//    
//    var errorCode: Int {
//        switch self {
//        case .invalidUrl:
//            return 123
//        case .unknownError:
//            return 124
//        case .internetError:
//            return 125
//        }
//    }
//}

enum WebEndpoints: String {
    case greetingRequest = "shoutouts/greetings/request"
    case greetingList = "shoutouts/greetings"
    case occassionList = "occassions/lists"
    case greetingsUsageStats = "shoutouts/greetings/usage"
    case customerPassbook = "customers/passbook"
    case customerDeactivate = "customers/deactivate"
}
