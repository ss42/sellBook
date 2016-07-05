//
//  ImageLoadingWithCache.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 7/5/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation


class ImageLoadingWithCache {
    
    var imageCache = [String:UIImage]()
    
    func getImage(url: String, imageView: UIImageView, defaultImage: String) {
        if let img = imageCache[url] {
            imageView.image = img
        } else {
            
            let session = NSURLSession.sharedSession()
            let imgURL: NSURL = NSURL(string: url)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            let task = session.dataTaskWithRequest(request){(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    self.imageCache[url] = image
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        imageView.image = image
                        print("sent image to view")
                    })
                }
                else {
                    imageView.image = UIImage(named: defaultImage)
                    print("load failed")
                }
                
            }
            task.resume()
        }
    }
    
    func getImage(url:String, defaultImage:String)->UIImage{
        if let img = imageCache[url]{
            return img
        }
        else{
            return UIImage(named: "male")!
        }
    }
}

