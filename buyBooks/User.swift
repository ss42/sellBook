//
//  User.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation


class User{
    
    var fullName: String?
    var email: String?
    var profileImage: String?
   
    
    init(fullName: String,  email:String, profileImage: String)
    {
        self.fullName = fullName
        self.email = email
        self.profileImage = profileImage
        
    }
    init()
    {
        self.fullName = ""
        self.email = ""
        self.profileImage = ""
        
    }
    
    static func generateColor(sellerName:String)->String{
        let arr = ["9FB4CC", "DB7705", "63A69F", "910DFF", "AAD8B0", "FFB25C", "7A0C40", "C9D787", "7ECEFD", "CCCC52", "FF7F00", "EA2E49", "F2594B", "A1E8D9", "CFC291"]

        let len = sellerName.hash
        var num = len % (arr.count - 1)
        if num < 0{
            num = num * (-1)
        }
        return arr[num]
       
    }
    
}
