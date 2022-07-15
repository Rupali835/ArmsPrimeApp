//
//  APMSetImage.swift
//  AnveshiJain
//
//  Created by Sameer Virani on 06/05/20.
//  Copyright © 2020 Armsprime. All rights reserved.
//

import Foundation
import UIKit

public typealias ImageResponse = (APMResult<UIImage, Error>) -> Void

protocol APMImageRequestable {
    func setImage(urlString: String, placeHolderImage: UIImage?, completionBlock: ImageResponse?)
}

extension APMImageRequestable where Self: UIImageView {

    func setImage(urlString: String, placeHolderImage: UIImage? = nil, completionBlock: ImageResponse?) {

        self.image = (placeHolderImage != nil) ? placeHolderImage! : nil
        self.showActivityIndicator()

        if let cachedImage = APMCache.shared.object(forKey: urlString as AnyObject) as? UIImage {
            self.hideActivityIndicator()
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            guard let completion = completionBlock else { return }
            return completion(.success(cachedImage))
        } else {
            APMURLSession.default.downloadImage(using: urlString) { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.hideActivityIndicator()
                switch response {
                case .success(let image):
                    DispatchQueue.main.async {
                        strongSelf.image = image
                    }
                    guard let completion = completionBlock else { return }
                    return completion(.success(image))
                case .failure(let error):
                    guard let completion = completionBlock else { return }
                    return completion(.failure(error))
                }
            }
        }
    }
}
