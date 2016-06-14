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
    
    @IBOutlet weak var authors: UITextField!
    @IBOutlet weak var yearPublished: UITextField!

    
    var currentUserDictionary: NSDictionary?
    var bookInfoDict = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
    /*func getCurrentSellerInfo(){
        if let user = FIRAuth.auth()?.currentUser {
            //change this later to full name
            print(user.email)
            print(user.photoURL)
            let name = user.email
            let email = user.email
            let uid = user.uid
            let profileImage = "male"
            //let uid = user.uid
            
            let postId = ref.child("SellBooksPost").childByAutoId()
            
            currentUserDictionary = ["fullName": name!, "email": email!, "profilePhoto": profileImage, "bookTitle": bookTitle.text!, "bookDetail": detail.text!, "bookCondition": bookCondition.text!, "price": price.text!, "imageURL": "male", "postedTime": getCurrentTime(), "uid":uid, "SellBooksPostId": postId.key]
            // moved from donePressed
            //currentUserDictionary = []
            postId.setValue(currentUserDictionary)
        } else {
            // No user is signed in.
            
        }

    }*/
    
    func getCurrentTime()-> String{
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTimeAndDate:String = dateFormatter.stringFromDate(todaysDate)
        return currentTimeAndDate
    }

    
    func setDict(){
        //self.bookInfoDict["bookCondition"] = self.bookCondition.text!
        self.bookInfoDict["bookTitle"] = self.bookTitle.text!
        //self.bookInfoDict["price"] = self.price.text!
        self.bookInfoDict["description"] = self.detail.text!
        // we can get these from search results later 5/31
        self.bookInfoDict["isbn"] = "N/A"
        self.bookInfoDict["authors"] = "some author"
        //TODO make this a string and then check to see if it is the default string before we go try to load a url (if it is the default then skip webload and just do uiimage named etc.)
        self.bookInfoDict["imageURL"] = "http://i.imgur.com/zTFEK3c.png"
        // TODO: needs to be validated or some kind of default value
        self.bookInfoDict["authors"] = self.authors.text!
        self.bookInfoDict["publishedDate"] = self.yearPublished.text!
        
        
        // TODO: do something with this, maybe give a space to enter or just cut it out alltogether
        self.bookInfoDict["pageCount"] = "N/A"
        
        
        
    }
    
    
    // TODO: add slide gesture that calls this button
    @IBAction func donePressed(sender: AnyObject) {
        //self.getCurrentSellerInfo()
        if (self.authors.text!.characters.count < 2)
        {
            // show error or something
        }
        if (self.yearPublished.text!.characters.count < 4)
        {
            // show error( give option to enter a default year, if publication year is unknown (maybe))
        }
        
        if (self.authors.text!.characters.count >= 2 && self.yearPublished.text!.characters.count >= 4)
        {
            // now we can do self.setDict and perform segue
        }
        self.setDict()
        self.performSegueWithIdentifier("toSetPrice", sender: nil)

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "toSetPrice"{
            let vc = segue.destinationViewController as! SetPriceAndConditionFromSearchViewController
            
            vc.bookInfoDict = self.bookInfoDict
            //vc.image = self.bookImage.image
            // commented out 5/31, need to pass the user uploaded image or just a placeholder image!
            
            
            
            
            
            
            //vc.bookImage.image = self.bookImage!
            //self.presentViewController(vc, animated: true, completion: nil)
            print("going to detail view")
        }
    }


}

extension SellBooksViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        //add something may be?
        
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
