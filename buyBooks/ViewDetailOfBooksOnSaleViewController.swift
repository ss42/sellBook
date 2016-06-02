//
//  ViewDetailOfBooksOnSaleViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/31/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import MessageUI

class ViewDetailOfBooksOnSaleViewController: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var ISBN: UILabel!
    
    @IBOutlet weak var retailPrice: UILabel!
    
    @IBOutlet weak var bookDescription: UITextView!
    
    @IBOutlet weak var pageCount: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    
    @IBOutlet weak var bookCondition: UILabel!
    
    @IBOutlet weak var ourPrice: UILabel!
    @IBOutlet weak var yearPublished: UILabel!
    
    var detailBook:Book?
    var bookPicture:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()

        // Do any additional setup after loading the view.
    }
    
    func getSellerEmail()->String{
        return ""
    }
    func getBuyerEmail()->String{
        return ""
    }
    func generateTitleForEmail()->String{
        return ""
    }
    func generateMessageForEmail()->String{
        return ""
    }
    @IBAction func sendMail(sender:UIButton){
        
        
        let sellerEmail = getSellerEmail()
        //let
        //let alert = UIAlertController(title: <#T##String?#>, message: <#T##String?#>, preferredStyle: <#T##UIAlertControllerStyle#>)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue{
        case MFMailComposeResultCancelled.rawValue:
            alert("Ooops", msg: "Mail Cancelled")
        case MFMailComposeResultSent.rawValue:
            alert("Yes!", msg: "Mail Sent!")
        case MFMailComposeResultSaved.rawValue:
            alert("Yes!", msg: "Mail Saved!")
        case MFMailComposeResultFailed.rawValue:
            alert("Ooops", msg: "Mail Failed!")
            
        default: break
            
        }
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //
    }
    
    
    
    func populateFields()
    {
        bookTitle.text = detailBook?.title
        authors.text = detailBook?.webAuthors
        ISBN.text = detailBook?.webISBN
        retailPrice.text = detailBook?.webPrice
        bookDescription.text = detailBook?.webDescription
        pageCount.text = detailBook?.webPageCount
        bookImage.image = bookPicture
        bookCondition.text = detailBook?.condition
        
        print(String(detailBook!.price!))
       
 
        ourPrice.text = String(detailBook!.price!)
        
        
        yearPublished.text = detailBook?.publishedYear
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
