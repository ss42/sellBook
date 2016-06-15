//
//  EditProfileViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/7/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    
    var ref = FIRDatabase.database().reference()

    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var oldPassword: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var repeatNewPassword: UITextField!
    
    @IBOutlet weak var displayName: UILabel!
    
    @IBOutlet weak var popUpView: UIStackView!
    
    var email = ""
    var user:FIRUser?

    override func viewDidLoad() {
        super.viewDidLoad()
     
        //resetStack.layer.masksToBounds = true
        if(getUserInfo())
        {
            self.user = FIRAuth.auth()?.currentUser
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //make perfect round image
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
        oldPassword.attributedPlaceholder = NSAttributedString(string: "Enter Old Password" ,attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        newPassword.attributedPlaceholder = NSAttributedString(string:"Enter New Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
    
        repeatNewPassword.attributedPlaceholder = NSAttributedString(string:"Enter Password Again",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassword(sender: AnyObject) {
       // if let user = FIRAuth.auth()?.currentUser{
         //   FIRUser.updatePassword(user)}
        var okToChange:Bool = false
        if (oldPassword.text!.characters.count >= 6)
        {
            okToChange = true
            
            FIRAuth.auth()?.signInWithEmail(user!.email!, password: oldPassword.text!, completion: {
                localUser, error in
                print("before password check")
                if error != nil{
                    self.passwordChangeAlertEntryError("error", message: "Incorrect Password!")
                    okToChange = false
                    
                }
                else
                {
                    print("in else block, the password should have been correct")
                    if (localUser != nil)
                    {
                        if self.newPassword.text! == self.repeatNewPassword.text!
                        {
                            if self.newPassword.text!.characters.count >= 6
                            {
                                self.user?.updatePassword(self.newPassword.text!)
                                {
                                    error2 in
                                    
                                        if error2 != nil
                                        {
                                            print(error2)
                                            self.passwordChangeAlertEntryError("error", message: "There was some strange error, please try again (this should not be seen)!")
                                            okToChange = false
                                            //TODO make a popup that says some error
                                        }
                                        else
                                        {
                                            okToChange = true
                                        }
                                    
                                }
                            }
                            else
                            {
                                self.passwordChangeAlertEntryError("error", message: "New password is not long enough!")
                                okToChange = false
                                print("new password not long enough")
                            }
                        }
                        else
                        {
                            okToChange = false
                            self.passwordChangeAlertEntryError("error", message: "New passwords do not match!")
                            print("new password mismatch")
                        }
                    }
                    else
                    {
                        okToChange = false
                        self.passwordChangeAlertEntryError("error", message: "Not signed in!")
                        print("not signed in")
                    }
                }
                if okToChange == true{
                    self.passwordChangeAlertError("Password changed", message: "Your password has been successfully changed!")
                    NSUserDefaults.standardUserDefaults().setValue(false, forKey: "isUserLoggedIn")
                }
            })
        
        }
        else{
            self.passwordChangeAlertEntryError("error", message: "Please make sure that you have entered your password correctly")
        }
        // segue name = "passwordResetted"
        // TODO lets make a popup or segue out of here, right now we have to hit cancel to actually get out of here

        print("password changed")
        
    }
    func passwordResetAction(action:UIAlertAction){
        self.performSegueWithIdentifier("passwordResetted", sender: nil)

    }
    
    func passwordChangeAlertEntryError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        //let cancel = UIAlertAction
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func passwordChangeAlertError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: passwordResetAction)
        //let cancel = UIAlertAction
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    
    func getUserInfo()->Bool{
        if let user = FIRAuth.auth()?.currentUser {
            //change this later to full name
            print(user.email)
            print(user.photoURL)
            let username = user.email
            email = user.email!
            displayName.text = user.displayName
           // let uid = user.uid
            profileImage.setImageWithString(displayName.text, color: UIColor.init(hexString: User.generateColor(displayName.text!)))
            return true
        }
        else {
            return false
            // No user is signed in.
        }
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

extension EditProfileViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(textField: UITextField) {
        //add something may be?
        
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
