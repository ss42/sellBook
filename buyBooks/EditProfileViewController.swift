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

    override func viewDidLoad() {
        super.viewDidLoad()
     
        //resetStack.layer.masksToBounds = true
        getUserInfo()
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
    }
    
    func getUserInfo(){
        if let user = FIRAuth.auth()?.currentUser {
            //change this later to full name
            print(user.email)
            print(user.photoURL)
            let username = user.email
            email = user.email!
            displayName.text = user.displayName
           // let uid = user.uid
            profileImage.setImageWithString(displayName.text, color: UIColor.init(hexString: User.generateColor(displayName.text!)))
        }
        else {
            
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
