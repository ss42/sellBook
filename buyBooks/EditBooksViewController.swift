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
    
    
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var detail: UITextView!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var bookConditionSlider: UISlider!
    
    @IBOutlet weak var bookCondition: UILabel!
    
    @IBOutlet weak var relistBookButton: UIButton!
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
            self.currentUserDictionary["timeOfMail"] = snapshot.value!["timeOfMail"] as! String
            
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
        relistBookButton.hidden = true
        if timeElapsedinSeconds(currentUserDictionary["postedTime"] as! String) > 60*60*24*30
        {
            relistBookButton.hidden = false
        }
        
        
    }
    
    func timeElapsedinSeconds(date: String)-> Double{
        
        let dateformatter = NSDateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postedDate  = dateformatter.dateFromString(date)!
        
        let elapsedTimeInSeconds = NSDate().timeIntervalSinceDate(postedDate)
        return elapsedTimeInSeconds
    }

    
    func calculateSliderPosition() -> Float{
        let val = currentUserDictionary["bookCondition"] as? String
        if val == "Used - Fair"{
            return 10
        }
        else if val == "Used - Very Good"{
            return 37
        }
        else if val == "Used - Excellent"{
            return 63
        }
        else if val == "New"{
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
            bookCondition.text = "Used - Fair"
        }
        else if bookConditionSlider.value > 25 && bookConditionSlider.value < 50{
            bookCondition.text = "Used - Very Good"
        }
        else if bookConditionSlider.value > 50 && bookConditionSlider.value < 75 {
            bookCondition.text = "Used - Excellent"
        }
        else if bookConditionSlider.value > 75 {
            bookCondition.text = "New"
        }
        
        
    }
    func setDictValues(){
        self.currentUserDictionary["bookCondition"] = bookCondition.text
        self.currentUserDictionary["description"] = detail.text
        self.currentUserDictionary["price"] = price.text
        self.currentUserDictionary["bookTitle"] = bookTitle.text
    }
    
    @IBAction func deletePost(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.displayDeleteAlertMessage("Listing deleted!", message: "If you deleted the post in error, please relist it!")
        })
    }
    
    
    
    @IBAction func confirmSale(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.displayConfirmAlertMessage("Sale confirmed!", message: "Thank you for using the Book-Rack app! Please relist the book if the sale falls through (also rate us on the app store)")
        })
        
    }
    
    func displayMyAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil);
    }

    
    func areFieldsOK()->Bool{
        var ok: Bool = true
        if (self.bookTitle.text!.characters.count < 1)
        {
            ok = false
            self.displayMyAlertMessage("Title missing", message: "Field Required *")
            bookTitle.attributedPlaceholder = NSAttributedString(string:"Enter the Title!",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        if (self.detail.text!.characters.count < 1)
        {
            ok = false

            self.displayMyAlertMessage("Book Details Missing", message: "Please enter something!")
            //detail.attributedPlaceholder = NSAttributedString(string: "Enter the year book was published" ,attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
        if self.price.text?.characters.count > 3{
            self.price.text = ""
        }
        
        if self.price.text == "" {
            ok = false

            self.displayMyAlertMessage("Price missing or Invalid", message: "Please enter a maximum of three digits!")
            price.attributedPlaceholder = NSAttributedString(string: "Set the price!" ,attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        
        
        return ok
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        //self.getCurrentSellerInfo()
        // TODO: make sure nothing is totally empty
        
        
        if (areFieldsOK() == true)
        {
            self.setDictValues()
            self.updatePostOnDatabase()
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.dataChangedForHomeAndSearch = true
            appDelegate.dataChangedForMyBooks = true
            //self.performSegueWithIdentifier("myBookListings", sender: nil)
            navigationController?.popViewControllerAnimated(true)
        }
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
    
    func displayRelistBookMessage(title: String, message: String){
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let relistAction = UIAlertAction(title: "Confirm relisting of book", style: UIAlertActionStyle.Default, handler: reListButton) // change title
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelButton)
        
        myAlert.addAction(relistAction)
        myAlert.addAction(cancelAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    
    func confirmButton(alert:UIAlertAction!)
    {
        print("ok")
        self.currentUserDictionary["bookStatus"] = "sold"
        self.setDictValues()
        self.updatePostOnDatabase()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataChangedForHomeAndSearch = true
        appDelegate.dataChangedForMyBooks = true
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func cancelButton(alert:UIAlertAction!)
    {
       // self.dismissViewControllerAnimated(true, completion: nil)
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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataChangedForHomeAndSearch = true
        appDelegate.dataChangedForMyBooks = true
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func reListButton(alert:UIAlertAction!)
    {
        print("relisting")
        self.currentUserDictionary["bookStatus"] = "default"
        self.currentUserDictionary["postedTime"] = getCurrentTime()
        self.setDictValues()
        self.updatePostOnDatabase()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataChangedForHomeAndSearch = true
        appDelegate.dataChangedForMyBooks = true
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    // TODO: why did we remove dispatch_async?
    @IBAction func relistBook(sender: AnyObject) {
        print("pressed relist button, popup should show")
            
            self.displayRelistBookMessage("Would you like to relist this book?", message: "If your book has been listed for more than three months it will be hidden, please relist your book (perhaps at a more attractive price) if you want it to be displayed again.")
     
    }
    
    /*func alert(title: String, msg: String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: title, style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }*/

    func getCurrentTime()-> String{
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTimeAndDate:String = dateFormatter.stringFromDate(todaysDate)
        return currentTimeAndDate
    }
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
