//
//  SetPriceAndConditionFromSearchViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/30/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class SetPriceAndConditionFromSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookAuthors: UILabel!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var bookConditionSlider: UISlider!
    
    @IBOutlet weak var bookCondition: UILabel!
    
    var bookInfoDict = [String:String]()
    var image:UIImage?
    

    @IBAction func continuePressed(sender: AnyObject) {
        
        
        let checkPrice = price.text
        if checkPrice?.characters.count > 3 {
            price.text = ""
            
        }
        //checking if the textfield is empty and also checking for non-numeric
        if price.text != "" && Double(checkPrice!) != nil{
            self.bookInfoDict["bookCondition"] = bookCondition.text
            self.bookInfoDict["price"] = price.text
        }
        else {
            showError("Check the price.", message: "Please enter the price you want to sell for")
        }
        
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    
    func populateData(){
        bookImage.image = image
        bookTitle.text = self.bookInfoDict["bookTitle"]
        bookAuthors.text = ("  By, " + self.bookInfoDict["authors"]!)
        
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
                self.bookImage.image = UIImage(data: data!)
            }
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if image == nil{
            load_image()
        }
        price.delegate = self
        
        bookConditionSlider.minimumValue = 0.0
        bookConditionSlider.maximumValue = 100.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
      
        populateData()
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "finalConfirmation"{
            let vc = segue.destinationViewController as! FinalConfirmationBeforePostViewController
            
            vc.bookInfoDict = self.bookInfoDict
            vc.image = self.bookImage.image
        }
    }
    

}
