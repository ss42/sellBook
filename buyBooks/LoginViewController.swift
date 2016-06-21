//
//  ViewController.swift
//  Carpooling
//
//  Created by Sanjay Shrestha on 3/31/16.
//  Copyright © 2016 St Marys. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailField.delegate = self
        
        //changes the placeholder's text color
        emailField.attributedPlaceholder = NSAttributedString(string:"Enter email here.",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
 
        passwordField.delegate = self
        
        //dismisses keyboard when you tap outside.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
           }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
// MARK: - Login (Authentication through Firebase) 
    
    // ## WARNING May be get all the user info at once and use it thru out the viewcontroller
    @IBAction func login(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        
        if email != "" && password != "" {
            
            // Login with the Firebase's authUser method
            
            FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: {
                user, error in
                
                if error != nil {
                    print("error signing in")
                    self.signInErrorAlert("Sign in Failed.", message: "Please check your email and password and enter again.")
                    //self.loginErrorAlert("Oops!", message: "Check your username and password.")
                } else {
                    
                    // Be sure the correct uid is stored.
                    print("successfully signing in")
                    if (user?.emailVerified == true)
                    {
                        NSUserDefaults.standardUserDefaults().setValue(true, forKey: "isUserLoggedIn")
                        self.performSegueWithIdentifier("loginToHomeSegue", sender: nil)

                    }
                    else
                    {
                        self.signInErrorAlert("Email verification required!", message: "Please check your @stmarys-ca.edu")
                    }
                    // TODO i dont know what the req thing is, why is it here?
                    
                    /*self.performSegueWithIdentifier("loginToHomeSegue", sender: nil)
                    let req = user?.profileChangeRequest()
                    req?.photoURL = NSURL(string: "google.com")
 */
                }
                
            })
            
        } else {
            
            self.signInErrorAlert("Empty Field", message: "Please enter your email and password to sign in.")
 
        }
  
    }
    

    /**
     Shows an alert pop up
     
     - parameter title: title of the error
     - parameter message: body of the message
  
     */
    func signInErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Dissmisses keyboard
    func dismissKeyboard(){
        view.endEditing(true)
    }
}


extension LoginViewController: UITextFieldDelegate{
 
    
    // MARK: - Testfieldshould clear (clears the textfield when tapped)
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    
    //may be we don't need this
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
     // MARK: - Textfieldshouldreturn (make the return button on the keyboard work)
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
    
    
}
