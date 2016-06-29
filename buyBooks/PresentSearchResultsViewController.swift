//
//  PresentSearchResultsViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/27/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class PresentSearchResultsViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var ISBN: UILabel!
    
    
    @IBOutlet weak var bookDescription: UITextView!
    
    @IBOutlet weak var pageCount: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    var bookInfoDict = [String:String]()
    //var bookPicture:UIImage?
    
    
    override func viewDidLoad() {
        print("before view did load super")
        super.viewDidLoad()
        //view.addSubview(popupView)
        print("at detail view")
        populateFields()
        
        bookDescription.textColor = UIColor.darkGrayColor()
      
    }
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        self.bookDescription.setContentOffset(CGPointZero, animated: false)
    }
    
    
    /**
     Loads image from url asynchronously
     */
    
    func load_image()
    {
        var tempString = self.bookInfoDict["imageURL"]!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let urlString = tempString
        let session = NSURLSession.sharedSession()
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let task = session.dataTaskWithRequest(request){(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {

                self.bookImage.image = UIImage(data: data!)
                })
            }
        }
        task.resume()
        
    }
    /*
    func load_image1()
    {
        var tempString = self.bookInfoDict["imageURL"]!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let urlString = tempString
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.bookImage.image = UIImage(data: data!)
                }
        })
        
    }*/
    
    
    func populateFields(){
        
       bookTitle.text = self.bookInfoDict["bookTitle"]!
        
        self.bookDescription.text = self.bookInfoDict["description"]
        year.text = "Year: " + bookInfoDict["publishedDate"]!
        
        authors.text = "By: " + bookInfoDict["authors"]!
        ISBN.text = "ISBN: " + bookInfoDict["isbn"]!
        //retailPrice.text = "fix later"
    
        pageCount.text = "Page Count: " + bookInfoDict["pageCount"]!
        //TODO do we need to do this?
        dispatch_async(dispatch_get_main_queue(), {
            self.load_image()
        })
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "continueToSetPrice"{
            let vc = segue.destinationViewController as! SetPriceAndConditionFromSearchViewController
            
            vc.bookInfoDict = self.bookInfoDict
            vc.image = self.bookImage.image
            //vc.bookImage.image = self.bookImage!
            //self.presentViewController(vc, animated: true, completion: nil)
            print("going to detail view")
        }
    }

    
    @IBAction func continuePressed(sender: AnyObject) {
        
        
    }

    @IBAction func cancelPressed(sender: AnyObject) {
    }


}
