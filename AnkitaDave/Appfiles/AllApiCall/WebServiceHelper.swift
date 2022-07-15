//
//  WebServiceHelper.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 22/04/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

typealias WebServiceCompletion<T> = (_ response: T?, _ error: Error?) -> ()
typealias WebServiceDownloadHandler = (_ progress: Float) -> ()

class WebServiceHelper: NSObject, URLSessionDelegate, URLSessionDownloadDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    // Public properties
    public static let shared = WebServiceHelper()
    
    // Private
    fileprivate let printLog: Bool = true
    fileprivate var appActivityIndicator = NVActivityIndicatorView(frame: CGRect.zero, type: .ballTrianglePath, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), padding: 0.0)
    
    // Download
    fileprivate var downloadProgressHandler: WebServiceDownloadHandler?
    fileprivate var downloadCompletionHandler: WebServiceCompletion<URL>?
    
    fileprivate var headers: Dictionary<String, String> {
        var headers: Dictionary<String, String> = ["ApiKey": Constants.API_KEY, "Content-Type": "application/json"]
        headers["Authorization"] = Constants.TOKEN
        
        return headers
    }
    
    // Disable instantiation
    private override init() {
        super.init()
    }
    
    // GET
    func callGetMethod<T: Codable>(endPoint: String, parameters: Dictionary<String, Any>?, responseType: T.Type, showLoader: Bool = false, baseURL: String = Constants.App_BASE_URL, completion: @escaping WebServiceCompletion<T>) {
        
        if !inAppCheckIsConntectedToInternet() {
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
        
        var defaultParameters = ["platform": Constants.PLATFORM_TYPE]
        defaultParameters["artist_id"] = Constants.CELEB_ID
        defaultParameters["v"] = Constants.VERSION

        for (_, info) in defaultParameters.enumerated() {
            if parameterSufix == "" {
                parameterSufix = parameterSufix + "?\(info.key)=\(info.value)"
            } else {
                parameterSufix = parameterSufix + "&\(info.key)=\(info.value)"
            }
        }
        
        guard let url = URL(string: baseURL + endPoint + parameterSufix) else {
            completion(nil, WebServiceError.invalidUrl)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        
        didCallWebService(request: urlRequest, responseType: T.self, parameters: parameters, showLoader: showLoader, completion: completion)
    }
    
    // POST
    func callPostMethod<T: Codable>(endPoint: String, parameters: Dictionary<String, Any>?, responseType: T.Type, showLoader: Bool = false, httpHeaders: Dictionary<String, String>?, completion: @escaping WebServiceCompletion<T>) {
        
        if !inAppCheckIsConntectedToInternet() {
            completion(nil, WebServiceError.internetError)
            return
        }
        
        guard let url = URL(string: Constants.App_BASE_URL + endPoint) else {
            completion(nil, WebServiceError.invalidUrl)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        if let paramHeaders = httpHeaders {
            urlRequest.allHTTPHeaderFields = paramHeaders
        } else {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if var parameter = parameters {
            parameter["platform"] = Constants.PLATFORM_TYPE
            parameter["artist_id"] = Constants.CELEB_ID
            parameter["v"] = Constants.VERSION
            
            do {
                let postData = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
                urlRequest.httpBody = postData
            } catch {
                completion(nil, error)
            }
        }
        
        didCallWebService(request: urlRequest, responseType: T.self, parameters: parameters, showLoader: showLoader, completion: completion)
    }
    
    // Download
    func downloadFile(url: String?, parameters: Dictionary<String, Any>?, showLoader: Bool = false, downloadProgress: @escaping WebServiceDownloadHandler, completion: @escaping WebServiceCompletion<URL>) {
        
        if inAppCheckIsConntectedToInternet() {
            completion(nil, WebServiceError.internetError)
            return
        }
        
        guard let urlString = url,
            let downloadUrl = URL(string: urlString) else {
                completion(nil, WebServiceError.invalidUrl)
                return
        }
        
        if showLoader {
            inAppShowLoader()
        }
        
        downloadProgressHandler = downloadProgress
        downloadCompletionHandler = completion
        let urlRequest = URLRequest(url: downloadUrl)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        let _ = session.downloadTask(with: urlRequest).resume()
    }
    
    // URL Request
    fileprivate func  didCallWebService<T: Codable>(request: URLRequest, responseType: T.Type, parameters: Dictionary<String, Any>?, showLoader: Bool = false, completion: @escaping WebServiceCompletion<T>) {
        
        if showLoader {
            inAppShowLoader()
        }
        _ = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if showLoader {
                    self?.inAppHideLoader()
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
                    print("JSON Error")
                    completion(nil, error)
                }
            }
            
        }.resume()
    }
    
    // Print Log
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
    
    // Check Internet Reachability
    fileprivate func inAppCheckIsConntectedToInternet() -> Bool {
        if Reachability.isConnectedToNetwork() == false {
            if let topViewController = UIViewController.topViewController() {
                Alert.show(in: topViewController, title: "", message: Constants.NO_Internet_MSG, actionTitle: "Okay", cancelTitle: nil, comletionForAction: nil)
            }
            return false
        } else {
            return true
        }
    }
    
    // Show Loader
    fileprivate func inAppShowLoader() {
        
        if appActivityIndicator.superview == nil, let window = UIApplication.shared.keyWindow {
            appActivityIndicator.frame.size = CGSize(width: 40.0, height: 40.0)
            appActivityIndicator.center = window.center
            window.addSubview(appActivityIndicator)
        }
        
        appActivityIndicator.startAnimating()
    }
    
    // Hide Loader
    fileprivate func inAppHideLoader() {
        appActivityIndicator.stopAnimating()
    }
}

extension WebServiceHelper {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten / totalBytesExpectedToWrite)
        downloadProgressHandler?(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        inAppHideLoader()
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
        inAppHideLoader()
        if error != nil {
            downloadCompletionHandler?(nil, error)
        }
    }
}

enum WebServiceError: Error {
    case invalidUrl
    case unknownError
    case internetError
    
    var errorCode: Int {
        switch self {
        case .invalidUrl:
            return 123
        case .unknownError:
            return 124
        case .internetError:
            return 125
        }
    }
}
