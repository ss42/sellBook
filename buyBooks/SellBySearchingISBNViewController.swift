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
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var isbnTextfield: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.view.backgroundColor = UIColor(red: 66/255, green: 75/255, blue: 77/255, alpha: 1)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        //view.sendSubviewToBack(blurEffectView)
        view.addSubview(blurEffectView)
        view.addSubview(popupView)
        view.addSubview(titleLabel)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    } 
    
    
    @IBAction func search(sender: AnyObject) {
        
        if let ISBN = isbnTextfield.text{
            lookUpData(ISBN)
        }
        else{
            //show error
            //may be check for 10 digit or 13 digit also
        }
    }
    
    
    func concatonateAuthors(list:NSMutableArray)->String{
        var authlist = ""
        for author in list{
            //authlist.appendContentsOf((author as? String)!)
            authlist = authlist + (author as! String) + ", "
        }
        let truncated = authlist.substringToIndex(authlist.endIndex.predecessor().predecessor())
        
        return truncated
    }
    
    func lookUpData(ISBN:String)
    {
        let lookupURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + ISBN
        print(lookupURL)
        bookInfoDict = ["isbn" : ISBN, "bookTitle" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
        
        
        let requestURL: NSURL = NSURL(string: lookupURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
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
                                    
                                    //self.performSegueWithIdentifier("cameraToDetail", sender: nil)
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
    func displayMyAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: tryScanAgain)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelScan)
        
        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.presentViewController(myAlert, animated: true, completion: nil);
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
                do{
                    
                    let picture = UIImage(data:data!)
                    self.bookImage = picture
                  
                    
                }catch {
                    print("Error with picture: \(error)")
                }
   
            }
            
            
        }
        task.resume()
    }
    
    
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "ISBNToDetail"{
            let vc = segue.destinationViewController as! PresentSearchResultsViewController
            vc.bookInfoDict = self.bookInfoDict
            //vc.bookImage.image = self.bookImage!
            //self.presentViewController(vc, animated: true, completion: nil)
            print("going to detail view")
        }
    }
    


}
