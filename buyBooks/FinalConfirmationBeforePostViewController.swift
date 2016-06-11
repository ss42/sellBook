//
//  FinalConfirmationBeforePostViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/30/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase

class FinalConfirmationBeforePostViewController: UIViewController {
    var ref = FIRDatabase.database().reference()

    var bookInfoDict = [String:String]()
    var image:UIImage?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var ISBN: UILabel!
    
    @IBOutlet weak var retailPrice: UILabel!
    
    @IBOutlet weak var bookDescription: UITextView!
    
    @IBOutlet weak var pageCount: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    
    @IBOutlet weak var bookCondition: UILabel!
    
    @IBOutlet weak var ourPrice: UILabel!
    @IBOutlet weak var yearPublished: UILabel!
    
    @IBAction func confirmPressed(sender: AnyObject) {
        getCurrentSellerInfo()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataChangedForMyBooks = true
        appDelegate.dataChangedForHome = true

        self.performSegueWithIdentifier("backToHome", sender: nil)

        
    }
    
    func getCurrentSellerInfo(){
        if let user = FIRAuth.auth()?.currentUser {
            //change this later to full name
            print(user.email)
            print(user.photoURL)
            let name = user.displayName
            let email = user.email
            let uid = user.uid
            let profileImage = "male"
            //let uid = user.uid
            
            let postId = ref.child("SellBooksPost").childByAutoId()
            var tempDict = self.bookInfoDict
            tempDict["fullName"] = name!
            tempDict["email"] = email!
            tempDict["profilePhoto"] = profileImage
            tempDict["uid"] = uid
            tempDict["SellBooksPostId"] = postId.key
            tempDict["postedTime"] = getCurrentTime()
            tempDict["bookStatus"] = "default"
            tempDict["timeOfMail"] = " "
            
            //currentUserDictionary = ["fullName": name!, "email": email!, "profilePhoto": profileImage, "bookTitle": bookTitle.text!, "bookDetail": detail.text!, "bookCondition": bookCondition.text!, "price": price.text!, "bookImage": "male", "postedTime": "5:50", "uid":uid, "SellBooksPostId": postId.key]
            // moved from donePressed
            //currentUserDictionary = []
            postId.setValue(tempDict)
        } else {
            // No user is signed in.
        }
        
    }
    
    func populateFields(){
        
        // bookInfoDict = ["isbn" : ISBN, "title" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
        bookTitle.text = self.bookInfoDict["bookTitle"]
        
        bookDescription.text = self.bookInfoDict["description"]
        
        
        authors.text = bookInfoDict["authors"]
        ISBN.text = bookInfoDict["isbn"]
        //retailPrice.text = "fix later"
        //
        pageCount.text = bookInfoDict["pageCount"]
        bookCondition.text = bookInfoDict["bookCondition"]
        ourPrice.text = bookInfoDict["price"]
        bookImage.image = image
        yearPublished.text = bookInfoDict["publishedDate"]
        
        
        print("populated fields")
        
        print(bookTitle.text!)
        print(ISBN.text!)
        
       
        
        print("populated????")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image == nil{
            print("no image! we shouldnt see this!")
        }
        populateFields()
        
        
        //sets the background as image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        //sets the background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
        view.addSubview(popupView)
        //.addSubview(signUp)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "backToSetPriceAndCondition"{
            let vc = segue.destinationViewController as! SetPriceAndConditionFromSearchViewController
            
            vc.bookInfoDict = self.bookInfoDict
            vc.image = image
            //vc.bookImage.image = self.bookImage!
            //self.presentViewController(vc, animated: true, completion: nil)
            print("going back to set price/condition view")
        }
    }

    func getCurrentTime()-> String{
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTimeAndDate:String = dateFormatter.stringFromDate(todaysDate)
        return currentTimeAndDate
    }
    
    
    // TODO: do comments like this, see http://nshipster.com/swift-documentation/
    /**
     Lorem ipsum dolor sit amet.
     
     - parameter bar: Consectetur adipisicing elit.
     
     - returns: Sed do eiusmod tempor.
     */
    func sayOk(alert: UIAlertAction!)
    {
        print("ok, okay, o k")
    }
    
    //to display alert for errors
    func displayMyAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: sayOk)
        myAlert.addAction(okAction)
        print("here1")
        self.presentViewController(myAlert, animated: true, completion: nil);
        print("here")
        self.dismissViewControllerAnimated(true, completion: nil)
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
