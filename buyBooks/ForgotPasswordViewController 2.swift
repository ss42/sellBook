//
//  ForgotPasswordViewController.swift
//  Carpooling
//
//  Created by Sanjay Shrestha on 4/19/16.
//  Copyright © 2016 St Marys. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    

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
      /**  DataService.dataService.userRef.resetPasswordForUser(email, withCompletionBlock: { error in
            if error != nil {
                self.alertShow("Ops", message: "Email do not match.")
            } else {
                self.alertShow("Sucess", message: "Temporary Password sent to your email")
                self.performCustomSegue()

            }
        })
 **/
        
    }
    
    func performCustomSegue(){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("Login")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func alertShow(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}
