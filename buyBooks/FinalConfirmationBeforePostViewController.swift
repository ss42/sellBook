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
    
    @IBAction func confirmPressed(sender: AnyObject) {
        getCurrentSellerInfo()
        
    }
    
    func getCurrentSellerInfo(){
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
            var tempDict = self.bookInfoDict
            tempDict["fullName"] = name!
            tempDict["email"] = email!
            tempDict["profilePhoto"] = profileImage
            
            tempDict["SellBooksPostId"] = postId.key
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
        retailPrice.text = "fix later"
        //
        pageCount.text = bookInfoDict["pageCount"]
        bookCondition.text = bookInfoDict["bookCondition"]
        ourPrice.text = bookInfoDict["price"]
        bookImage.image = image
        
        
        print("populated fields")
        
        print(bookTitle.text!)
        print(ISBN.text!)
        
       
        
        print("populated????")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()

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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
