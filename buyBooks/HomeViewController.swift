//
//  ViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    var ref = FIRDatabase.database().reference()
    
   

    
    @IBOutlet weak var tableView: UITableView!
    
    var sellBookArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPost()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /*func load_image(url:String)
    {
        var tempString = url
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let urlString = tempString
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    self.bookImage.image = UIImage(data: data!)
                }
        })
        
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Do the following if the user want to sell a book
    override func viewDidAppear(animated: Bool)
    {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        
        if(!isUserLoggedIn)
        {
           //make the user sign in first
        }
        
        
    }
    func fetchPost()
    {
        //let tempUser = User(fullName: "test", email: "test@test.com", profileImage: "none")
        //self.sellBookArray.addObject(Book(user: tempUser , title: "fgdfg", price: 5.0, pictures: "none", condition: "ok", postedTime: "time", detail: "detail"))
        ref.child("SellBooksPost").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let title = snapshot.value!["bookTitle"] as! String
            //let detail = snapshot.value!["bookDetail"] as! String
            let condition = snapshot.value!["bookCondition"] as! String
            let bookImage = snapshot.value!["imageURL"] as! String
            let price = snapshot.value!["price"] as! String
            let sellerName = snapshot.value!["fullName"] as! String
            let sellerEmail = snapshot.value!["email"] as! String
            let sellerProfilePhoto = snapshot.value!["profilePhoto"] as! String
            let postedTime = snapshot.value!["postedTime"] as! String
            print(title)
            let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
            self.sellBookArray.addObject(Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: postedTime, postId: ""))

            
            self.tableView.reloadData()
            })
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "popoverMenu"{
            let vc = segue.destinationViewController
            let controller = vc.popoverPresentationController
            if controller != nil{
                controller?.delegate = self
            }
        }
    }
    



}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        if sellBookArray.count == 0 {
            print("sell book array is empty")
            return 0
        }
            
        else {
         //need to change this to return sellBookArray.count
        return sellBookArray.count
        
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PostTableViewCell
        
        let book = sellBookArray[indexPath.row] as? Book
        cell.fullName.text = book!.sellerInfo?.email
        cell.title.text = book!.title
       // cell.detail.text = book!.detail
        cell.postedTime.text = book!.postedTime
        cell.price.text = String(book!.price!)
        
        
        return cell
    }
    
    
    
    
    /*
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
       
           let requestedRide = self.tempArray[indexPath.row] as! Trips
            let driver = "\(requestedRide.driver!.firstName) \(requestedRide.driver!.lastName)"
            let contactAction = UITableViewRowAction(style: .Normal, title: "Contact \(requestedRide.driver!.firstName)"){(action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
                
                let contactAlertController = UIAlertController(title: "Contact  \(driver)", message: ":)", preferredStyle: .ActionSheet )
                
                let callAction = UIAlertAction(title: "Call the Driver", style: UIAlertActionStyle.Default){(action)-> Void in
                    // the phone number is default.
                    // need to check for correct phone number when inputed and add below
                    var url:NSURL = NSURL(string: "tel://+15106954976")!
                    UIApplication.sharedApplication().openURL(url)
                }
                let textAction = UIAlertAction(title: "Text", style: UIAlertActionStyle.Default){(action)-> Void in
                    //message hard coded for now
                    
                    let msgVC = MFMessageComposeViewController()
                    msgVC.body = "Hello World"
                    msgVC.recipients = ["+15103675660"]
                    msgVC.messageComposeDelegate = self
                    self.presentViewController(msgVC, animated: true, completion: nil)
                }
                let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default){(action)-> Void in
                    
                    let vc: SendMailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("sendMail") as! SendMailViewController
                    let trip = self.tempArray[indexPath.row] as! Trips
                    vc.emailAddress = trip.email
                    self.presentViewController(vc, animated: true, completion: nil)
                    
                    //do stuff
                    //segue to sendmailcontroller and send data or driver's email add thru segue
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){(action)-> Void in
                    
                }
                contactAlertController.addAction(callAction)
                contactAlertController.addAction(textAction)
                contactAlertController.addAction(emailAction)
                contactAlertController.addAction(cancelAction)
                
                self.presentViewController(contactAlertController, animated: true, completion: nil)
                
            }
            let requestAction = UITableViewRowAction(style: .Normal, title: "Request Ride"){(action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
                
                let requestAlertController = UIAlertController(title: nil, message: "Are you sure you want to request this ride?", preferredStyle: .ActionSheet)
                
                let requestAction = UIAlertAction(title: "Confirm Request", style: UIAlertActionStyle.Default){(action)-> Void in
                    let vc: RideHistoryViewController = self.storyboard!.instantiateViewControllerWithIdentifier("myRide") as! RideHistoryViewController
                    
                    vc.myRideArray.addObject(requestedRide)
                    
                    
                    
                    self.tableView.reloadData()
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                requestAlertController.addAction(requestAction)
                requestAlertController.addAction(cancelAction)
                
                self.presentViewController(requestAlertController, animated: true, completion: nil)
                
            }
            
            contactAction.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
            requestAction.backgroundColor = UIColor(red: 82/255, green: 69/255, blue: 105/255, alpha: 1.0)
            
            return [contactAction, requestAction]
        return 0
    }
     */


    
    // for the popover in the upper right
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
}


