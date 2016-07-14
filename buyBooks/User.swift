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
        self.fullName = " "
        self.email = " "
        self.profileImage = " "
        
    }
    
    static func generateColor(sellerName:String)->String{
        let hexValues = ["9FB4CC", "DB7705", "63A69F", "910DFF", "AAD8B0", "FFB25C", "7A0C40", "C9D787", "7ECEFD", "CCCC52", "FF7F00", "EA2E49", "F2594B", "A1E8D9", "CFC291", "716B82", "AB9FBA", "BA7D64", "35A676", "35A676", "0DFFD1", "0CF586", "0C66F5", "48696F", "AA9C92", "AA9C92"]//, "BF7EA2", "FF8B5E"]

        let len = sellerName.hash
        var num = len % (hexValues.count)
        if num < 0{
            num = num * (-1)
        }
        return hexValues[num]
       
    }
    
}
