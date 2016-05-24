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
  //  var phoneNumber: String?
    var profileImage: String?
    
    
    init(fullName: String,  email:String, profileImage: String)
    {
        self.fullName = fullName
       // self.phoneNumber = phoneNumber
        self.email = email
        self.profileImage = profileImage
    }
    init()
    {
        self.fullName = ""
        self.email = ""
        self.profileImage = ""
    }
    
}