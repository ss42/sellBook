//
//  Book.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation


class Book{
    
    
    
    // function not used
    static func howShouldBookBeDisplayed(timeOfMail:String, bookStatus:String)->String{
        if timeOfMail != ""{
            // if timeOfMail < 24 hours
            return "attempted purchase x hours ago"
            // if time of mail > 24 hours
            //return "attempted purchase more than one day ago, remove listing tag?"
            // if time of mail > 72 hours then the thing should not be listed maybe
        }
        return " "
    }
    
    var sellerInfo: User?
    var title: String?
    var price: Double?
    var pictures: String?
    var condition: String?
    var postedTime: String?
    var postId: String?
    var webDescription: String?
    var webPrice: String?
    var webAuthors: String?
    var webBookThumbnail: String?
    var webPageCount: String?
    var webISBN: String?
    var publishedYear: String?
    var bookStatus:String?
    // added to calculate how long ago the mail was sent
    var timeOfMail:String?

    
    
    
    
    
    init(user: User, title: String, price: Double, pictures: String, condition: String, postedTime: String, postId:String, isbn:String, authors: String, imageURL: String, pageCount:String, description:String, yearPublished:String, status:String)
    {
        self.sellerInfo = user
        self.title = title
        self.price = price
        self.pictures = pictures
        self.condition = condition
        self.postedTime = postedTime
        self.postId = postId
        self.webPageCount = pageCount
        self.webDescription = description
        self.webBookThumbnail = imageURL
        self.webAuthors = authors
        self.webISBN = isbn
        self.publishedYear = yearPublished
        self.bookStatus = status
        self.timeOfMail = " "
    }

}


