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
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    

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
    var sellBookArray = [Book]()
    
    
    // string that holds the facebook message
    var facebookMessageString:String?
    
    // currently selected index in the tableview
    var currIndex:NSIndexPath?
    
    // check for first load
    var firstLoad:Bool = false

    // we load the data into the superview here, this will be used in the serach vc
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        // FIX THIS
        //tbvc.sellBookArray = self.sellBookArray
        
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        /*let newMovie = Movie(title: "Serenity", genre: "Sci-fi")
        movies.append(newMovie)
        
        movies.sort() { $0.title < $1.title }
        */
        print("refreshed data")
        sellBookArray = []
        //fetchPost()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    func prepareLayout(){
        //self.tableView.addSubview(self.refreshControl)
        
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        cache = tbvc.cache

        // prepare the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = 155
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataChangedForHomeAndSearch = false
        appDelegate.dataChangedForMyBooks = true
        
        // populate the table
        tableView.reloadData()
        
        // for hiding the nav bar when we scroll
        navigationController?.hidesBarsOnSwipe = true
        
        
        //Activity Indicator
        activityView.color = UIColor.darkTextColor()//(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        activityView.center = self.view.center
        
        
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        
        //tbvc.sellBookArray = self.sellBookArray
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareLayout()
        
        ref.child("SellBooksPost").observeEventType(.Value, withBlock: { snapshot in
            print("in snapshot")
            var newBooks = [Book]()
            for item in snapshot.children{
                let title = item.value!["bookTitle"] as! String
                print(title)
                let book = Book(snapshot: item as! FIRDataSnapshot)
                
                if book.valid == true{
                   // newBooks.append(book) //TODO: this probably has to be inserted at position zero
                    newBooks.insert(book, atIndex: 0)
                }
            }
            self.sellBookArray = newBooks
            self.tableView.reloadData()
        })
        
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
       // CustomNavigation.customNavBarForHome()
        // for pull to refresh
        self.tableView.addSubview(self.refreshControl)
        
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        cache = tbvc.cache
        
        // get the data from firebase
        print("in view did load")
        fetchPost()

        
           //     tableView.separatorStyle = .None

        // prepare the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = 155
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataChangedForHomeAndSearch = false
        appDelegate.dataChangedForMyBooks = true
        
        // populate the table
        tableView.reloadData()
        
        // for hiding the nav bar when we scroll
        navigationController?.hidesBarsOnSwipe = true
        
        
        //Activity Indicator
        activityView.color = UIColor.darkTextColor()//(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        activityView.center = self.view.center
        
        
        activityView.startAnimating()
        
        self.view.addSubview(activityView)

        
        tbvc.sellBookArray = self.sellBookArray
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
 */
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // THIS FUNCTION IS NEVER CALLED!!!!!!!!!!!
    
    //Do the following if the user want to sell a book
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        print("in view will appear")
        /*
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController
        
        
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if ((appDelegate.dataChangedForHomeAndSearch == true )){ //|| sellBookArray.count == 0)){
            //appDelegate.mainDic=response.mutableCopy() as? NSMutableDictionary
            sellBookArray = []
            fetchPost()
            tableView.reloadData()
            appDelegate.dataChangedForHomeAndSearch = false
            //tbvc.sellBookArray = self.sellBookArray
            print("searched for new data")
        }
        else{
            print("data didnt change")
            //self.sellBookArray = tbvc.sellBookArray
            
        }
        
        tableView.reloadData()
 */
 
    }
    
   /* override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController

        if ((appDelegate.dataChangedForHomeAndSearch == true )){ //|| sellBookArray.count == 0)){
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
        super.viewDidAppear(animated)
        
    }
 */
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
        print("fetching post")
        ref.child("SellBooksPost").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            print("in snapshot")
            
            let title = snapshot.value!["bookTitle"] as! String
            //let detail = snapshot.value!["bookDetail"] as! String
            let condition = snapshot.value!["bookCondition"] as! String
           // let bookImage = snapshot.value!["imageURL"] as! String
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
            let postId = snapshot.value!["SellBooksPostId"] as! String
            
            
            let bookStatus = snapshot.value!["bookStatus"] as! String
    
           // print(title)
            // TODO: make sure that we want books to be hidden if they were posted more than a month ago
            if (bookStatus != "deleted"){
                //&& (self.timeElapsedinSeconds(postedTime) < 60*60*24*30)){ //&& bookStatus != "sold"){
                
                
                let timeOfMail = snapshot.value!["timeOfMail"] as! String
                print("non deleted book")
                
                let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
                
                
                
                let tempBook = Book(user: sellerInfo, title: title, price: Int(price)!, condition: condition, postedTime: elapsedTime, postId: postId, isbn: isbn, authors: authors, imageURL: imageURL, pageCount: pageCount, description: description, yearPublished: publishedDate, status: bookStatus, timeOfMail: timeOfMail)
                
                if (self.timeElapsedinSeconds(postedTime) < 60*60*24*30 || (bookStatus == "sold" && self.timeElapsedinSeconds(postedTime) < 60*60*24*90)){
                    // FIX THIS
                    //self.sellBookArray.insertObject(tempBook, atIndex: 0)
                }
                
            }
            else
            {
                print("saw a deleted book")
            }
           
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
       
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposer.setInitialText(self.facebookMessageString!)
                let cell:PostTableViewCell = tableView.cellForRowAtIndexPath(currIndex!) as! PostTableViewCell
                let image = cell.mainImage.image
                
                facebookComposer.addImage(image)
                // TODO make this our actual url!
                //facebookComposer.addURL(NSURL(string: "http://facebook.com"))
        

                
                self.presentViewController(facebookComposer, animated: true, completion: nil)
  
    }
    
    // TODO: function that formulates messages based on which book you selected
    func setFacebookMessage(book:Book)
    {
        print("making facebook message")
        self.facebookMessageString = book.title! + ", by " + book.webAuthors! + " is currently listed for $"
        self.facebookMessageString = self.facebookMessageString! + String(book.price!)
        print(self.facebookMessageString)
        
    }
        
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let book = self.sellBookArray[indexPath.row] as! Book
        // TODO: these are never called i dont think, because of how the slide action behaves. I'm not sure how we are going to get it to know which row the button was slid out at
       
        
        let shareAction = UITableViewRowAction(style: .Normal, title: "Share"){(action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
            
            
            
            // add more options
            let shareAlertController = UIAlertController(title: "Share with your friends.", message: "", preferredStyle: .ActionSheet)
            let faceBookShareAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default){(action) -> Void in
            
                self.setFacebookMessage(book)
                self.currIndex = indexPath
                self.facebookShare()
            }
        
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){(action)-> Void in
                
            }
            
            let textAction = UIAlertAction(title: "Text", style: UIAlertActionStyle.Default){(action)-> Void in
                //do stuff
                
                let msgVC = MFMessageComposeViewController()
                msgVC.body = "Hey, \n" + "I have this book " +  "'\(book.title!)'"  + " for sale, it is currently listed for $\(book.price!)." + " Please check out the BOOK-RACK app to buy and sell books at SMC!"
                msgVC.recipients = [" "]
                
                
                //TODO: attach phooto
                /*let imageURL = NSURL(string: book.pictures!)
                print(imageURL)
                msgVC.addAttachmentURL(imageURL!, withAlternateFilename: "test")
 */
                //let imageData = self.cache?.getImage(book.pictures!, defaultImage: "male")
                let cell:PostTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
                let imageData = cell.mainImage.image
                //(self.sellBookArray[indexPath.row] as! PostTableViewCell).mainImage
                let convertedImage = UIImagePNGRepresentation(imageData!)
                
                msgVC.addAttachmentData(convertedImage!, typeIdentifier: "image/png", filename: "Book thumbnail.jpeg")
                msgVC.messageComposeDelegate = self
                
                self.presentViewController(msgVC, animated: true, completion: nil)
            }
            
            
            
            
            shareAlertController.addAction(faceBookShareAction)
            
            shareAlertController.addAction(textAction)
            shareAlertController.addAction(cancelAction)
            
            
            self.presentViewController(shareAlertController, animated: true, completion: nil)
            
           
        
    
        }
        shareAction.backgroundColor = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        return [shareAction]
        
        

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // maybe sort the array here?
        /*if sellBookArray.count == 0 {
            print("sell book array is empty")
            activityView.stopAnimating()

            return 0
        }
            
        else {
            print("counting the array")
            
            return sellBookArray.count
        
        }
 */
        
        return sellBookArray.count
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
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PostTableViewCell
        cell.bannerImage.hidden = true
        cell.postedTime.hidden = false
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
        var name = book!.sellerInfo?.fullName
        if name == nil{
            name = "None"
        }
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
        if(book!.bookStatus == "sold")
        {
            print("sold book seen")
           // cell.bannerImage.image = UIImage(named: "male")
            //cache!.getImage(<#T##url: String##String#>, defaultImage: <#T##String#>)
            cell.bannerImage.image = UIImage(named: "fixedBanner")
            cell.bannerImage.hidden = false
            cell.postedTime.hidden = true
        }
            // TODO: else if its a new book we can maybe have a new book banner, maybe if it is your book and it is new we can have a special animated banner
        else{
            cell.postedTime.hidden = false
            cell.postedTime.text = self.timeElapsed(book!.postedTime!)
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


   