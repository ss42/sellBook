//
//  ForgotPasswordViewController.swift
//  Carpooling
//
//  Created by Sanjay Shrestha on 4/19/16.
//  Copyright © 2016 St Marys. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    
    var ref = FIRDatabase.database().reference()
    
    

    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func sendPressed(sender: AnyObject) {
        let email = emailTextField.text
        
       FIRAuth.auth()?.sendPasswordResetWithEmail(email!) { error in
            if error != nil {
                self.alertShow("Ops", message: "Email do not match.")
            } else {
                
                
                //TODO can't do this..
                self.alertSuccessShow("Sucess", message: "Temporary Password sent to your email")

            }
        }
 
        
    }
   
    
    
    /**
     segue through storyboard ID
     
     - parameter action: Happens inside alert controller
     */
    
    func performCustomSegue(action:UIAlertAction){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("LoginView")
        
        //TODO check this again.
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(vc, animated: true, completion: nil)
        })
        
    }
    
    func alertShow(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    func alertSuccessShow(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: performCustomSegue)
        alert.addAction(action)
        dispatch_async(dispatch_get_main_queue(), {

            self.presentViewController(alert, animated: true, completion: nil)
        })
    }

}
