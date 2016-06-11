//
//  AppDelegate.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var dataChangedForHomeAndSearch: Bool = false
    var dataChangedForMyBooks: Bool = false

    var cache = ImageLoadingWithCache()

        // crash fix maybe
    override init() {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //FIRApp.configure()
        print("after config")
        //UILabel.appearance().substituteFontName = "SF-UI-Text-Regular"
        
        // previous line for setting a default text font and size
        
        
        
        
        
        
        
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)//UIColor(red: 41/255, green: 176/255, blue: 206/255, alpha: 1.0) // this changes the heading thing
        
        //UINavigationBar.appearance().tintColor = UIColor.blackColor() // this changes the icons on the nav bar (changes the color of them).
        
        
        
        
        // used to print all font names and their internal identifiers
        /*for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("==\(names)")
            }
        }
        */
                
        if let barFont = UIFont(name: "Avenir Light", size: 22.0){
            print("font stuff")
            UINavigationBar.appearance().titleTextAttributes = [ NSFontAttributeName: barFont]
            print("after setting font for navbar")
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Override point for customization after application launch.
        //
        //return true
    }
    
    func application(application: UIApplication,
                     openURL url: NSURL,
                             sourceApplication: String?,
                             annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            openURL: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

