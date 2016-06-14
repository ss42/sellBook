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
    
    
    @IBOutlet weak var popUpView: UIStackView!
    
    var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //blur background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        //view.sendSubviewToBack(blurEffectView)
        view.addSubview(blurEffectView)
        view.addSubview(popUpView)
        */
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
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
           // let uid = user.uid
            profileImage.setImageWithString(username, color: UIColor.init(hexString: User.generateColor(username!)))
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
