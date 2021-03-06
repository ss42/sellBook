//
//  AvailableRidesTableViewCell.swift
//  Carpooling
//
//  Created by Sanjay Shrestha on 4/9/16.
//  Copyright © 2016 St Marys. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    

   
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var postedTime: UILabel!
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var bannerImage: UIImageView!
   
    
    @IBOutlet weak var yearPublished: UILabel!
    
    
    
    
    override func prepareForReuse() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
