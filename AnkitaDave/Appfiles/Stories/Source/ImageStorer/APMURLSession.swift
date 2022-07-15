//
//  APMURLSession.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation
import UIKit

class APMURLSession: URLSession {
    static let `default` = APMURLSession()
    private(set) var dataTasks: [URLSessionDataTask] = []
}

extension APMURLSession {
    func cancelAllPendingTasks() {
        dataTasks.forEach({
            if $0.state != .completed {
                $0.cancel()
            }
        })
    }

    func downloadImage(using urlString: String, completionBlock: @escaping ImageResponse) {
        guard let url = URL(string: urlString) else {
            return completionBlock(.failure(APMError.invalidImageURL))
        }
        dataTasks.append(APMURLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let result = data, error == nil, let imageToCache = UIImage(data: result) {
                APMCache.shared.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                completionBlock(.success(imageToCache))
            } else {
                return completionBlock(.failure(error ?? APMError.downloadError))
            }
        }))
        dataTasks.last?.resume()
    }
}
