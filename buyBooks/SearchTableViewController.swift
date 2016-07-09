//
//  SearchTableViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/2/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase
import Social
import MessageUI


// very similar to home view controller, it loads all of its data from the superview (dataholdingtabbarviewcontroller. Maybe this is a really bad way of doing this.)
class SearchTableViewController: UITableViewController, UISearchResultsUpdating, MFMessageComposeViewControllerDelegate {

    var cache:ImageLoadingWithCache?
    var ref = FIRDatabase.database().reference()
    
    
    
    
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
        fetchPost()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    /*lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
*/
   
    var sellBookArray: NSMutableArray = []
    var filteredSellBookArray = [Book]()
    
    
    // string that holds the facebook message
    var facebookMessageString:String?
    
    // currently selected index in the tableview
    var currIndex:NSIndexPath?
   /* func viewWillDisappear(animated: Bool) {
        //dispatch_async(dispatch_get_main_queue(), {
            self.resultsSearchController.active = false
        //})
    }*/
    // holds search results
    // TODO: add default search results or something so that its not empty
    var resultsSearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(SearchTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)

        
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        self.cache = tbvc.cache
        self.sellBookArray = tbvc.sellBookArray
        
        
        self.resultsSearchController = UISearchController(searchResultsController: nil)
        self.resultsSearchController.searchResultsUpdater = self
        
        self.resultsSearchController.dimsBackgroundDuringPresentation = false //true later
        
        self.resultsSearchController.searchBar.sizeToFit()
        self.resultsSearchController.searchBar.placeholder = "Search by: Title or Author or ISBN" // maybe no colon?
        //self.resultsSearchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        self.tableView.tableHeaderView = self.resultsSearchController.searchBar
        
        self.tableView.rowHeight = 155
        //tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        navigationController?.hidesBarsOnSwipe = true

        
        resultsSearchController.searchBar.barTintColor = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        
        self.tableView.reloadData()
        
        

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.dataChangedForHomeAndSearch == true
        {
            sellBookArray = []
            fetchPost()
            tableView.reloadData()
            appDelegate.dataChangedForHomeAndSearch = false
            print("data changed for search")
            tbvc.sellBookArray = self.sellBookArray
        }
        else{
            self.sellBookArray = tbvc.sellBookArray
        }
        
