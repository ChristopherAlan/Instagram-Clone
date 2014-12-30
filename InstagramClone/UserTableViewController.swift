//
//  UserTableViewController.swift
//  InstagramClone
//
//  Created by Christopher Alan on 12/24/14.
//  Copyright (c) 2014 CA Studios. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users = [String]()
    var following = [Bool]()
    var refresh = UIRefreshControl()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUsers()
        
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: "refreshed", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updateUsers() {
        
        var query = PFUser.query()
        //query.whereKey("gender", equalTo:"female")
        //var girls = query.findObjects()
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.users.removeAll(keepCapacity: true)
            for object in objects {
                
                var user:PFUser = object as PFUser
                var isFollowing:Bool
                
                if user.username != PFUser.currentUser().username { // dont show logged-in user
                    
                    self.users.append(user.username)
                    
                    isFollowing = false
                    
                    // Check to see if the user is followign other users on login.
                    var query = PFQuery(className:"followers")
                    query.whereKey("follower", equalTo:PFUser.currentUser().username)
                    query.whereKey("following", equalTo:user.username)
                    
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            // The find succeeded.
                            // Do something with the found objects
                            for object in objects {
                                
                                isFollowing = true
                                
                            }
                            
                            self.following.append(isFollowing)
                            self.tableView.reloadData() // fine for a small # of users but inefficient
                            
                        } else {
                            // Log details of the failure
                            println(error)
                        }
                        
                        self.refresh.endRefreshing()
                    }
                }
                
            }
            
        })

    }
    
    func refreshed() {
        println("refreshed")
        updateUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if following.count > indexPath.row {
        if following[indexPath.row] == true {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        }
        }
        cell.textLabel?.text = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
        
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo:PFUser.currentUser().username)
            query.whereKey("following", equalTo:cell.textLabel?.text)
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    for object in objects {
                        
                        object.deleteInBackgroundWithTarget(nil, selector: nil)
                       
                    }
                } else {
                    // Log details of the failure
                    println(error)
                }
            }
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            //create a connection for users to follow/unfollow in the parse class created.
            var following = PFObject(className: "followers")
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            
            following.saveInBackgroundWithTarget(nil, selector: nil)
            
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
