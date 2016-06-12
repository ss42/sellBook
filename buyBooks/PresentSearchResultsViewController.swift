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
      /*
        //sets the background as image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        //sets the background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
        view.addSubview(popupView)*/

    }
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        func load_image()
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
        
    }
    func populateFields(){
        
        // bookInfoDict = ["isbn" : ISBN, "title" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
       bookTitle.text = self.bookInfoDict["bookTitle"]!
        
            self.bookDescription.text = self.bookInfoDict["description"]
        year.text = "Year: " + bookInfoDict["publishedDate"]!
        
        authors.text = "By: " + bookInfoDict["authors"]!
        ISBN.text = "ISBN: " + bookInfoDict["isbn"]!
        //retailPrice.text = "fix later"
        //
        pageCount.text = "Page Count: " + bookInfoDict["pageCount"]!
        print("populated fields")
        
        print(bookTitle.text!)
        print(ISBN.text!)
        
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
