//
//  ViewDetailOfBooksOnSaleViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/31/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class ViewDetailOfBooksOnSaleViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var ISBN: UILabel!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var retailPrice: UILabel!
    
    @IBOutlet weak var bookDescription: UITextView!
    
    @IBOutlet weak var pageCount: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    
    @IBOutlet weak var bookCondition: UILabel!
    
    @IBOutlet weak var ourPrice: UILabel!
    @IBOutlet weak var yearPublished: UILabel!
    
    var detailBook:Book?
    var bookPicture:UIImage?
    
    var ref = FIRDatabase.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.subject.delegate = self
        populateFields()
        
        //sets the background as image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        //sets the background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
        view.addSubview(popUpView)
        

    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.hidesBarsOnSwipe = false
        
    }
    
    func getSellerEmail()->String{
        return (detailBook?.sellerInfo?.email)!
    }
    func getBuyerEmail()->String{
        return getCurrentBuyerName() // temporary, be sure to switch the other one and then change this!
    }
    
    func getCurrentBuyerName()->String{
        if let user = FIRAuth.auth()?.currentUser {
            //change this later to full name
            /*print(user.email)
            print(user.photoURL)
            let name = user.email
            let email = user.email
            let uid = user.uid
            let profileImage = "male"*/
            //let uid = user.uid
            let temp = user.email! // switch to user.displayName
            return temp
            //temp.substringToIndex(temp.endIndex.predecessor().predecessor().predecessor().predecessor().predecessor())
        }
        return ""
    }
    func generateSubjectForEmail()->String{
        var subjectString = ""
        let name = getCurrentBuyerName()
        subjectString = name + " would like to buy your book "
        let book = bookTitle.text
        subjectString = subjectString + book!
        print(subjectString)
        return subjectString
    }
    func generateMessageForEmail()->String{
        var messageString = ""
        messageString = "Dear " + (detailBook?.sellerInfo?.fullName)! + ", \n\n"
        messageString = messageString + getCurrentBuyerName() + " would like to purchase your book: " + (detailBook?.title)!
            
        messageString = messageString + " at your listed price of $" + String((detailBook?.price)!)
        messageString = messageString + ".\n\n" + "Please send them a reply with how you would like to meet them or otherwise conclude your transaction. \n\n\n Sincerely, \n The BookSelling App Team" // change our signiture
        print(messageString)
        return messageString
    }
    
    
    
    
    
    @IBAction func sendMail(sender:UIButton){
        
        
        let sellerEmail = getSellerEmail()
        if MFMailComposeViewController.canSendMail(){
            let subjectText = generateSubjectForEmail()
            let bodyText = generateMessageForEmail()
            
            let toRecipients = [sellerEmail]
            
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            // TODO: set this to be our email
            //mc.setCcRecipients(<#T##ccRecipients: [String]?##[String]?#>)
            mc.setSubject(subjectText)
            mc.setMessageBody(bodyText, isHTML: false)
            mc.setToRecipients(toRecipients)
            print("Sending mail")
            
            self.presentViewController(mc, animated: true, completion: nil)
        }
        else{
            print("No email service")
        }
 
    }
    
    func timeElapsed(date: String)-> Double{
        
        let dateformatter = NSDateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postedDate  = dateformatter.dateFromString(date)!
        
        let elapsedTimeInSeconds = NSDate().timeIntervalSinceDate(postedDate)
        return elapsedTimeInSeconds
    }
    
    func getCurrentTime()-> String{
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentTimeAndDate:String = dateFormatter.stringFromDate(todaysDate)
        return currentTimeAndDate
    }
    
    
    func updateMailTimeForBook()
    {
        //let time = timeElapsed((detailBook?.postedTime)!)
        //if time > (60 * 60 * 24 * 3)
        if detailBook?.timeOfMail == " "{
            // update time of mail
            let postIdKey = detailBook?.postId
            let updatePost = ref.child("SellBooksPost").child(postIdKey!)
            let tempDict = ["timeOfMail":getCurrentTime(), "bookStatus":"emailSent"]
            updatePost.updateChildValues(tempDict)
            print("updated post (timeOfMail)")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue{
        case MFMailComposeResultCancelled.rawValue:
        print("cancelled mail")
        alert("Ooops", msg: "Mail Cancelled")
        case MFMailComposeResultSent.rawValue:
            
            //alert("Yes!", msg: "Mail Sent!")
            print("mail was sent")
            updateMailTimeForBook()
            
        case MFMailComposeResultSaved.rawValue:
            
            alert("Yes!", msg: "Mail Saved!")
        case MFMailComposeResultFailed.rawValue:
            
            alert("Ooops", msg: "Mail Failed!")
            
        default:
            print("default case")
            break
            
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //
    }
    /**
     alert to be displayed as a popup
     
     - parameter title: title of alert box
     - parameter msg: Message string to be displayed
    
     */
    func alert(title: String, msg: String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: title, style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    /**
     populates the text fields in the view
     */
    func populateFields()
    {
        bookTitle.text = detailBook?.title
        authors.text = "By: " + (detailBook?.webAuthors)!
        ISBN.text = "ISBN: " + (detailBook?.webISBN)!
        //retailPrice.text = detailBook?.webPrice
        bookDescription.text = "Description: " + (detailBook?.webDescription)!
        pageCount.text = "Page Count: " + (detailBook?.webPageCount)!
        bookImage.image = bookPicture
        bookCondition.text = "Book Condition: " + (detailBook?.condition)!
        
        print(String(detailBook!.price!))
       
 
        ourPrice.text = "$ " + String(detailBook!.price!)
        
        
        yearPublished.text = detailBook?.publishedYear
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
