//
//  AboutViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/7/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    
    @IBOutlet weak var aboutTitle: UILabel!
    
    @IBOutlet weak var detail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //blur background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        //view.sendSubviewToBack(blurEffectView)
        // TODO: change this about title and maybe add some buttons here
        // TODO: add what we need to add for the facebook and the google apis
        detail.text = "This app was made by Sanjay and Rahul! To get in touch with us please send us an email or with your favorite social media timesink!"
        view.addSubview(blurEffectView)
        view.addSubview(aboutTitle)
        view.addSubview(detail)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
