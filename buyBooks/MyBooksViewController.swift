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
    
    var ref = FIRDatabase.database().reference()
    
    
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
        print("after fetch")
        
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
    func fetchPost()
    {
        let uid = getUID()
        
        //ref.child("SellBooksPost").queryEqualToValue(uid).observeEventType(.Value, withBlock: {
        //ref.queryOrderedByChild("uid").observeEventType(.ChildAdded, withBlock: {
        ref.child("SellBooksPost").queryOrderedByChild("uid").queryEqualToValue(uid).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let title = snapshot.value!["bookTitle"] as! String
            
            let detail = snapshot.value!["bookDetail"] as! String
            let condition = snapshot.value!["bookCondition"] as! String
            let bookImage = snapshot.value!["bookImage"] as! String
            let price = snapshot.value!["price"] as! String
            let sellerName = snapshot.value!["fullName"] as! String
            let sellerEmail = snapshot.value!["email"] as! String
            let sellerProfilePhoto = snapshot.value!["profilePhoto"] as! String
            let postedTime = snapshot.value!["postedTime"] as! String
            let postId = snapshot.value!["SellBooksPostId"] as! String
            let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
            self.sellBookArray.addObject(Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: postedTime, postId: postId))
            
            
            
            
            
            self.tableView.reloadData()
            
        
        })
    
        /*let tempUser = User(fullName: "test", email: "test@test.com", profileImage: "none")
        self.sellBookArray.addObject(Book(user: tempUser , title: "fgdfg", price: 5.0, pictures: "none", condition: "ok", postedTime: "time", detail: "detail"))
        ref.child("SellBooksPost").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            
            let title = snapshot.value!["bookTitle"] as! String
            let detail = snapshot.value!["bookDetail"] as! String
            let condition = snapshot.value!["bookCondition"] as! String
            let bookImage = snapshot.value!["bookImage"] as! String
            let price = snapshot.value!["price"] as! String
            let sellerName = snapshot.value!["fullName"] as! String
            let sellerEmail = snapshot.value!["email"] as! String
            let sellerProfilePhoto = snapshot.value!["profilePhoto"] as! String
            let postedTime = snapshot.value!["postedTime"] as! String
            print(title)
            let sellerInfo = User(fullName: sellerName, email: sellerEmail, profileImage: sellerProfilePhoto)
            self.sellBookArray.addObject(Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: postedTime, detail: detail))
            
 
        
        
            
            self.tableView.reloadData()
        }//)
        
        */
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
        //cell.fullName.text = book!.sellerInfo?.email
        cell.title.text = book!.title
        //cell.detail.text = book!.detail
        cell.postedTime.text = book!.postedTime
        cell.price.text = String(book!.price!)
        
        return cell
    }
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped")
        performSegueWithIdentifier("editBook", sender: sellBookArray[indexPath.row])
    }
    
}
