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
    
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        //changes the placeholder's text color
        
        firstName.attributedPlaceholder = NSAttributedString(string: "Enter your name" ,attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        emailField.attributedPlaceholder = NSAttributedString(string: "Enter SMC email Address" ,attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string:"Enter Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        passwordField2.attributedPlaceholder = NSAttributedString(string:"Enter Password again",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])

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
        let isValid: Bool = (email?.hasSuffix("@stmarys-ca.edu"))!
        
        if (email != "" && password != "" && password2 != "" && userName != "") && (password == password2) && isValid{
            
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
                    
                        let changeRequest = authData!.profileChangeRequest()

                    
                        let capitalizedUsername = userName?.localizedCapitalizedString
                    
                    if (capitalizedUsername != nil){
                        
                    
                        changeRequest.displayName = capitalizedUsername!
                    }else{
                        changeRequest.displayName = email
                        // this shouldnt happen if fields are validated
                    }
                    

                    
                        changeRequest.commitChangesWithCompletion { error in
                            if error != nil {
                                // An error happened.
                            } else {
                                // Profile updated.
                            }
                        }
                    
                    authData?.sendEmailVerificationWithCompletion(nil)

                    
                   
                    self.alertSuccessShow("check your email", message: "Please check your @stmarys-ca.edu email and verify your account!")
                   
                }
            })
            
            
        }
        else if (isValid == false)
        {
           signupErrorAlert("Oops!", message: "Please enter a valid @stmarys-ca.edu email!")
        }
        else
        {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and your first name!")
        }
        
    }
    
    
    func alertSuccessShow(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let home = UIAlertAction(title: "Back Home", style: .Default, handler: performCustomSegue)
        let logInPage = UIAlertAction(title: "Sign in", style: .Default, handler: goToLogin)
        alert.addAction(home)
        alert.addAction(logInPage)
        dispatch_async(dispatch_get_main_queue(), {
            
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func goToLogin(action:UIAlertAction){
        dispatch_async(dispatch_get_main_queue(),{
                self.performSegueWithIdentifier("toLogin", sender: nil)
            })
    }
    
    func performCustomSegue(action:UIAlertAction){
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            let vc: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView")
            
            
            self.presentViewController(vc, animated: true, completion: nil)

        })
        
    }
    
    
   
    
  
     // MARK: - signupErrorAlert 
    
    func signupErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func viewPrivacyPolicy(sender: AnyObject) {
        
        let vc: UIViewController = storyboard!.instantiateViewControllerWithIdentifier("PrivacyPolicy")
        
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        
        let vc: UIViewController = storyboard!.instantiateViewControllerWithIdentifier("LoginView")
        
        self.presentViewController(vc, animated: true, completion: nil)
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
 /*
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    // Lifting the view up
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }*/
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == passwordField) || (textField == passwordField2){
            scrollView.setContentOffset(CGPointMake(0, 150), animated: true)
            
        }
    }
    
    
}
