//
//  URLTester.swift
//  Poonam Pandey
//
//  Created by RazrTech2 on 13/06/18.
//  Copyright © 2018 Razrcorp. All rights reserved.
//

import Foundation

class URLTester {
    
    class func verifyURL(urlPath: String, completion: @escaping (_ isOK: Bool)->()) {
        if let url = URL(string: urlPath) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let httpResponse = response as? HTTPURLResponse, error == nil {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            }
            task.resume()
        } else {
            completion(false)
        }
    }
    
    class func verifyURLOnLiveScreen(urlPath: String, completion: @escaping (_ isOK: Bool)->()) {
        if let url = URL(string: urlPath) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let httpResponse = response as? HTTPURLResponse, error == nil {
                    completion(httpResponse.statusCode == 200)
                } else {
                    completion(false)
                }
            }
            task.resume()
        } else {
            completion(false)
        }
    }
    
    
}
