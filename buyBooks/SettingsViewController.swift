//
//  SettingsViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/7/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var popUpview: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var resetStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserInfo()
        
        
        //make perfect round image
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        
        if(!isUserLoggedIn)
        {
            let ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            self.presentViewController(ViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editProfilePressed(sender: AnyObject) {
    
    
    }
    
    @IBAction func aboutPressed(sender: AnyObject) {
    
    
    }
    
    func getUserInfo(){
        if let user = FIRAuth.auth()?.currentUser {
            //change this later to full name
            print(user.email)
            print(user.photoURL)
            usernameLabel.text = user.displayName
            emailLabel.text = user.email
            //let uid = user.uid
            profileImage.setImageWithString(usernameLabel.text, color: UIColor.init(hexString: User.generateColor(usernameLabel.text!)))
            }
        else {
            
            // No user is signed in.
        }
        
    }

    @IBAction func signOutPressed(sender: AnyObject) {
        do{
            try FIRAuth.auth()?.signOut()
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "isUserLoggedIn")
        }catch let logoutError{
            print(logoutError)
        }
        
        

        performSegueWithIdentifier("signOutToHome", sender: nil)
    }
    
 
}
