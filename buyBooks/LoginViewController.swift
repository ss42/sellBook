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
        /*
 //the following changes the placeholder's text color
        emailField.attributedPlaceholder = NSAttributedString(string:"Enter email here.",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
 */
        passwordField.delegate = self
        
        //dismisses keyboard when you tap outside.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: emailField.frame.size.height - width, width:  emailField.frame.size.width, height: width)
        
        border.borderWidth = width
        emailField.layer.addSublayer(border)
        passwordField.layer.addSublayer(border)

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
                    //self.loginErrorAlert("Oops!", message: "Check your username and password.")
                } else {
                    
                    // Be sure the correct uid is stored.
                    print("successfully signing in")
                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: "isUserLoggedIn")
                    self.performSegueWithIdentifier("loginToHomeSegue", sender: nil)
                    let req = user?.profileChangeRequest()
                    req?.photoURL = NSURL(string: "google.com")
                }
                
            })
            
        } else {
            
            //TO DO: - Show error
 
           // Error.showError("test", "hello")
        }
  
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
