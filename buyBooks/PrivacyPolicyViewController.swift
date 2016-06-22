//
//  File.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/21/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation

class PrivacyPolicyViewController: UIViewController {
    
    
    
    @IBOutlet weak var privacy: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        self.privacy.setContentOffset(CGPointZero, animated: false)
    }

}