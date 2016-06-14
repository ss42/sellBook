//
//  SearchTableViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/2/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase


// very similar to home view controller, it loads all of its data from the superview (dataholdingtabbarviewcontroller. Maybe this is a really bad way of doing this.)
class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var cache:ImageLoadingWithCache?
    var ref = FIRDatabase.database().reference()

   
    var sellBookArray: NSMutableArray = []
    var filteredSellBookArray = [Book]()
    
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
        if appDelegate.dataChangedForHomeAndSearch
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
        //let tempUser = User(fullName: "test", email: "test@test.com", profileImage: "none")
        //self.sellBookArray.addObject(Book(user: tempUser , title: "fgdfg", price: 5.0, pictures: "none", condition: "ok", postedTime: "time", detail: "detail"))
        let uid = getUID()
        ref.child("SellBooksPost").queryOrderedByChild("uid").queryEqualToValue(uid).observeEventType(.ChildAdded, withBlock: {
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
            //let bookSold = snapshot.value!["bookSold"] as! String
            let bookStatus = snapshot.value!["bookStatus"] as! String
            
            
            print(title)
            if (bookStatus != "deleted"){
                
                let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
                let tempBook = Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: elapsedTime, postId: postID, isbn: isbn, authors: authors, imageURL: imageURL, pageCount: pageCount, description: description, yearPublished: publishedDate, status: bookStatus)
                
                
                self.sellBookArray.insertObject(tempBook, atIndex: 0)
            }
            else
            {
                print("saw a deleted book")
            }
            
            self.tableView.reloadData()
        })
        
        
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
        
        cell.fullName.text = book!.sellerInfo?.fullName
        cell.title.text = book!.title
        cell.authors.text = "By: " + book!.webAuthors!
        //cell.postedTime.text = book!.postedTime
        cell.price.text = "$ " + String(book!.price!)
        
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.clipsToBounds = true
        //cell.yearPublished.text = book!.publishedYear
        
        var tempString = book!.webBookThumbnail!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let name = book!.sellerInfo?.fullName
        cell.profileImage.setImageWithString(name, color: UIColor.init(hexString: User.generateColor(name!)))
        
   
        
        cache!.getImage(tempString, imageView: cell.mainImage, defaultImage: "noun_9280_cc")
        print("after getimage")

        
        
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
    


}

class ImageLoadingWithCache {
    
    var imageCache = [String:UIImage]()
    
    func getImage(url: String, imageView: UIImageView, defaultImage: String) {
        if let img = imageCache[url] {
            imageView.image = img
        } else {
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
            let mainQueue = NSOperationQueue.mainQueue()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    self.imageCache[url] = image
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        imageView.image = image
                        print("sent image to view")
                    })
                }
                else {
                    imageView.image = UIImage(named: defaultImage)
                    print("load failed")
                }
            })
        }
    }
    func getImage(url:String, defaultImage:String)->UIImage{
        if let img = imageCache[url]{
            return img
        }
        else{
            return UIImage(named: "male")!
        }
    }
}

