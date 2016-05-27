//
//  PresentSearchResultsViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/27/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit

class PresentSearchResultsViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var authors: UILabel!
    
    @IBOutlet weak var ISBN: UILabel!
    
    @IBOutlet weak var retailPrice: UILabel!
    
    @IBOutlet weak var bookDescription: UITextView!
    
    @IBOutlet weak var pageCount: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    var bookInfoDict = [String:String]()
    
    
    override func viewDidLoad() {
        print("before view did load super")
        super.viewDidLoad()
        //view.addSubview(popupView)
        print("at detail view")
        populateFields()
        

        // Do any additional setup after loading the view.
    }
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchImage(){
        
        
        let requestURL: NSURL = NSURL(string: bookInfoDict["imageURL"]!)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                do{
                    
                    let picture = UIImage(data:data!)
                    self.bookImage.image = picture
                    
                                
                    
                                
                    
                    
                        
                
                    
              
                }catch {
                    print("Error with picture: \(error)")
                }
                
                
            
            
        
                
        
            }

    
        }
        task.resume()
    }

    func populateFields(){
        
        // bookInfoDict = ["isbn" : ISBN, "title" : "", "description" : "", "authors": "", "imageURL": "", "pageCount": ""]
       bookTitle.text = self.bookInfoDict["gtitle"]
        /*authors.text = bookInfoDict["authors"]
        ISBN.text = bookInfoDict["isbn"]
        retailPrice.text = "fix later"
        //bookDescription.text = bookInfoDict["description"]
        pageCount.text = bookInfoDict["pageCount"]
        print("populated fields")
        
        print(bookTitle.text!)
        print(ISBN.text!)
        //fetchImage()
        */
        print("populated????")
    }
    
    @IBAction func continuePressed(sender: AnyObject) {
        
        
    }

    @IBAction func cancelPressed(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
