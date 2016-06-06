//
//  MyBooksViewCell.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/25/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//
//

import UIKit

class MyBooksViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var postedTime: UILabel!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var yearPublished: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
