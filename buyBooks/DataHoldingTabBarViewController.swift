//
//  DataHoldingTabBarViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/2/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class DataHoldingTabBarViewController: UITabBarController {

    var sellBookArray: NSMutableArray = []
    var cache = ImageLoadingWithCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // changes the bars background color
        UITabBar.appearance().barTintColor = UIColor.whiteColor()
                UITabBar.appearance().translucent = false

        // loop sets the color of every custom tab bar item as some color (light blue)
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.darkTextColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
