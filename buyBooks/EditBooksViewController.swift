//
//  EditBooksViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/25/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditBooksViewController: UIViewController {
    
    
    var ref = FIRDatabase.database().reference().child("SellBooksPost")
    var postId: String?
    
    
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var detail: UITextView!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var bookConditionSlider: UISlider!
    
    @IBOutlet weak var bookCondition: UILabel!
    
    var currentUserDictionary = [String:AnyObject]()
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tap to hide keyboard
        // TODO: add keyboard hiding by hitting the return key, its around here somewhere
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        bookConditionSlider.minimumValue = 0
        bookConditionSlider.maximumValue = 100
        
        self.price.delegate = self
        self.bookTitle.delegate = self
        // add more if needed
        
        loadDataFromPreviousViewController()
        
        // Do any additional setup after loading the view.
    }
  
    
    
    //let book:
    
    func loadDataFromPreviousViewController(){
        //fetchAndPopulateData(postId!)
        ref.child(postId!).observeEventType(.Value, withBlock:{
            snapshot in
            
             self.currentUserDictionary["bookTitle"] = snapshot.value!["bookTitle"] as! String
             self.currentUserDictionary["description"] = snapshot.value!["description"] as! String
             self.currentUserDictionary["bookCondition"] = snapshot.value!["bookCondition"] as! String
             self.currentUserDictionary["imageURL"] = snapshot.value!["imageURL"] as! String
             self.currentUserDictionary["price"] = snapshot.value!["price"] as! String
             self.currentUserDictionary["fullName"] = snapshot.value!["fullName"] as! String
             self.currentUserDictionary["email"] = snapshot.value!["email"] as! String
             self.currentUserDictionary["profilePhoto"] = snapshot.value!["profilePhoto"] as! String
             self.currentUserDictionary["postedTime"] = snapshot.value!["postedTime"] as! String
            self.populateData()
        })
     
    }
    
    func populateData(){
        bookTitle.text = currentUserDictionary["bookTitle"] as? String
        detail.text = currentUserDictionary["description"] as? String
        price.text = currentUserDictionary["price"] as? String
        bookCondition.text = currentUserDictionary["bookCondition"] as? String
        // may need to change photo (5/26)
        // possibly move the slider to some position (5/26)
        bookConditionSlider.value = calculateSliderPosition()
    }
    
    func calculateSliderPosition() -> Float{
        let val = currentUserDictionary["bookCondition"] as? String
        if val == "okay"{
            return 10
        }
        else if val == "Average"{
            return 37
        }
        else if val == "Very Good"{
            return 63
        }
        else if val == "Excellent"{
            return 90
        }
        return 0
    }

    // done for wednesday
    // now we have to get the post from the postId and populate fields and then update the database when done is tapped and then segue back, similar to our navigation maybe or just jump to the tab view? (not sure about this).
    
    // 
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
            
            currentUserDictionary = ["fullName": name!, "email": email!, "profilePhoto": profileImage, "bookTitle": bookTitle.text!, "bookDetail": detail.text!, "bookCondition": bookCondition.text!, "price": price.text!, "bookImage": "male", "postedTime": "5:50", "uid":uid, "SellBooksPostId": postId.key]
            // moved from donePressed
            //currentUserDictionary = []
            postId.setValue(currentUserDictionary)
        } else {
            // No user is signed in.
        }
        
    }
    */
    
    func updatePostOnDatabase()
    {
        ref.child(postId!).updateChildValues(self.currentUserDictionary)
        print("should have updated")
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
    func setDictValues(){
        self.currentUserDictionary["bookCondition"] = bookCondition.text
        self.currentUserDictionary["description"] = detail.text
        self.currentUserDictionary["price"] = price.text
        self.currentUserDictionary["bookTitle"] = bookTitle.text
        // maybe change "sold" to "no"
    }
    
    @IBAction func deletePost(sender: UIButton) {
        // later
        dispatch_async(dispatch_get_main_queue(), {
            
            self.displayDeleteAlertMessage("Listing deleted!", message: "If you deleted the post in error, please relist it!")
        })
    }
    
    
    
    @IBAction func confirmSale(sender: AnyObject) {
        //self.currentUserDictionary["bookStatus"] = "sold"
        dispatch_async(dispatch_get_main_queue(), {
            
            self.displayConfirmAlertMessage("Sale confirmed!", message: "Thank you for using the Book-Rack app! Please relist the book if the sale falls through (also rate us on the app store)")
        })
        /*self.setDictValues()
        self.updatePostOnDatabase()
        
        navigationController?.popViewControllerAnimated(true)
 */
    }
    
    // TODO: this should set something that causes the home vc to reload data.
    @IBAction func donePressed(sender: AnyObject) {
        //self.getCurrentSellerInfo()
        self.setDictValues()
        self.updatePostOnDatabase()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataChangedForHome = true
        appDelegate.dataChangedForMyBooks = true
        //self.performSegueWithIdentifier("myBookListings", sender: nil)
        navigationController?.popViewControllerAnimated(true)

        // try different segue types to make sure that the navbar and stuff works
        
        
        
    }
    
    func displayConfirmAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Confirm Sale of Book", style: UIAlertActionStyle.Default, handler: confirmButton) // change title
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelButton)
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    
    
    func confirmButton(alert:UIAlertAction!)
    {
        print("ok")
        //captureSession.startRunning()
        self.currentUserDictionary["bookStatus"] = "sold"
        self.setDictValues()
        self.updatePostOnDatabase()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func cancelButton(alert:UIAlertAction!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func displayDeleteAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Confirm Deletion", style: UIAlertActionStyle.Default, handler: deleteButton) // change title
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelButton)
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    func deleteButton(alert:UIAlertAction!)
    {
        print("ok")
        //captureSession.startRunning()
        self.currentUserDictionary["bookStatus"] = "deleted"
        self.setDictValues()
        self.updatePostOnDatabase()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*func alert(title: String, msg: String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: title, style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }*/

    
}

extension EditBooksViewController: UITextFieldDelegate{
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
        print("keyboard should go away")
        self.view.endEditing(true)
        return true
    }
    
    
    
}
