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
    var users : [(String, String)] = []
    var friends : [(String, String)] = []
    
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
        for user in db.allUsers {
            users.append( (user.0, user.1) )
        }
        
        friends.removeAll()
        for friend in db.friendsList {
            friends.append( (friend.0, friend.1) )
        }
        
        // Remove all friends from the list
        var actualUsers = [(String, String)]()
        for i in 0...users.count-1 {
            if !friends.contains( { $0.0 == users[i].0 && $0.1 == users[i].1 } ) && users[i].0 != db.userId {
                actualUsers.append(users[i])
            }
        }
        users = actualUsers
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
        let row = indexPath.row
        
        cell.textLabel?.text = users[row].1
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        if !friends.contains({ $0.0 == users[row].0 && $0.1 == users[row].1 }) && users[row].0 != db.userId {
            let alert = UIAlertController(title: "Send Friend Request?", message: "Are you sure you would like to send \(users[indexPath.row].1) a friend request?", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Send Request", style: .Default, handler: { (action:UIAlertAction) -> Void in
                self.db.sendFriendRequest(self.users[row].0, name: self.users[row].1)
                self.users.removeAtIndex(row)
                self.tableView.reloadData()
                self.db.getPendingFriends()
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
