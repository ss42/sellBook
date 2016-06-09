//
//  SearchTableViewController.swift
//  buyBooks
//
//  Created by Sanjay Shrestha on 6/2/16.
//  Copyright © 2016 www.ssanjay.com. All rights reserved.
//

import UIKit


// very similar to home view controller, it loads all of its data from the superview (dataholdingtabbarviewcontroller. Maybe this is a really bad way of doing this.)
class SearchTableViewController: UITableViewController, UISearchResultsUpdating {

    var cache = ImageLoadingWithCache()
   
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
        self.sellBookArray = tbvc.sellBookArray
        
        self.resultsSearchController = UISearchController(searchResultsController: nil)
        self.resultsSearchController.searchResultsUpdater = self
        
        self.resultsSearchController.dimsBackgroundDuringPresentation = false //true later
        
        self.resultsSearchController.searchBar.sizeToFit()
        self.resultsSearchController.searchBar.placeholder = "Search by: Title or Author or ISBN" // maybe no colon?
        //self.resultsSearchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        self.tableView.tableHeaderView = self.resultsSearchController.searchBar
        
        self.tableView.rowHeight = 105
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        navigationController?.hidesBarsOnSwipe = true

        
        resultsSearchController.searchBar.barTintColor = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        //resultsSearchController.searchBar.backgroundColor = UIColor(red: 129/255, green: 198/255, blue: 250/255, alpha: 1.0)
        self.tableView.reloadData()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            book = self.filteredSellBookArray[indexPath.row] as? Book
            
        }
        else{
            book = self.sellBookArray[indexPath.row] as? Book
        }

        // Configure the cell...
        
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
        else if(book!.bookStatus == "reserved")
        {
            cell.yearPublished.text = "reserved"
        }
        else if(book!.bookStatus == "deleted")
        {
            cell.yearPublished.text = "deleted" // should be elsewhere, before making the cell probably
            
        }
        
        cache.getImage(tempString, imageView: cell.mainImage, defaultImage: "noun_9280_cc")
        print("after getimage")

        
        
        return cell
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
                book = self.filteredSellBookArray[indexPath.row] as? Book
                cell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
                let image = cell!.mainImage.image
                vc.bookPicture = image
            }
            else{
                book = self.sellBookArray[indexPath.row] as? Book
                cell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
                let image = cell!.mainImage.image
                vc.bookPicture = image
            }
            vc.detailBook = book
            self.resultsSearchController.active = false
            
            //let tempBook = self.filteredSellBookArray
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}

