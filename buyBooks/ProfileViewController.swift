//
//  ProfileViewController.swift
//  Carpooling
//
//  Created by Sanjay Shrestha on 4/11/16.
//  Copyright © 2016 St Marys. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editProfilePictureButton: UIButton!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var imageString = ""
    var currentUser = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageData = NSUserDefaults.standardUserDefaults().objectForKey("image") as? NSData{
            let storedImage = UIImage.init(data: imageData)
            profileImage.image = storedImage
        }
        
        
        confirmDelegate()
        
        DataService.dataService.userRef.observeAuthEventWithBlock({
            authData in
            print("hello world")
            if authData != nil{
                self.currentUser = authData.uid
                print("The UID for current user is \(self.currentUser)")
                self.updateInfoFromDatabase()
            }
            else
            {
               print("authdata is nil")
            }
        })
        
        
        //if (NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String == DataService.dataService.userRef
    }
    
    func confirmDelegate(){
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.phoneNumber.delegate = self
        self.emailAddress.delegate = self
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        performCustomSegue()
    }
    
    
    @IBAction func SaveTapped(sender: AnyObject) {
        let first = firstName.text
        let last = lastName.text
        let phone = phoneNumber.text
        let email = emailAddress.text
        //let image = self.convertToBase64String(profileImage.image!)
        let user: NSDictionary = ["first": first!, "last": last!, "phone": phone!, "email" : email!]//, "image": image]
        DataService.dataService.userRef.childByAppendingPath(currentUser).updateChildValues(user as! Dictionary<String, AnyObject>)
        
        
        performCustomSegue()
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        /*
         let picker = UIImagePickerController()
         picker.delegate = self
         picker.sourceType = .PhotoLibrary
         picker.allowsEditing = true*/
        self.actionSheet()
    }
    
    func performCustomSegue(){
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("home")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == emailAddress) || (textField == phoneNumber){
            ScrollView.setContentOffset(CGPointMake(0, 250), animated: true)
            
        }
    }
    
    func updateInfoFromDatabase(){
        let newRef = DataService.dataService.userRef.childByAppendingPath(currentUser)
        //let newRef = Firebase(url: "http://smcpool.firebaseio.com/users/\(currentUser)")
        newRef.queryOrderedByKey().observeEventType(.Value, withBlock: {
            snapshot in
            
            print("Inside update from database func")
            let first = snapshot.value["first"] as? String
            let last = snapshot.value["last"] as? String
            let phone = snapshot.value["phone"] as? String
            let email = snapshot.value["email"] as? String
           // let imageString = snapshot.value["image"] as? String
            
            //let user : NSDictionary = []
            
            //let firstname = snapshot.value["first"] as! String
            //print("The first name is \(firstname)")
            
            if  first != "" {
                print("The first name of this guy is \(first)")
                self.firstName.text = snapshot.value["first"] as? String
            }
            else {
                self.firstName.placeholder = "Enter your first name."
            }
             if  last != "" {
                print("The last name of this guy is \(last)")
             self.lastName.text = snapshot.value["last"] as? String
             }
             else {
             self.lastName.placeholder = "Enter your last name."
             }
             if  phone != "" {
                print("The phone number of this guy is \(phone)")
             self.phoneNumber.text = snapshot.value["phone"] as? String
             }
             else {
             self.phoneNumber.placeholder = "Enter your phone number."
             }
             if  email != "" {
                print("The email of this guy is \(email)")
             self.emailAddress.text = snapshot.value["email"] as? String
             }
             else {
             self.emailAddress.placeholder = "Enter your email address"
             }
            /* if  imageString != nil {
                print("image not empty")
                print(imageString)
             let image = self.convertBase64StringToUImage(imageString!)
             self.profileImage.image = image
             }
             else {
                print("No photo")
             //self.profileImage.image = UIImage(named: "male")
             }
*/        })
    }
    
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        //self.convertToBase64String(profileImage.image!)
        
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        //self.savedImageAlert()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK:- UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imageToSave: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!{
            profileImage.image = imageToSave
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func convertToBase64String(image: UIImage)-> String
    {
        var data: NSData = NSData()
        
        if let image = profileImage.image {
            data = UIImageJPEGRepresentation(image, 1)!
        }
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        return base64String
    }
    
    func convertBase64StringToUImage(baseString: String)-> UIImage {
        let decodedData = NSData(base64EncodedString: baseString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedimage = UIImage(data: decodedData!)
        //println(decodedimage)
        return decodedimage! as UIImage
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func actionSheet(){
        let alertController: UIAlertController = UIAlertController(title: "Master your selfie skill.", message: "Choose a photo where other people can recognize you easily. ", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takePhoto = UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.Default){(action)-> Void in
            self.takePhoto()
        }
        let chooosePhoto = UIAlertAction(title: "Choose a photo", style: UIAlertActionStyle.Default){(action)-> Void in
            self.choosePhoto()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){(action)-> Void in
            
        }
        alertController.addAction(takePhoto)
        alertController.addAction(chooosePhoto)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func takePhoto(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        self.presentViewController(cameraPicker, animated: true, completion: nil)
        
    }
    
    func choosePhoto(){
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
        
    }
    
}