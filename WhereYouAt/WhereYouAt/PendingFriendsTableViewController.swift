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
        db.getPendingFriends({
            self.db.getFriendRequests({
                self.requests.removeAll()
                self.correspondingUIDs.removeAll()
                for user in self.db.friendRequests {
                    self.requests.append(user.1)
                    self.correspondingUIDs.append(user.0)
                }
                
                self.pending.removeAll()
                for user in self.db.friendsPending {
                    self.pending.append(user.1)
                }
                self.tableView.reloadData()
            })
        })
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
        } else if section == 1{
            return pending.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Friend Requests"
        } else {
            return "Pending Requests"
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
                self.db.getFriendRequests({
                    self.db.getPendingFriends({
                        self.db.getFriends({
                            self.pending.removeAll()
                            self.requests.removeAll()
                            for friend in self.db.friendsPending {
                                self.pending.append(friend.1)
                            }
                            for friend in self.db.friendRequests {
                                self.requests.append(friend.1)
                            }
                            self.tableView.reloadData()
                        })
                    })
                })
            })
            
            let denyAction = UIAlertAction(title: "Delete Request", style: .Default, handler: { (action:UIAlertAction) -> Void in
                self.db.respondToFriendRequest(self.correspondingUIDs[row], name: self.requests[row], accept: false)
                self.requests.removeAtIndex(row)
                self.correspondingUIDs.removeAtIndex(row)
                self.db.getFriendRequests({
                    self.tableView.reloadData()
                })
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

}
