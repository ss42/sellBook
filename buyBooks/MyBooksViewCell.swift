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
    
    @IBOutlet weak var postedTime: UILabel!
    
    //@IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
