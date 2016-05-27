//
//  CreatePostMethodSelectionVIewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/27/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import Foundation
import UIKit

//
//  UserMenuViewController.swift
//  SPAREV3
//
//  Created by Sanjay Shrestha on 3/22/16.
//  Copyright © 2016 Spare. All rights reserved.
//

import UIKit

class CreatePostMethodSelectionViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    @IBAction func manualEntry(sender: AnyObject) {
    }
    
    @IBAction func barcodeScan(sender: AnyObject) {
    }
    
    @IBAction func ISBNEntry(sender: AnyObject) {
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .Popover
    }
}

/*
class UserMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
        override func viewDidLoad() {
                super.viewDidLoad()
        
                // Do any additional setup after loading the view.
            }
    
        override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
        
        
    
        
        @IBAction func CallMerchantPressed(sender: AnyObject) {
            }
        @IBAction func directionButtonPressed(sender: AnyObject) {
            }
        @IBAction func barcodeButtonPressed(sender: AnyObject) {
                
                print("barcode Pressed in the UserMenu")
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                //let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("navView") as! UINavigationController
                
                let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("userBarCodeView")
                
                self.presentViewController(vc, animated: true, completion: nil)
          
            }
    
        
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                if segue.identifier == "userBarcode"{
                        
                        let vc = segue.destinationViewController
                        
                        let controller = vc.popoverPresentationController
                        
                        if controller != nil
                            {
                                    controller?.delegate = self
                                }
                    }
            }
        
        
        func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
            {
                    return .Popover
                }
        
    
}*/

