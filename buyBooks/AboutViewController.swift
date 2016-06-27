//
//  AboutViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/7/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate{

    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var detail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detail.text = "BOOK-RACK was made by Sanjay and Rahul. We made this app our friends of Saint Marys College of California to exchange book within themselves. To get in touch with us please send us an email or with your favorite social media timesink! Thank you for using BOOK-RACK!"
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func contactUs(sender: AnyObject) {
        
        
        let ourEmail = "smc.bookrack@gmail.com"
        if MFMailComposeViewController.canSendMail(){
            let subjectText = ""
            let bodyText = ""
            
            let toRecipients = [ourEmail]
            
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
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
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue{
        case MFMailComposeResultCancelled.rawValue:
            print("cancelled mail")
            alert("Ooops", msg: "Mail Cancelled")
        case MFMailComposeResultSent.rawValue:
            
            //alert("Yes!", msg: "Mail Sent!")
            print("mail was sent")
            
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

}
