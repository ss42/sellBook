//
//  SellBooksViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase

class SellBooksViewController: UIViewController {
    var ref = FIRDatabase.database().reference()


    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var detail: UITextView!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var bookConditionSlider: UISlider!
    
    @IBOutlet weak var bookCondition: UILabel!
    
    var currentUserDictionary: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bookConditionSlider.minimumValue = 0
        bookConditionSlider.maximumValue = 100
        
                // Do any additional setup after loading the view.
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
            //make the user sign in first
            print("here")
            let ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            self.presentViewController(ViewController, animated: true, completion: nil)
        }
        
        
    }
    
    func getCurrentSellerInfo(){
        if let user = FIRAuth.auth()?.currentUser {
            //change this later to full name
            let name = user.email
            let email = user.email
            let profileImage = "male"
            let uid = user.uid
            currentUserDictionary = ["fullName": name!, "email": email!, "profilePhoto": profileImage, "uid": uid]
        } else {
            // No user is signed in.
        }

    }
    
    @IBAction func bookCondition(sender: UISlider) {
        if bookConditionSlider.value < 25{
            bookCondition.text = "okay"
        }
        else if bookConditionSlider.value > 25 && bookConditionSlider.value < 50{
            bookCondition.text = "Average"
        }
        else if bookConditionSlider.value > 50 && bookConditionSlider.value < 75 {
            bookCondition.text = "Very Good"
        }
        else if bookConditionSlider.value > 75 {
            bookCondition.text = "Excellent"
        }
        
        
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.getCurrentSellerInfo()
        currentUserDictionary = ["bookTitle": bookTitle.text!, "bookDetail": detail.text!, "bookCondition": bookCondition.text!, "price": price.text!, "bookImage": "male"]
        ref.child("SellBooksPost").setValue(currentUserDictionary)
    }



}
