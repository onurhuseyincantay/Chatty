//
//  Extensions.swift
//  Chatty
//
//  Created by onur hüseyin çantay on 24/09/2017.
//  Copyright © 2017 onur hüseyin çantay. All rights reserved.
//

import Foundation
import UIKit
let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView {
    func loadImagesWithCache (urlString : String ) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                DispatchQueue.main.async{
                    if let downloadImage = UIImage(data : data!) {
                        imageCache.setObject(downloadImage, forKey: urlString as NSString)
                        self.image = downloadImage
                    }
                }
            }).resume()
    }
}
}
