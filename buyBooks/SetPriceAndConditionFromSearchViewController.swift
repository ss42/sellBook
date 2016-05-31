//
//  SetPriceAndConditionFromSearchViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/30/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class SetPriceAndConditionFromSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookAuthors: UILabel!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var bookConditionSlider: UISlider!
    
    @IBOutlet weak var bookCondition: UILabel!
    
    var bookInfoDict = [String:String]()
    var image:UIImage?
    
    //bookInfoDict = ["isbn" : ISBN, "bookTitle" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
    @IBAction func continuePressed(sender: AnyObject) {
        self.bookInfoDict["bookCondition"] = bookCondition.text
        self.bookInfoDict["price"] = price.text
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if segue.identifier == "finalConfirmation"{
            let vc = segue.destinationViewController as! FinalConfirmationBeforePostViewController
            
            vc.bookInfoDict = self.bookInfoDict
            vc.image = self.bookImage.image
            //vc.bookImage.image = self.bookImage!
            //self.presentViewController(vc, animated: true, completion: nil)
            print("going to detail view")
        }
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    
    
    func populateData(){
        bookImage.image = image
        bookTitle.text = self.bookInfoDict["bookTitle"]
        bookAuthors.text = ("By, " + self.bookInfoDict["authors"]!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        price.delegate = self
        
        bookConditionSlider.minimumValue = 0.0
        bookConditionSlider.maximumValue = 100.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        /*let customView = UIView(frame: CGRectMake(0, 0, 5, 50))
        
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(5, 0, 50, 10)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Done", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.doneButton(_:)), forControlEvents: .TouchUpInside)
            //Selector("Action:"), forControlEvents: UIControlEvents.TouchUpInside)
        customView.addSubview(button)
        //cgrectmake
        //customView.backgroundColor = UIColor.redColor()
        price.inputAccessoryView = customView
        */
        populateData()
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    /*func doneButton(sender: UIButton){
        print("pressed done button")
        self.resignFirstResponder()
        self.price.
        
    
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
