//
//  barcodeScanner.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/26/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var bookInfoDict = [String:String]()
    var bookImage:UIImage?
    var bookAPI = "https://www.googleapis.com/books/v1/volumes?q=isbn:"

    
    @IBOutlet weak var backButtonView: UIView!
    
    @IBOutlet weak var bracketView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        // this is the back button, it sits on top of the camera stuff
        view.addSubview(backButtonView);
        
        //TODO-NEXT version custom draw recct for this
    //view.addSubview(bracketView)

        
        captureSession.startRunning();
    }
    
    override func viewDidAppear(animated: Bool)
    {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        
        if(!isUserLoggedIn)
        {
            //make the user sign in first
            print("here")
            let ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            self.presentViewController(ViewController, animated: true, completion: nil)
        }
        
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        // changed from true to false
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        
        print(code)
        lookUpData(code)
        
        // add a little processing wheel or something
        //activity indicator view starts here
        
        //dismissViewControllerAnimated(false, completion: nil)
        
        
    }
    
    func concatonateAuthors(list:NSMutableArray)->String{
        var authlist = ""
        for author in list{
            //authlist.appendContentsOf((author as? String)!)
            authlist = authlist + (author as! String) + ", "
        }
        let truncated = authlist.substringToIndex(authlist.endIndex.predecessor().predecessor())
        
        print(truncated)
        return truncated
    }
    
    func lookUpData(ISBN:String)
    {
        let lookupURL = bookAPI + ISBN
        print(lookupURL)
        bookInfoDict = ["isbn" : ISBN, "bookTitle" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
    
            
            let requestURL: NSURL = NSURL(string: lookupURL)!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) -> Void in
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    print("Everyone is fine, file downloaded successfully.")
                    do{
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        
                        if let items = json["items"] as? [[String: AnyObject]] {
                            
                            for item in items {
                                
                                if (item["kind"] as? String) != nil {
                                    
                                    
                                    if let volumeInfo = item["volumeInfo"]{
                                        if let title = volumeInfo["title"]{
                                            //assignment
                                            print(title)
                                            self.bookInfoDict["bookTitle"] = (title as! String)
                                        }
                                        if let bookDescription = volumeInfo["description"]{
                                            //assignment
                                            
                                            if bookDescription != nil{
                                                print(bookDescription)
                                                self.bookInfoDict["description"] = (bookDescription as! String)
                                            }
                                            else{
                                                self.bookInfoDict["description"] = "Unable to load description from google or this book has no description"
                                            }
                                            
                                        }
                                        if let authors = volumeInfo["authors"] as? NSArray{
                                            let authorArray:NSMutableArray = []
                                            for author in authors{
                                                authorArray.addObject(author)
                                                
                                            }
                                            
                                            //assignment
                                            print(authorArray)
                                            self.bookInfoDict["authors"] = self.concatonateAuthors(authorArray)
                                        }
                                        if let publishedDate = volumeInfo["publishedDate"]{
                                            let date = (publishedDate as! String)
                                            self.bookInfoDict["publishedDate"] = date.substringToIndex(date.startIndex.advancedBy(4))
                                        }
                                        if let picLinks = volumeInfo["imageLinks"]{
                                            if let imageURL = picLinks!["thumbnail"]{
                                                self.bookInfoDict["imageURL"] = (imageURL as! String)
                                                print (imageURL)
                                            }
                                        }
                                        if let pageCount = volumeInfo["pageCount"]{
                                            self.bookInfoDict["pageCount"] = String(pageCount!)
                                            print(pageCount)
                                        }
                                        //self.dismissViewControllerAnimated(false, completion: nil)
                                        
                                        // required to use uitextview, this sends us to the main thread before setting the text view bounds. Probably.
                                                                                
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.performSegueWithIdentifier("cameraToDetail", sender: self)
                                        })
                                        
                                        //self.performSegueWithIdentifier("cameraToDetail", sender: nil)
                                        // possible additions are 1. catagories, 2. publication date
                                    }
                                    
                                 
                                    
                                }
                                
                            }
                            
                        }
                        else{
                            print("no info, say something")
                            dispatch_async(dispatch_get_main_queue(), {
                                
                            self.displayMyAlertMessage("Scan Error", message: "No results found from barcode scan, please enter info manually")
                                })
                            // maybe do a popup/alert and a confirm button
                        }
                        //task.suspend()
                        //self.performSegueWithIdentifier("cameraToDetail", sender: nil)
                    // there should be a segue here, that sends the dictionary.
                        
                        // maybe to some kind of conformation page
                    }catch {
                        print("Error with Json: \(error)")
                    }
                    
                
                }
            }
        
        
        task.resume()
            
    }
    
    func displayMyAlertMessage(title: String, message: String) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: tryScanAgain)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelScan)

        myAlert.addAction(okAction)
        myAlert.addAction(cancelAction)
        self.presentViewController(myAlert, animated: true, completion: nil);
    }
    
    func tryScanAgain(alert:UIAlertAction!)
    {
        print("ok")
        captureSession.startRunning()
    }
    func cancelScan(alert:UIAlertAction!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchImage(){
        
        var tempString = self.bookInfoDict["imageURL"]!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let requestURL: NSURL = NSURL(string: tempString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                    let picture = UIImage(data:data!)
                    self.bookImage = picture

            }
            
            
        }
        task.resume()
    }


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        captureSession.stopRunning()
        if segue.identifier == "cameraToDetail"{
            let vc = segue.destinationViewController as! PresentSearchResultsViewController
            vc.bookInfoDict = self.bookInfoDict
            //vc.bookImage.image = self.bookImage!
            //self.presentViewController(vc, animated: true, completion: nil)
            print("going to detail view")
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}