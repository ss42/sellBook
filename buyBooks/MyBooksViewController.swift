//
//  MyBooksViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/25/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//


import UIKit
import Firebase

class MyBooksViewController: UIViewController {
    
    
    var cache = ImageLoadingWithCache()

    var ref = FIRDatabase.database().reference()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editBook"
        {
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let destinationVC = segue.destinationViewController as! EditBooksViewController
            destinationVC.postId = (sellBookArray[indexPath.row] as! Book).postId!
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var sellBookArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //fetchPost()
        navigationController?.hidesBarsOnSwipe = true

        //Activity Indicator
        activityView.color = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        activityView.center = self.view.center
        
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.sellBookArray = []
        print("refreshing view")
        fetchPost()
    }
    //Do the following if the user want to sell a book
    override func viewDidAppear(animated: Bool)
    {
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn");
        
        if(!isUserLoggedIn)
        {
            let ViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            self.presentViewController(ViewController, animated: true, completion: nil)
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
                
                
                self.sellBookArray.addObject(tempBook)
            }
            else
            {
                print("saw a deleted book")
            }
            
            self.tableView.reloadData()
        })
        
        
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
    
    
    
    
}

extension MyBooksViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        if sellBookArray.count == 0 {
            print("our book array is empty")
            return 0
        }
            
        else {
            //need to change this to return sellBookArray.count
            return sellBookArray.count
            
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MyBooksViewCell = tableView.dequeueReusableCellWithIdentifier("BookCell") as! MyBooksViewCell
        
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
        
        
        /*if (book!.bookSold == true){
            cell.yearPublished.text = "SOLD" // remove this
        }*/
        
        if (book!.bookStatus == "sold"){
            cell.yearPublished.text = "SOLD"
        }
        
        
        cache.getImage(tempString, imageView: cell.mainImage, defaultImage: "noun_9280_cc")
        print("after getimage")
        
        activityView.stopAnimating()
        
        
        return cell

    }
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped")
        performSegueWithIdentifier("editBook", sender: sellBookArray[indexPath.row])
    }
    
}
