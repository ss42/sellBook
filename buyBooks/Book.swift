//
//  Book.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation


class Book{
    
    // TODO: finish these cases and create a function for the initializer to set the value based on time and the string passed in
    enum bookDisplayConditions{
        case defaultCase
        case confirmedSold
        case mailSentToBuyer
        case deleted
        case dorment
        
    }
    
    // TODO: have to update the database with this new field (time of mail)
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
    //var detail: String?
    var postId: String?
    var webDescription: String?
    var webPrice: String?
    var webAuthors: String?
    var webBookThumbnail: String?
    var webPageCount: String?
    var webISBN: String?
    var publishedYear: String?
    var bookSold:Bool?
    var bookStatus:String?
    // added to calculate how long ago the mail was sent
    var timeOfMail:String?
    // TODO: create superimposed images (banner in the table view, in the corner of each cell)
    var superimposedImage:String?
    
    
    
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
    init(user: User, title: String, price: Double, pictures: String, condition: String, postedTime: String, postId:String, isbn:String, authors: String, imageURL: String, pageCount:String, description:String, yearPublished:String, sold:Bool)
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
        self.bookSold = sold
    }
    
    init(user: User, title: String, price: Double, pictures: String, condition: String, postedTime: String, postId:String, isbn:String, authors: String, imageURL: String, pageCount:String, description:String, yearPublished:String, status:String)
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
        self.bookStatus = status
        self.timeOfMail = " "
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


