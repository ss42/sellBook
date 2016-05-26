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
        
        captureSession.startRunning();
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
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        print(code)
        lookUpData(code)
        
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
        let lookupURL = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + ISBN
        print(lookupURL)
        bookInfoDict = ["isbn" : ISBN, "title" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
    
            
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
                                            self.bookInfoDict["title"] = title as? String
                                        }
                                        if let bookDescription = volumeInfo["description"]{
                                            //assignment
                                            print(bookDescription)
                                            self.bookInfoDict["description"] = bookDescription as? String
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
                                        if let picLinks = volumeInfo["imageLinks"]{
                                            if let imageURL = picLinks!["thumbnail"]{
                                                print (imageURL)
                                            }
                                        }
                                        if let pageCount = volumeInfo["pageCount"]{
                                            print(pageCount)
                                        }
                                        // possible additions are 1. catagories, 2. publication date
                                    }
                                    
                                 
                                    
                                }
                            }
                            
                        }
                       
                    // there should be a segue here, that sends the dictionary.
                        // maybe to some kind of conformation page
                    }catch {
                        print("Error with Json: \(error)")
                    }
                    
                
                }
            }
            
        task.resume()
            
    }
    
    
    func goBackToWhereWeCameFrom(){
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
}