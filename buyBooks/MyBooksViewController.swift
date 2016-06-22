//
//  MyBooksViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/25/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//


import UIKit
import Social
import Firebase
import MessageUI

class MyBooksViewController: UIViewController  {
    
    //TODO: relisting of books
    var cache:ImageLoadingWithCache?

    var ref = FIRDatabase.database().reference()
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

    
    // currently selected index in the tableview
    var currIndex:NSIndexPath?
    // string that holds the facebook message
    var facebookMessageString:String?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editBook"
        {
            //navigationController?.hidesBarsOnSwipe = false

            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let destinationVC = segue.destinationViewController as! EditBooksViewController
            destinationVC.postId = (sellBookArray[indexPath.row] as! Book).postId!
            
        }
        else if segue.identifier == "popfromMyBooks"{
            let vc = segue.destinationViewController
            let controller = vc.popoverPresentationController
            if controller != nil{
                controller?.delegate = self
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var sellBookArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbvc = self.tabBarController as! DataHoldingTabBarViewController // going to get data from here instead.
        cache = tbvc.cache
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchPost()
        tableView.reloadData()
        
        navigationController?.hidesBarsOnSwipe = true

        //Activity Indicator
        activityView.color = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        activityView.center = self.view.center
        
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        //fetchPost()

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true

        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.dataChangedForMyBooks{
            
            
            //appDelegate.mainDic=response.mutableCopy() as? NSMutableDictionary
            sellBookArray = []
            fetchPost()
            tableView.reloadData()
            appDelegate.dataChangedForMyBooks = false
        }
        else{
            print("data didnt change")
        }
 
        
        tableView.reloadData() // this saves us from a crash
    }
    //Do the following if the user want to sell a book
    override func viewDidAppear(animated: Bool)
    {
        //navigationController?.hidesBarsOnSwipe = true

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
            dateformatter.dateFormat = "EEEE"
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

extension MyBooksViewController: UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UIPopoverPresentationControllerDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        if sellBookArray.count == 0 {
            print("our book array is empty")
            activityView.stopAnimating()
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
        //reset color
        cell.yearPublished.textColor = UIColor.darkTextColor()
       // cell.fullName.text = book!.sellerInfo?.fullName
        cell.title.text = book!.title
        cell.authors.text = "By: " + book!.webAuthors!
        cell.postedTime.text = book!.postedTime
        cell.price.text = "$ " + String(book!.price!)
        
       // cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        //cell.profileImage.clipsToBounds = true
        cell.yearPublished.text = book!.publishedYear
        
        var tempString = book!.webBookThumbnail!
        if (tempString.hasPrefix("http:")){
            tempString.insert("s", atIndex: tempString.startIndex.advancedBy(4))
            print(tempString)
        }
        let name = book!.sellerInfo?.email
       
        
        if (book!.bookStatus == "sold"){
            cell.yearPublished.text = "SOLD"
            cell.yearPublished.textColor = UIColor.redColor()
        }
        
        
        cache!.getImage(tempString, imageView: cell.mainImage, defaultImage: "noun_9280_cc")
        print("after getimage")
        
        activityView.stopAnimating()
        
        
        return cell

    }
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped")
        //navigationController?.hidesBarsOnSwipe = false
        //navigationController?.navigationBar.hidden = true
        //navigationController?.navigationBar.hidden = false

        performSegueWithIdentifier("editBook", sender: sellBookArray[indexPath.row])
    }
    
    
    func facebookShare()
    {
        
        let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookComposer.setInitialText(self.facebookMessageString!)
        let cell:MyBooksViewCell = tableView.cellForRowAtIndexPath(currIndex!) as! MyBooksViewCell
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
        shareAction.backgroundColor = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        return [shareAction]
        
        
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    // for the popover in the upper right
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
    
}
