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
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        
        passwordField.delegate = self

    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /**
        // If we have the uid stored, the user is already logger in - no need to sign in again!
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
            DataService.dataService.CURRENT_USER_REF.queryOrderedByKey().observeEventType(.Value, withBlock: {
                snapshot in
                
                /*
                 let imageString = nil//snapshot.value["image"] as? String
                
                if  imageString != nil {
                    print("image not empty")
                    print(imageString)
                    let image = self.convertBase64StringToUImage(imageString!)
                  //  self.tempImage! = image
                    //self.saveImageToNSUserDefault(self.tempImage!)
                    
                    
                    let imageData = UIImageJPEGRepresentation(image, 0.75)
                    //saveData.setObject(imageData, forKey: "image")
                    NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "image")
                }
                else {
                    print("No photo")
                    //self.profileImage.image = UIImage(named: "male")
                }
 */
            })
            
            //go to next screen cuz the user is sign in
           // self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
        }**/
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func convertBase64StringToUImage(baseString: String)-> UIImage {
        let decodedData = NSData(base64EncodedString: baseString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedimage = UIImage(data: decodedData!)
        //println(decodedimage)
        return decodedimage! as UIImage
    }
    
  /*
    func saveImageToNSUserDefault(image: UIImage){
        let saveData = NSUserDefaults.standardUserDefaults()
        let imageData = UIImageJPEGRepresentation(image, 0.75)
        saveData.setObject(imageData, forKey: profileImage)
    }
    
        
    }
    //To get info back from NSUSEr
    
    if let imageData = saveData.objectForKey(profileImage) as? NSData{
        let storedImage = UIImage.init(data: imageData)
     profileImage.image = storedImage
     */
    
    // Implement the required GIDSignInDelegate methods
  
    
    
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
           // Error.showError("test", "hello")
    }
    
   
    
    
  
    }
}


extension LoginViewController: UITextFieldDelegate{
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
