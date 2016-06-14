//
//  SellBySearchingISBNViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/30/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class SellBySearchingISBNViewController: UIViewController {
    
    var bookInfoDict = [String:String]()
    var bookImage:UIImage?
    
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isbnTextfield: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            lookUpData(ISBN)
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
                                    if let title = volumeInfo["title"]{
                                        //assignment
                                        print(title)
                                        self.bookInfoDict["bookTitle"] = (title as! String)
                                    }
                                    if let bookDescription = volumeInfo["description"]{
                                        //assignment
                                        print(bookDescription)
                                        self.bookInfoDict["description"] = (bookDescription as! String)
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
                                    
                                    if let publishedDate = volumeInfo["publishedDate"]{
                                        let date = (publishedDate as! String)
                                        self.bookInfoDict["publishedDate"] = date.substringToIndex(date.startIndex.advancedBy(4))
                                    }
                                    if let picLinks = volumeInfo["imageLinks"]{
                                        if let imageURL = picLinks!["thumbnail"]{
                                            self.bookInfoDict["imageURL"] = (imageURL as! String)
                                            print (imageURL)
                                        }
                                    }
                                    if let pageCount = volumeInfo["pageCount"]{
                                        self.bookInfoDict["pageCount"] = String(pageCount!)
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
                    //task.suspend()
                    //self.performSegueWithIdentifier("cameraToDetail", sender: nil)
                    // there should be a segue here, that sends the dictionary.
                    
                    // maybe to some kind of conformation page
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
    
    
    // MARK:- fetchImage (takes the url and converts to a UIImage)
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
    


}
