//
//  AboutViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/7/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var detail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detail.text = "This app was made by Sanjay and Rahul! To get in touch with us please send us an email or with your favorite social media timesink!"
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
