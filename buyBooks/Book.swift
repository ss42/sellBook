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
    var detail: String?
    
    init(user: User, title: String, price: Double, pictures: String, condition: String, postedTime: String, detail: String)
    {
        self.sellerInfo = User()
        self.title = title
        self.price = price
        self.pictures = pictures
        self.condition = condition
        self.postedTime = postedTime
        self.detail = detail
    }
}