//
//  File.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/21/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation

class PrivacyPolicyForAboutViewController: UIViewController {
    
    
    
    @IBOutlet weak var privacy: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        privacy.textColor = UIColor.darkGrayColor()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        self.privacy.setContentOffset(CGPointZero, animated: false)
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        let vc: UIViewController = storyboard!.instantiateViewControllerWithIdentifier("AboutViewController")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
}