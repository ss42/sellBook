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