        tableView.reloadData()
        
        
    }
    func fetchPost()
    {
       
        let uid = getUID()
        ref.child("SellBooksPost").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let title = snapshot.value!["bookTitle"] as! String
            let condition = snapshot.value!["bookCondition"] as! String
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
            let timeOfMail = snapshot.value!["timeOfMail"] as! String

            
            print(title)
            if (bookStatus != "deleted"){
                
                let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
                let tempBook = Book(user: sellerInfo, title: title, price: Int(price)!, condition: condition, postedTime: elapsedTime, postId: postID, isbn: isbn, authors: authors, imageURL: imageURL, pageCount: pageCount, description: description, yearPublished: publishedDate, status: bookStatus, timeOfMail: timeOfMail)
                
                
                if (self.timeElapsedinSeconds(postedTime) < 60*60*24*30 || (bookStatus == "sold" && self.timeElapsedinSeconds(postedTime) < 60*60*24*90)){
                    self.sellBookArray.insertObject(tempBook, atIndex: 0)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUID() -> String
    {
        if let user = FIRAuth.auth()?.currentUser{
            return user.uid
        }
        else{
            return "no id???"
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
            
            
        } else if elapsedTimeInSeconds > secondInDays/24{
            let timeToshow = Int(elapsedTimeInSeconds/3600)
            
            return "\(timeToshow) hour ago"
            
        }
        else {
            let timeToshow = Int(elapsedTimeInSeconds/60)
            return "\(timeToshow) mins ago "
        }
        
    }



    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.resultsSearchController.active
        {
            return self.filteredSellBookArray.count
        }
        else{
            return self.sellBookArray.count
        }
        //return 0
    }

    // TODO, STRANGE: this is an override func, and scrolling is very slow on the simulator, in the home vc this funcion is not an override.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PostTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as! PostTableViewCell
        var book:Book?
        
        if self.resultsSearchController.active{
            //cell!.textLabel?.text = self.filteredSellBookArray[indexPath.row]
            book = self.filteredSellBookArray[indexPath.row]
        }
        else{
            book = self.sellBookArray[indexPath.row] as? Book
        }

        // Configure the cell...
        cell.bannerImage.hidden = true
        cell.postedTime.hidden = false
        cell.fullName.text = book!.sellerInfo?.fullName
        cell.title.text = book!.title
        cell.authors.text = "By: " + book!.webAuthors!
        cell.price.text = "$ " + String(book!.price!)
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.clipsToBounds = true
        
        var tempString = book!.webBookThumbnail!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let name = book!.sellerInfo?.fullName
        cell.profileImage.setImageWithString(name, color: UIColor.init(hexString: User.generateColor(name!)))
        cache!.getImage(tempString, imageView: cell.mainImage, defaultImage: "noun_9280_cc")
        
        if(book!.bookStatus == "sold")
        {
            cell.bannerImage.image = UIImage(named: "fixedBanner")
            cell.bannerImage.hidden = false
            cell.postedTime.hidden = true
        }
        else{
            cell.postedTime.hidden = false
            cell.postedTime.text = self.timeElapsed(book!.postedTime!)
        }

        
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(false)
        
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        tbvc.sellBookArray = self.sellBookArray
        
        
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredSellBookArray.removeAll(keepCapacity: false)
        //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //let array = (self.sellBookArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        let array = self.sellBookArray.filter({
            (($0 as! Book).title?.localizedCaseInsensitiveContainsString(searchController.searchBar.text!))! || (($0 as! Book).webAuthors?.localizedCaseInsensitiveContainsString(searchController.searchBar.text!))! || (($0 as! Book).webISBN?.localizedCaseInsensitiveContainsString(searchController.searchBar.text!))!
            
        })
        self.filteredSellBookArray = array as! [Book]
        self.tableView.reloadData()
    }
    
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
        print("selected something in search view")
        self.performSegueWithIdentifier("searchToDetail", sender: nil)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "searchToDetail"{
            let vc = segue.destinationViewController as! ViewDetailOfBooksOnSaleViewController
            let indexPath:NSIndexPath = tableView.indexPathForSelectedRow!
            
            var book:Book?
            var cell:PostTableViewCell?
            
            if self.resultsSearchController.active{
                //cell!.textLabel?.text = self.filteredSellBookArray[indexPath.row]
                book = self.filteredSellBookArray[indexPath.row]
                cell = tableView.cellForRowAtIndexPath(indexPath) as? PostTableViewCell
                let image = cell!.mainImage.image
                vc.bookPicture = image
            }
            else{
                book = self.sellBookArray[indexPath.row] as? Book
                cell = tableView.cellForRowAtIndexPath(indexPath) as? PostTableViewCell
                let image = cell!.mainImage.image
                vc.bookPicture = image
            }
            vc.detailBook = book
            self.resultsSearchController.active = false
            
            //let tempBook = self.filteredSellBookArray
        }
        
    }
    
    
    func facebookShare()
    {
       
                let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposer.setInitialText(self.facebookMessageString!)
                let cell:PostTableViewCell = tableView.cellForRowAtIndexPath(currIndex!) as! PostTableViewCell
                let image = cell.mainImage.image
                
                facebookComposer.addImage(image)
                
                
                
                
                self.presentViewController(facebookComposer, animated: true, completion: nil)
        }
    
    // TODO: function that formulates messages based on which book you selected
    func setFacebookMessage(book:Book)
    {
        print("making facebook message")
        self.facebookMessageString = book.title! + ", by " + book.webAuthors! + " is currently listed for $" + String(book.price)
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let book = self.sellBookArray[indexPath.row] as! Book
        
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
                let cell:PostTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
                let imageData = cell.mainImage.image
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
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
    
    


}
