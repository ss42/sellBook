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

// TODO: make background white color

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    

    // firebase ref
    var ref = FIRDatabase.database().reference()
    
    //let myActivityIndicator = UIActivityIndicatorView()

    // for loading images, this creates a single instance of the class ImageLoadingWithCache
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //appDelegate.dataChangedForMyBooks = true

    var cache:ImageLoadingWithCache?//
    
    // activity indicator, stopped when images load
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // holds an array of books, loaded from firebase
    var sellBookArray: NSMutableArray = []
    
    
    // string that holds the facebook message
    var facebookMessageString:String?
    
    // currently selected index in the tableview
    var currIndex:NSIndexPath?

    // we load the data into the superview here, this will be used in the serach vc
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)

        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        tbvc.sellBookArray = self.sellBookArray
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        cache = tbvc.cache
        
        // get the data from firebase
        //fetchPost()
           //     tableView.separatorStyle = .None

        // prepare the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = 155
        
        // populate the table
        tableView.reloadData()
        
        // for hiding the nav bar when we scroll
        navigationController?.hidesBarsOnSwipe = true
        
        
        //Activity Indicator
        activityView.color = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        activityView.center = self.view.center
        
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        tbvc.sellBookArray = self.sellBookArray
        
        
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
    
    
    
    // THIS FUNCTION IS NEVER CALLED!!!!!!!!!!!
    
    //Do the following if the user want to sell a book
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController
        
        
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.dataChangedForHomeAndSearch == true{
            //appDelegate.mainDic=response.mutableCopy() as? NSMutableDictionary
            sellBookArray = []
            fetchPost()
            tableView.reloadData()
            appDelegate.dataChangedForHomeAndSearch = false
            tbvc.sellBookArray = self.sellBookArray
            print("searched for new data")
        }
        else{
            print("data didnt change")
            self.sellBookArray = tbvc.sellBookArray
            
        }
        tableView.reloadData()
 
    }
    
    // format the time
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
            dateformatter.dateFormat = "EEEE"
            // print("first if statement Time Elapsed > secinds indays ")
            let timeToShow: String = dateformatter.stringFromDate(postedDate)
            return timeToShow
        } else if elapsedTimeInSeconds > secondInDays/24{
            let timeToshow = Int(elapsedTimeInSeconds/3600)
            
            return "\(timeToshow) hour ago."
            
        }
        else {
            let timeToshow = Int(elapsedTimeInSeconds/60)
            return "\(timeToshow) mins ago. "
        }
        
    }

    // get the data from firebase
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
            let elapsedTime = postedTime//self.timeElapsed(postedTime)
            let isbn = snapshot.value!["isbn"] as! String
            let pageCount = snapshot.value!["pageCount"] as! String
            let authors = snapshot.value!["authors"] as! String
            let imageURL = snapshot.value!["imageURL"] as! String
            let description = snapshot.value!["description"] as! String
            let publishedDate = snapshot.value!["publishedDate"] as! String
            let postID = snapshot.value!["SellBooksPostId"] as! String
            
            
            let bookStatus = snapshot.value!["bookStatus"] as! String
    
            print(title)
            // TODO: make sure that we want books to be hidden if they were posted more than a month ago
            if (bookStatus != "deleted"){
                //&& (self.timeElapsedinSeconds(postedTime) < 60*60*24*30)){ //&& bookStatus != "sold"){
                
                
                let timeOfMail = snapshot.value!["timeOfMail"] as! String
                
                //let condition = Book.howShouldBookBeDisplayed(timeOfMail, bookStatus: bookStatus)
                
                //if self.shouldBookBeDisplayed(bookStatus, timeOfMail: timeOfMail)
                
                    let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
                    let tempBook = Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: elapsedTime, postId: postID, isbn: isbn, authors: authors, imageURL: imageURL, pageCount: pageCount, description: description, yearPublished: publishedDate, status: bookStatus)
                
                if (self.timeElapsedinSeconds(postedTime) < 60*60*24*30 || (bookStatus == "sold" && self.timeElapsedinSeconds(postedTime) < 60*60*24*90)){
                    self.sellBookArray.insertObject(tempBook, atIndex: 0)
                }
                    //self.sellBookArray.insertObject(tempBook, atIndex: 0)//.addObject(tempBook)
                    
                    
                
            }
            else
            {
                print("saw a deleted book")
            }
            //self.sellBookArray.addObject(Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: elapsedTime, postId: ""))

            
            self.tableView.reloadData()
            })
        
        
    }
   

    
    func timeElapsedinSeconds(date: String)-> Double{
        
        let dateformatter = NSDateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let postedDate  = dateformatter.dateFromString(date)!
        
        let elapsedTimeInSeconds = NSDate().timeIntervalSinceDate(postedDate)
        return elapsedTimeInSeconds
    }
    
    func shouldBookBeDisplayed(status:String, timeOfMail:String)->Bool{
        //let postTime = timeElapsedinSeconds(timePosted)
        if timeOfMail == " "
        {
            return true
        }
        let mailTime = timeElapsedinSeconds(timeOfMail)
        
        /*if status == "dormant"
        {
            return false
        }*/
        if status == "default"
        {
            return true
        }
        else if status == "emailSent"
        {
            let sevenDaysInSeconds:Double = (60 * 60 * 24 * 7)
            if mailTime > sevenDaysInSeconds
            {
                return false
            }
        }
        // TODO: add a condition, if the post is over a month old then it should be deleted from firebase entirely. maybe 2-3 months.
        return true
    }
    // send data to the next view controllers
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
    // for facebook stuff
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
    // facebook stuff, checks to see if logged in and then posts a message. We currently need to change the message and the picture that is posted
    //TODO: Fix facebook message and picture
    func facebookShare()
    {
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("logged in?")
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){ // this works, but it checks the app (to see if you are logged in) first.
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposer.setInitialText(self.facebookMessageString!)
                let cell:PostTableViewCell = tableView.cellForRowAtIndexPath(currIndex!) as! PostTableViewCell
                let image = cell.mainImage.image
                
                facebookComposer.addImage(image)
                
                   

                
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
    
    // TODO: function that formulates messages based on which book you selected
    func setFacebookMessage(book:Book)
    {
        print("making facebook message")
        self.facebookMessageString = book.title! + ", by " + book.webAuthors! + " is currently listed for $" + String(book.price)
    }
        
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let book = self.sellBookArray[indexPath.row] as! Book
        // TODO: these are never called i dont think, because of how the slide action behaves. I'm not sure how we are going to get it to know which row the button was slid out at
       
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Share"){(action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
            
            
            
            // add more options
            let shareAlertController = UIAlertController(title: "share something (Temp)", message: "stuff (change)", preferredStyle: .ActionSheet)
            let faceBookShareAction = UIAlertAction(title: "facebook", style: UIAlertActionStyle.Default){(action) -> Void in
            
                self.setFacebookMessage(book)
                self.currIndex = indexPath
                self.facebookShare()
        }
        
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
        // maybe sort the array here?
        if sellBookArray.count == 0 {
            print("sell book array is empty")
            activityView.stopAnimating()

            return 0
        }
            
        else {
            print("counting the array")
            
            return sellBookArray.count
        
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        self.performSegueWithIdentifier("homeToDetail", sender: nil)
        
    }
    
    // TODO: this should return the overlay banner picture, the cell will position in it in a uiimageview
    func setBanner(book:Book)->UIImage
    {
        var img:UIImage = UIImage(named: "male")!
        
        let timeInSeconds = timeElapsedinSeconds(book.postedTime!)
        
        // if book is sold show the sold image
        
        if book.bookStatus == "sold"{
            // img = UIImage(named: "soldBanner")!
            img = UIImage(named:"barcode")!
        }
        
        // if the book has been up for less than one day then show the new banner
        else if timeInSeconds < (60 * 60 * 24){
            // img = UIImage(named: "soldBanner")!
        }
        
        
        // if book is new show the new banner
        
        
        
        return img
    }
    
    
    // TODO fix imageloading problem (the banners and the main images sometimes, can be reproduced by scrolling down then switching the tab bars and then scrolling up)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PostTableViewCell
        cell.bannerImage.hidden = true
        cell.mainImage.image = UIImage(named: "male")
        
        let book = sellBookArray[indexPath.row] as? Book
        cell.fullName.text = (book!.sellerInfo?.fullName)
        cell.title.text = book!.title
        cell.authors.text = "  By: " + book!.webAuthors!
        cell.postedTime.text = self.timeElapsed(book!.postedTime!)
        cell.price.text = "$ " + String(book!.price!)
       
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.clipsToBounds = true
       // cell.yearPublished.text = book!.publishedYear
        
        var tempString = book!.webBookThumbnail!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let name = book!.sellerInfo?.fullName
        cell.profileImage.setImageWithString(name, color: UIColor.init(hexString: User.generateColor(name!)))
        /*if (book!.bookStatus == "sold"){
            cell.yearPublished.text = "SOLD"
        }*/
                //cell.banner.image = setBanner(book!)
        
        cache!.getImage(tempString, imageView: cell.mainImage, defaultImage: "noun_9280_cc")
        
        // if the book is less than a week old then it is new
        /*if (timeElapsedinSeconds(book!.postedTime!) < 60 * 60 * 24 * 7){
            // TODO: make a banner image for new books
            //cell.bannerImage.image = UIImage(named: "male")
            
            cell.bannerImage.hidden = false
        }*/
        // TODO make a banner image for sold books
        if(book!.bookStatus == "sold")
        {
            print("sold book seen")
           // cell.bannerImage.image = UIImage(named: "male")
            //cache!.getImage(<#T##url: String##String#>, defaultImage: <#T##String#>)
            cell.bannerImage.image = UIImage(named: "fixedBanner")
            cell.bannerImage.hidden = false
            cell.postedTime.hidden = true
        }

        print("after getimage")
        
        activityView.stopAnimating()
        print("Stopped the activity indicator")
        
        return cell
        
        }
    
        
        //cell.mainImage.image = self.load_image(book!.webBookThumbnail!)
        
        /*let remoteImageUrlString = book!.webBookThumbnail //imageCollection[indexPath.row]
        let imageUrl = NSURL(string:remoteImageUrlString!)
        
        let myBlock: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
            print("Image with url \(imageURL.absoluteString) is loaded")
            
        }
        
        //myCell.myImageView.sd_setImageWithURL(imageUrl, completed: myBlock)
        myCell.myImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.ProgressiveDownload, completed: myBlock)
        
        */
    
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
   