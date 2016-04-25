//
//  PendingFriendsTableViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/25/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class PendingFriendsTableViewController: UITableViewController {

    var db : Database!
    var pending : [String] = []
    var requests : [String] = []
    var correspondingUIDs : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "textCell")


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Make sure pending and requests are up to date
        db.getPendingFriends()
        db.getFriendRequests()
        
        requests.removeAll()
        correspondingUIDs.removeAll()
        for user in db.friendRequests {
            requests.append(user.1)
            correspondingUIDs.append(user.0)
        }
        
        pending.removeAll()
        for user in db.friendsPending {
            pending.append(user.1)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return requests.count
        } else {
            return pending.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)

        let row = indexPath.row
        if indexPath.section == 0 {
            cell.textLabel?.text = requests[row]
        } else {
            cell.textLabel?.text = pending[row]
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        if indexPath.section == 0 {
            let alert = UIAlertController(title: "Accept Friend Request?", message: "Would you like to add \(requests[indexPath.row]) to your friends list?", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Add Friend", style: .Default, handler: { (action:UIAlertAction) -> Void in
                self.db.respondToFriendRequest(self.correspondingUIDs[row], name: self.requests[row], accept: true)
                self.requests.removeAtIndex(row)
                self.correspondingUIDs.removeAtIndex(row)
                self.tableView.reloadData()
                self.db.getFriendRequests()
            })
            
            let denyAction = UIAlertAction(title: "Delete Request", style: .Default, handler: { (action:UIAlertAction) -> Void in
                self.db.respondToFriendRequest(self.correspondingUIDs[row], name: self.requests[row], accept: false)
                self.requests.removeAtIndex(row)
                self.correspondingUIDs.removeAtIndex(row)
                self.tableView.reloadData()
                self.db.getFriendRequests()

            })
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .Default,
                                             handler: { (action:UIAlertAction) -> Void in
            })
            
            alert.addAction(confirmAction)
            alert.addAction(denyAction)
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
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
