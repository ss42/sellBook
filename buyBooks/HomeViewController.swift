//
//  ViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase
import Social
import MessageUI


//import SDWebImage

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    var ref = FIRDatabase.database().reference()
    
    //let myActivityIndicator = UIActivityIndicatorView()

    var cache = ImageLoadingWithCache()
    
    @IBOutlet weak var tableView: UITableView!
    
    var sellBookArray: NSMutableArray = []
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        tbvc.sellBookArray = self.sellBookArray
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPost()
                tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        tableView.rowHeight = 105
        tableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   /* override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        myActivityIndicator.center = self.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.activityIndicatorViewStyle = .Gray
        self.view.addSubview(myActivityIndicator)
        myActivityIndicator.startAnimating()
        
        //loadImages()
    }*/
    
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
    func timeElapsed(date: String)-> String{
        
        let dateformatter = NSDateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postedDate  = dateformatter.dateFromString(date)!
        
        
        let elapsedTimeInSeconds = NSDate().timeIntervalSinceDate(postedDate)
        
        
        let secondInDays: NSTimeInterval = 60 * 60 * 24
        
        
        if elapsedTimeInSeconds > 7 * secondInDays {
            dateformatter.dateFormat = "MM/dd/yy"
            let timeToShow: String = dateformatter.stringFromDate(postedDate)
            return timeToShow
            
        } else if elapsedTimeInSeconds > secondInDays{
            dateformatter.dateFormat = "EEE"
            // print("first if statement Time Elapsed > secinds indays ")
            let timeToShow: String = dateformatter.stringFromDate(postedDate)
            return timeToShow
            
            
        } else if elapsedTimeInSeconds > secondInDays/60{
            let timeToshow = Int(elapsedTimeInSeconds/3600)
            
            return "\(timeToshow) hour ago"
            
        }
        else {
            let timeToshow = Int(elapsedTimeInSeconds/60)
            return "\(timeToshow) mins ago "
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
            let elapsedTime = self.timeElapsed(postedTime)
            let isbn = snapshot.value!["isbn"] as! String
            let pageCount = snapshot.value!["pageCount"] as! String
            let authors = snapshot.value!["authors"] as! String
            let imageURL = snapshot.value!["imageURL"] as! String
            let description = snapshot.value!["description"] as! String
            let publishedDate = snapshot.value!["publishedDate"] as! String
            let postID = snapshot.value!["SellBooksPostId"] as! String
            
            
            let bookStatus = snapshot.value!["bookStatus"] as! String
    
            print(title)
            
            if bookStatus != "deleted"{
                
                let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
                let tempBook = Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: elapsedTime, postId: postID, isbn: isbn, authors: authors, imageURL: imageURL, pageCount: pageCount, description: description, yearPublished: publishedDate, status: bookStatus)
            
            
                self.sellBookArray.addObject(tempBook)
            }
            else
            {
                print("saw a deleted book")
            }
            //self.sellBookArray.addObject(Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: elapsedTime, postId: ""))

            
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
        else if segue.identifier == "homeToDetail"{
            let vc = segue.destinationViewController as! ViewDetailOfBooksOnSaleViewController
            let indexPath:NSIndexPath = tableView.indexPathForSelectedRow!
            let tempBook = self.sellBookArray[indexPath.row]
            vc.detailBook = (tempBook as! Book)
            //let tempCell = tableView.cellForRowAtIndexPath(indexPath)?.imageView
            let cell:PostTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
            let image = cell.mainImage.image
            vc.bookPicture = image
            
            //let image = tableviewc as PostTableViewCell
        }
    }
    



}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
    
    func facebookShare(alert:UIAlertAction!)
    {
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("logged in?")
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){ // this works, but it checks the app (to see if you are logged in) first.
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposer.setInitialText("initial text")
                facebookComposer.addImage(UIImage(named: "male"))
                
                self.presentViewController(facebookComposer, animated: true, completion: nil)
            }
        }
        else
        {
            print("else")
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.sendActionsForControlEvents(.TouchUpInside)
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let book = self.sellBookArray[indexPath.row] as! Book
        let shareAction = UITableViewRowAction(style: .Normal, title: "Share"){(action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
            
            
            
            // add more options
            let shareAlertController = UIAlertController(title: "share something (Temp)", message: "stuff (change)", preferredStyle: .ActionSheet)
            let faceBookShareAction = UIAlertAction(title: "facebook", style: UIAlertActionStyle.Default, handler: self.facebookShare)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){(action)-> Void in
                
            }
            
            let textAction = UIAlertAction(title: "Text", style: UIAlertActionStyle.Default){(action)-> Void in
                //do stuff
                
                let msgVC = MFMessageComposeViewController()
                msgVC.body = "Hello World"// create a message similiar to view detail view controllers message or facebook's message
                msgVC.recipients = [" "]
                msgVC.messageComposeDelegate = self
                self.presentViewController(msgVC, animated: true, completion: nil)
            }
            
            
            
            
            shareAlertController.addAction(faceBookShareAction)
            
            shareAlertController.addAction(textAction)
            shareAlertController.addAction(cancelAction)
            
            
            self.presentViewController(shareAlertController, animated: true, completion: nil)
            
           
        
    
        }
        return [shareAction]
        
        

    }
    
    
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
        self.performSegueWithIdentifier("homeToDetail", sender: nil)
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        
        
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PostTableViewCell
        
        let book = sellBookArray[indexPath.row] as? Book
        cell.fullName.text = book!.sellerInfo?.email
        cell.title.text = book!.title
        cell.authors.text = "By: " + book!.webAuthors!
        cell.postedTime.text = book!.postedTime
        cell.price.text = "$ " + String(book!.price!)
       
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.clipsToBounds = true
        cell.yearPublished.text = book!.publishedYear
        
        var tempString = book!.webBookThumbnail!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let name = book!.sellerInfo?.email
        cell.profileImage.setImageWithString(cell.fullName.text, color: UIColor.init(hexString: User.generateColor(name!)))
        if (book!.bookStatus == "sold"){
            cell.yearPublished.text = "SOLD"
        }
        
        cache.getImage(tempString, imageView: cell.mainImage, defaultImage: "noun_9280_cc")
        print("after getimage")
        
        
        /*let requestURL: NSURL = NSURL(string: book!.webBookThumbnail!)!
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
                    cell.mainImage.image = picture
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        print("tableview was reloaded")
                        
                        //self.myActivityIndicator.stopAnimating()
                    }
                    
                    
                    
                    print("done with image load?")
                    
                    
                    
                    
                    
                }catch {
                    print("Error with picture: \(error)")
                }
                
                
                
                
                
                
                
            }
            
            
        }
        //task.resume()
        
        
        
        
        */
        
        
        
        //cell.mainImage.image = self.load_image(book!.webBookThumbnail!)
        
        /*let remoteImageUrlString = book!.webBookThumbnail //imageCollection[indexPath.row]
        let imageUrl = NSURL(string:remoteImageUrlString!)
        
        let myBlock: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
            print("Image with url \(imageURL.absoluteString) is loaded")
            
        }
        
        //myCell.myImageView.sd_setImageWithURL(imageUrl, completed: myBlock)
        myCell.myImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.ProgressiveDownload, completed: myBlock)
        
        */
        
        
        return cell
    }
    // for the popover in the upper right
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
}

    /*func loadImage()
    {
        let requestURL: NSURL = NSURL(string: tempString)!
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
                    self.bookImage = picture
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }catch {
                    print("Error with picture: \(error)")
                }
                
                
                
                
                
                
                
            }
            
            
        }
        task.resume()
    }
    
    */
  /*
    func load_image(url:String)->UIImage
    {
        let tempString = url
        let urlString = tempString
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        var tempimage:UIImage?
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if error == nil {
                    tempimage = (UIImage(data: data!))
                    print("loaded image")
                }
                else{
                    print("image load failed?")
                    self.load_image("http://i.imgur.com/zTFEK3c.png")
                }
        })
        print("before return")
        return tempimage!
    }
    
    */
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


    



