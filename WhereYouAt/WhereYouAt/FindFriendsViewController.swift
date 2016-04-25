//
//  FindFriendsViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/25/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate {

    var db : Database!
    var users : [(String, String)] = []
    var filteredUsers : [(String, String)] = []
    var friends : [(String, String)] = []
    var pendingFriends : [(String, String)] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Make sure the database is up to date
        db.getFriends()
        db.getPendingFriends()
        db.getAllUsers()
        
        users.removeAll()
        for user in db.allUsers {
            users.append( (user.0, user.1) )
        }
        
        friends.removeAll()
        for friend in db.friendsList {
            friends.append( (friend.0, friend.1) )
        }
        
        pendingFriends.removeAll()
        for user in db.friendsPending {
            pendingFriends.append( (user.0, user.1) )
        }
        
        // Remove all friends from the list
        var actualUsers = [(String, String)]()
        for i in 0...users.count-1 {
            if !friends.contains( { $0.0 == users[i].0 && $0.1 == users[i].1 } ) && users[i].0 != db.userId && !pendingFriends.contains( { $0.0 == users[i].0 && $0.1 == users[i].1 } ) {
                actualUsers.append(users[i])
            }
        }
        users = actualUsers
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
        let row = indexPath.row
        
        if searchController.active && searchController.searchBar.text != "" {
            cell.textLabel?.text = filteredUsers[row].1
        } else {
            cell.textLabel?.text = users[row].1
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        if searchController.active && searchController.searchBar.text != "" {
            
            let alert = UIAlertController(title: "Send Friend Request?", message: "Are you sure you would like to send \(filteredUsers[indexPath.row].1) a friend request?", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Send Request", style: .Default, handler: { (action:UIAlertAction) -> Void in
                self.db.sendFriendRequest(self.filteredUsers[row].0, name: self.filteredUsers[row].1)
                self.removeUIDFromUsers(self.filteredUsers[row].0)
                self.filteredUsers.removeAtIndex(row)
                self.db.getPendingFriends()
                self.tableView.reloadData()
            })
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .Default,
                                             handler: { (action:UIAlertAction) -> Void in
            })
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            presentViewController(alert, animated: true, completion: nil)
        
        } else {
    
            let alert = UIAlertController(title: "Send Friend Request?", message: "Are you sure you would like to send \(users[indexPath.row].1) a friend request?", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Send Request", style: .Default, handler: { (action:UIAlertAction) -> Void in
                self.db.sendFriendRequest(self.users[row].0, name: self.users[row].1)
                self.users.removeAtIndex(row)
                self.db.getPendingFriends()
                 self.tableView.reloadData()
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

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredUsers = users.filter { user in
            return user.1.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func removeUIDFromUsers(uid: String) {
        for i in 0...users.count-1 {
            if users[i].0 == uid {
                users.removeAtIndex(i)
                return
            }
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

extension FindFriendsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
