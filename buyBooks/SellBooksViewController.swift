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

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var bookTitle: UITextField!
    
    @IBOutlet weak var detail: UITextView!
    
    @IBOutlet weak var authors: UITextField!
    @IBOutlet weak var yearPublished: UITextField!

    var firstEdit: Bool = true
    
    var currentUserDictionary: NSDictionary?
    var bookInfoDict = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detail.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        bookTitle.attributedPlaceholder = NSAttributedString(string: "Enter the Title of the Book" ,attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        authors.attributedPlaceholder = NSAttributedString(string:"Enter the authors",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        yearPublished.attributedPlaceholder = NSAttributedString(string: "Enter the year book was published" ,attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
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
    
   
    
    func getCurrentTime()-> String{
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTimeAndDate:String = dateFormatter.stringFromDate(todaysDate)
        return currentTimeAndDate
    }

    
    func setDict(){
        self.bookInfoDict["bookTitle"] = self.bookTitle.text!
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
        if (self.authors.text!.characters.count < 1)
        {
            self.displayMyAlertMessage("Authors missing", message: "Field Required *")
            authors.attributedPlaceholder = NSAttributedString(string:"Enter the authors",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        if (self.yearPublished.text!.characters.count < 4)
        {
            self.displayMyAlertMessage("Year Published Missing", message: "Field Required *")
            yearPublished.attributedPlaceholder = NSAttributedString(string: "Enter the year book was published" ,attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        if self.bookTitle.text == "" {
            self.displayMyAlertMessage("Book Title missing", message: "Field Required *")
            bookTitle.attributedPlaceholder = NSAttributedString(string: "Enter the Title of the Book" ,attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        
        if (self.authors.text!.characters.count >= 2 && self.yearPublished.text!.characters.count >= 4 && self.bookTitle != "")
        {
            self.setDict()
            self.performSegueWithIdentifier("toSetPrice", sender: nil)
        }
        
        
    }
    
    //to display alert for errors
    func displayMyAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: sayOk)
        myAlert.addAction(okAction)
        print("here1")
        self.presentViewController(myAlert, animated: true, completion: nil);
            }
    
    func sayOk(alert: UIAlertAction!)
    {
        print("ok, okay, o k")
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
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
       
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
extension SellBooksViewController: UITextViewDelegate{
    

    func textViewDidEndEditing(textView: UITextView) {
        
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        
    }
    /*
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        return true
    }*/
    
    func textViewDidBeginEditing(textView: UITextView) {
        if firstEdit == true
        {
            textView.text = ""
            firstEdit = false
        }
        print("textfield did begin editting")
        if textView == detail{
            print("lifting the view")
            scrollView.setContentOffset(CGPointMake(0, 100), animated: true)
        }
    }
    
    
}
