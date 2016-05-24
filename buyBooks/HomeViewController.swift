//
//  ViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 5/23/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var ref = FIRDatabase.database().reference()
    
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var sellBookArray: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPost()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

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
        ref.child("SellBooksPost").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let title = snapshot.value!["bookTitle"] as! String
            let detail = snapshot.value!["bookDetail"] as! String
            let condition = snapshot.value!["bookCondition"] as! String
            let bookImage = snapshot.value!["bookImage"] as! String
            let price = snapshot.value!["price"] as! String
            let sellerName = snapshot.value!["fullName"] as! String
            let sellerEmail = snapshot.value!["fullName"] as! String
            let sellerProfilePhoto = snapshot.value!["fullName"] as! String
            let postedTime = snapshot.value!["postedTime"] as! String
            let sellerInfo = User(fullName: "Sanjay", email: "testFIXme", profileImage: "NOimageFixME")
            self.sellBookArray?.addObject(Book(user: sellerInfo, title: title, price: Double(price)!, pictures: bookImage, condition: condition, postedTime: postedTime, detail: detail))

            
            
            })
        
        
    }
    


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sellBookArray?.count == 0 {
            return 0
        }
            
        else {
            
        return 10
        
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PostTableViewCell
        
        let book = sellBookArray![indexPath.row] as? Book
        cell.fullName.text = book!.sellerInfo?.email
        cell.title.text = book!.title
        cell.detail.text = book!.detail
        cell.postedTime.text = book!.postedTime
        cell.price.text = String(book!.price)
        
        return cell
    }
}
