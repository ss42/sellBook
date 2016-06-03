//
//  Book.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation


class Book{
    var sellerInfo: User?
    var title: String?
    var price: Double?
    var pictures: String?
    var condition: String?
    var postedTime: String?
    //var detail: String?
    var postId: String?
    var webDescription: String?
    var webPrice: String?
    var webAuthors: String?
    var webBookThumbnail: String?
    var webPageCount: String?
    var webISBN: String?
    var publishedYear: String?
    
    
    
    init(user: User, title: String, price: Double, pictures: String, condition: String, postedTime: String, postId:String)
    {
        self.sellerInfo = user
        self.title = title
        self.price = price
        self.pictures = pictures
        self.condition = condition
        self.postedTime = postedTime
       // self.detail = detail
        self.postId = postId
        //self.webPageCount =
    }
    init(user: User, title: String, price: Double, pictures: String, condition: String, postedTime: String, postId:String, isbn:String, authors: String, imageURL: String, pageCount:String, description:String, yearPublished:String)
    {
        self.sellerInfo = user
        self.title = title
        self.price = price
        self.pictures = pictures
        self.condition = condition
        self.postedTime = postedTime
        //self.detail = detail
        self.postId = postId
        self.webPageCount = pageCount
        self.webDescription = description
        self.webBookThumbnail = imageURL
        self.webAuthors = authors
        self.webISBN = isbn
        self.publishedYear = yearPublished
        
    }
    
    //bookInfoDict = ["isbn" : ISBN, "title" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]

    /*init(user: User, info: Dictionary<String, String>)
    {
        self.sellerInfo = user
        self.webISBN = info["isbn"]
        self.webTitle = info["title"]
        self.webDescription = info["description"]
        self.webAuthors = info["authors"]
        self.webBookThumbnail = info["imageURL"]
        self.webPageCount = info["pageCount"]
        self.webPrice = "IMPLIMENT LATER"
        self.postId = 
    }*/
}


