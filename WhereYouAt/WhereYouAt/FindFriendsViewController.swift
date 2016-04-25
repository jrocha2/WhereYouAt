//
//  FindFriendsViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/25/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var db : Database!
    var users : [String] = []
    var correspondingUIDs : [String] = []
    var friendUIDS : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Make sure the database is up to date
        db.getFriends()
        db.getAllUsers()
        users.removeAll()
        correspondingUIDs.removeAll()
        for user in db.allUsers {
            correspondingUIDs.append(user.0)
            users.append(user.1)
        }
        
        friendUIDS.removeAll()
        for friend in db.friendsList {
            friendUIDS.append(friend.0)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
        let row = indexPath.row
        
        // Place a check if they are already your friend
        if friendUIDS.contains(correspondingUIDs[row]) || correspondingUIDs[row] == db.userId {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        cell.textLabel?.text = users[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if !friendUIDS.contains(correspondingUIDs[indexPath.row]) {
            let alert = UIAlertController(title: "Send Friend Request?", message: "Are you sure you would like to send \(users[indexPath.row]) a friend request?", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Send Request", style: .Default, handler: { (action:UIAlertAction) -> Void in
                self.db.sendFriendRequest(self.correspondingUIDs[indexPath.row], name: self.users[indexPath.row])
            })
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                              style: .Default,
                                              handler: { (action:UIAlertAction) -> Void in
            })
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
