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
    
    @IBOutlet weak var ISBN: UILabel!
    
    @IBOutlet weak var retailPrice: UILabel!
    
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
        
        /*
 
 2016-05-30 14:23:28.012 buyBooks[6305:2521457] *** Assertion failure in void _UIPerformResizeOfTextViewForTextContainer(NSLayoutManager *, UIView<NSTextContainerView> *, NSTextContainer *, NSUInteger)(), /BuildRoot/Library/Caches/com.apple.xbs/Sources/UIFoundation/UIFoundation-432.1/UIFoundation/TextSystem/NSLayoutManager_Private.m:1551
 2016-05-30 14:23:28.015 buyBooks[6305:2521457] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Only run on the main thread!'
*/

        // Do any additional setup after loading the view.
    }
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func fetchImage(){
        
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
                    self.bookImage.image = picture
                    
                    self.bookImage
                    
                                
                    print("after image assignment")
                                
                    
                    
                    //dispatch_async(dispatch_get_main_queue(), {
                        self.bookImage.setNeedsDisplay()
                    //})
                    
                    
              
                }catch {
                    print("Error with picture: \(error)")
                }
                
                
            
            
        
                
        
            }

    
        }
        task.resume()
    }
*/
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
       bookTitle.text = self.bookInfoDict["bookTitle"]! + "(" + bookInfoDict["publishedDate"]! + ")"
        
            self.bookDescription.text = self.bookInfoDict["description"]
        
        
        authors.text = bookInfoDict["authors"]
        ISBN.text = bookInfoDict["isbn"]
        retailPrice.text = "fix later"
        //
        pageCount.text = bookInfoDict["pageCount"]
        print("populated fields")
        
        print(bookTitle.text!)
        print(ISBN.text!)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.load_image()
        })
        //fetchImage()
        
        print("populated????")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
