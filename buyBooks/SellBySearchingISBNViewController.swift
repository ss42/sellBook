//
//  SellBySearchingISBNViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/30/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

// TODO main thread the slide up when entering the isbn, also be sure to put in a popup that yells at you when the field is blank or less than ten characters!

class SellBySearchingISBNViewController: UIViewController, UITextFieldDelegate {
    
    var bookInfoDict = [String:String]()
    var bookImage:UIImage?
    
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isbnTextfield: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var bookAPI = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                //Activity Indicator
                activityView.color = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
                activityView.center = self.view.center
                
                activityView.startAnimating()
                
                self.view.addSubview(activityView)

                if let ISBN = isbnTextfield.text{
                    lookUpData(ISBN)
                }
                else{
                    //show error
                    //may be check for 10 digit or 13 digit also
                }
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped left")
                cancelButton.sendActionsForControlEvents(.TouchUpInside)
                /*let home = storyboard?.instantiateInitialViewController()
                UIView.transitionWithView(self.window!, duration: 0.5, options: .TransitionFlipFromLeft , animations: { () -> Void in
                    self.window!.rootViewController = home
                    }, completion:nil)
 */

            default:
                break
            }
        }
    }
    
    func setUpISBNTextField()
    {
        isbnTextfield.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        isbnTextfield.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        isbnTextfield.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        //isbnTextfield.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    }
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        isbnTextfield.delegate = self
       //setUpISBNTextField()
        
        
        isbnTextfield.attributedPlaceholder = NSAttributedString(string:"Enter your 10 or 13 digit ISBN number",
        attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        //a tap dismisses a keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // add some swipe gesture recognizers
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SellBySearchingISBNViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SellBySearchingISBNViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - dismissKeyboard
    
    func dismissKeyboard(){
        view.endEditing(true)
    } 
    
    // MARK:- search (Checks the field entered by the user)
    
    @IBAction func search(sender: AnyObject) {
        //Activity Indicator
        activityView.color = UIColor.whiteColor()
        activityView.center = self.view.center
        
        activityView.startAnimating()
        
        self.view.addSubview(activityView)

        if let ISBN = isbnTextfield.text{
            if ISBN.characters.count > 9{
                
            
                lookUpData(ISBN)
            }
        }
        else{
            //show error
            //may be check for 10 digit or 13 digit also
        }
    }
    
    // MARK:- concatonateAuthors (appends multiple authors name as one with comma added.)
    
    func concatonateAuthors(list:NSMutableArray)->String{
        var authlist = ""
        for author in list{
            authlist = authlist + (author as! String) + ", "
        }
        let truncated = authlist.substringToIndex(authlist.endIndex.predecessor().predecessor())
        
        return truncated
    }
    
    
    
    // MARK:- LookUpData
    // Goes to googlebooks api  and looks for the book which is in JSON and fills the dictionary if the isbn matches.
    func lookUpData(ISBN:String)
    {
        let lookupURL = bookAPI + ISBN
        bookInfoDict = ["isbn" : ISBN, "bookTitle" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
   
        let requestURL: NSURL = NSURL(string: lookupURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    if let items = json["items"] as? [[String: AnyObject]] {
                        
                        for item in items {
                            
                            if (item["kind"] as? String) != nil {
                                if let volumeInfo = item["volumeInfo"]{
                                    if let title = volumeInfo["title"] as? String{
                                        //assignment
                                        print(title)
                                        self.bookInfoDict["bookTitle"] = (title)
                                    }
                                    if let bookDescription = volumeInfo["description"] as? String{
                                        //assignment
                                        print(bookDescription)
                                        self.bookInfoDict["description"] = (bookDescription)
                                    }
                                    if let authors = volumeInfo["authors"] as? NSArray{
                                        let authorArray:NSMutableArray = []
                                        for author in authors{
                                            authorArray.addObject(author)
                                            
                                        }
                                        
                                        //assignment
                                        print(authorArray)
                                        self.bookInfoDict["authors"] = self.concatonateAuthors(authorArray)
                                    }
                                    
                                    if let publishedDate = volumeInfo["publishedDate"] as? String{
                                        let date = (publishedDate)
                                        self.bookInfoDict["publishedDate"] = date.substringToIndex(date.startIndex.advancedBy(4))
                                    }
                                    if let picLinks = volumeInfo["imageLinks"]{
                                        if let imageURL = picLinks!["thumbnail"] as? String{
                                            self.bookInfoDict["imageURL"] = (imageURL)
                                            print (imageURL)
                                        }
                                    }
                                    if let pageCount = volumeInfo["pageCount"] as? String{
                                        self.bookInfoDict["pageCount"] = (pageCount)
                                        print(pageCount)
                                    }
                                    //self.dismissViewControllerAnimated(false, completion: nil)
                                    
                                    // required to use uitextview, this sends us to the main thread before setting the text view bounds. Probably.
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.performSegueWithIdentifier("ISBNToDetail", sender: self)
                                    })
                                                                      // possible additions are 1. catagories, 2. publication date
                                }
                              
                            }
                            
                        }
                        
                    }
                    else{
                        print("no info, say something")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.displayMyAlertMessage("Not Found", message: "Please Try Again.")
                        })
                    }
                   
                }catch {
                    print("Error with Json: \(error)")
                }
                
                
            }
        }
        
        
        task.resume()
        
    }
    
    
    // MARK:- Displays Alert Message
    
    func displayMyAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: tryScanAgain)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelScan)
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.presentViewController(myAlert, animated: true, completion: nil);
        activityView.stopAnimating()
    }
    
    func tryScanAgain(alert:UIAlertAction!)
    {
        print("ok")
        isbnTextfield.text = ""
    }
    
    func cancelScan(alert:UIAlertAction!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
     Converts a url to an UIImage
     */
    func fetchImage(){
        
        var tempString = self.bookInfoDict["imageURL"]!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let requestURL: NSURL = NSURL(string: tempString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
             
                let picture = UIImage(data:data!)
                self.bookImage = picture
                
   
            }
            
            
        }
        task.resume()
    }
    
    
    

    // MARK:- prepareForSegue (checks for segue identifier and does send data to next vc if necessary)
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "ISBNToDetail"{
            let vc = segue.destinationViewController as! PresentSearchResultsViewController
            vc.bookInfoDict = self.bookInfoDict
            
            print("going to detail view")
        }
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //isbnTextfield.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        return false
    }
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == isbnTextfield) {
            //isbnTextfield.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = false
            scrollView.setContentOffset(CGPointMake(0, 150), animated: true)
            
        }
    }


}
