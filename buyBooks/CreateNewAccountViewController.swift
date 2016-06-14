//
//  CreateNewAccountViewController.swift
//  Carpooling
//
//  Created by Sanjay Shrestha on 4/15/16.
//  Copyright © 2016 St Marys. All rights reserved.
//


import UIKit
import Firebase

class CreateNewAccountViewController: UIViewController {
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //confirming to the textfield delegate
        emailField.delegate = self
        passwordField.delegate = self
        passwordField2.delegate = self
        firstName.delegate = self

        //a tap dissmisses the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        /*
        //sets the background as image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        //sets the background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
        view.addSubview(stackView)
        view.addSubview(cancelButton)*/

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Create account with Firebase
    
    @IBAction func createAccount(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        let password2 = passwordField2.text
        let userName = firstName.text
        
        if (email != "" && password != "" && password2 != "" && userName != "") && (password == password2){
            
            // Set Email and Password for the New User.
            
            FIRAuth.auth()!.createUserWithEmail(email!, password: password!, completion: {
                (authData, error) -> Void in
                
                if error != nil
                {
                    
                    // There was a problem.
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    
                }
                else
                {
                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: "isUserLoggedIn")
                        let changeRequest = authData!.profileChangeRequest()
                    
                        changeRequest.displayName = userName
                    
                    
                        changeRequest.commitChangesWithCompletion { error in
                            if error != nil {
                                // An error happened.
                            } else {
                                // Profile updated.
                            }
                    }
                    
                    
                    
                    
                    self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
                }
            })
            
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and your first name!")
        }
        
    }
    
    @IBAction func cancelCreateAccount(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
  
     // MARK: - signupErrorAlert 
    
    func signupErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
     // MARK: - dismissKeyboard
    func dismissKeyboard(){
        view.endEditing(true)
    }
}


 // MARK: - UITextFieldDelegate (used to make the keyboard return)
extension CreateNewAccountViewController: UITextFieldDelegate{
 
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
}
