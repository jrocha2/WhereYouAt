//
//  MenuTableViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/22/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    var db: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide any extra cells
        tableView.tableFooterView = UIView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Grab the database reference from the parent menu view controller
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if let parent = self.parentViewController as? MenuViewController {
            self.db = parent.db
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.performSegueWithIdentifier("currentFriends", sender: self)
        } else if indexPath.section == 0 && indexPath.row == 1 {
            self.performSegueWithIdentifier("addFriend", sender: self)
        } else if indexPath.section == 1 {
            self.performSegueWithIdentifier("updateProfile", sender: self)
        } else if indexPath.section == 2 {
            self.performSegueWithIdentifier("signOut", sender: self)
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? UpdateProfileTableViewController {
            dest.db = self.db
        } else if let dest = segue.destinationViewController as? CurrentFriendsViewController {
            dest.db = self.db
        } else if let dest = segue.destinationViewController as? UINavigationController {
            if let tab = dest.topViewController as? UITabBarController {
                if let first = tab.viewControllers![0] as? FindFriendsViewController {
                    first.db = self.db
                }
                if let second = tab.viewControllers![1] as? PendingFriendsTableViewController {
                    second.db = self.db
                }
            }
        }
    }

}
