//
//  Book.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation
import Firebase


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
    var price: Int?
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
    var valid:Bool?

    
    init(snapshot: FIRDataSnapshot){
        
        
        self.title = snapshot.value!["bookTitle"] as! String
        //let detail = snapshot.value!["bookDetail"] as! String
        self.condition = snapshot.value!["bookCondition"] as! String
        // let bookImage = snapshot.value!["imageURL"] as! String
        self.price = Int(snapshot.value!["price"] as! String)
        let sellerName = snapshot.value!["fullName"] as! String
        let sellerEmail = snapshot.value!["email"] as! String
        let sellerProfilePhoto = snapshot.value!["profilePhoto"] as! String
        self.postedTime = snapshot.value!["postedTime"] as! String
        let elapsedTime = postedTime//self.timeElapsed(postedTime)
        self.webISBN = snapshot.value!["isbn"] as! String
        self.webPageCount = snapshot.value!["pageCount"] as! String
        self.webAuthors = snapshot.value!["authors"] as! String
        self.webBookThumbnail = snapshot.value!["imageURL"] as! String
        self.webDescription = snapshot.value!["description"] as! String
        self.publishedYear = snapshot.value!["publishedDate"] as! String
        self.postId = snapshot.value!["SellBooksPostId"] as! String
        
        
        self.bookStatus = snapshot.value!["bookStatus"] as! String
        
        // print(title)
        // TODO: make sure that we want books to be hidden if they were posted more than a month ago
        if (bookStatus != "deleted"){
            //&& (self.timeElapsedinSeconds(postedTime) < 60*60*24*30)){ //&& bookStatus != "sold"){
            
            
            self.timeOfMail = " "
            print("non deleted book")
            
            self.sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
            
            
            
            //let tempBook = Book(user: sellerInfo, title: title, price: Int(price)!, condition: condition, postedTime: elapsedTime, postId: postId, isbn: isbn, authors: authors, imageURL: imageURL, pageCount: pageCount, description: description, yearPublished: publishedDate, status: bookStatus, timeOfMail: timeOfMail)
            
            if (self.timeElapsedinSeconds(postedTime!) < 60*60*24*30 || (bookStatus == "sold" && self.timeElapsedinSeconds(postedTime!) < 60*60*24*90)){
                self.valid = true
                // FIX THIS
                //self.sellBookArray.insertObject(tempBook, atIndex: 0)
            }
            else
            {
                self.valid = false
            }
            
        }
        else
        {
            print("saw a deleted book")
            self.valid = false
        }
        
 
    }
    
    func timeElapsedinSeconds(date: String)-> Double{
        
        let dateformatter = NSDateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postedDate  = dateformatter.dateFromString(date)!
        
        let elapsedTimeInSeconds = NSDate().timeIntervalSinceDate(postedDate)
        return elapsedTimeInSeconds
    }
    
    
    init(user: User, title: String, price: Int,  condition: String, postedTime: String, postId:String, isbn:String, authors: String, imageURL: String, pageCount:String, description:String, yearPublished:String, status:String, timeOfMail: String)
    {
        self.sellerInfo = user
        self.title = title
        self.price = price
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


