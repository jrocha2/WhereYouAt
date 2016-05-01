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
        
        let tabBar = self.tabBarController?.tabBar
        
        // Setup tab bar color scheme
        tabBar!.tintColor = UIColor.whiteColor()
        tabBar!.barTintColor = UIColor.flatBlueColor()
        
        tabBar!.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.flatMintColor(), size: CGSizeMake(tabBar!.frame.width/CGFloat(tabBar!.items!.count), tabBar!.frame.height))
        for item in tabBar!.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Make sure the database is up to date
        db.getFriends({
            self.db.getPendingFriends({
                self.db.getAllUsers({
                    self.users.removeAll()
                    for user in self.db.allUsers {
                        self.users.append( (user.0, user.1) )
                    }
                    
                    self.friends.removeAll()
                    for friend in self.db.friendsList {
                        self.friends.append( (friend.0, friend.1) )
                    }
                    
                    self.pendingFriends.removeAll()
                    for user in self.db.friendsPending {
                        self.pendingFriends.append( (user.0, user.1) )
                    }
                    
                    // Remove all friends from the list
                    var actualUsers = [(String, String)]()
                    for i in 0...self.users.count-1 {
                        if !self.friends.contains( { $0.0 == self.users[i].0 && $0.1 == self.users[i].1 } ) && self.users[i].0 != self.db.userId && !self.pendingFriends.contains( { $0.0 == self.users[i].0 && $0.1 == self.users[i].1 } ) {
                            actualUsers.append(self.users[i])
                        }
                    }
                    self.users = actualUsers
                    self.tableView.reloadData()
                })
            })
        })
        
    }
    
    deinit {
        self.searchController.loadViewIfNeeded()
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
                self.db.getPendingFriends({
                    self.tableView.reloadData()
                })
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
                self.db.getPendingFriends({
                    self.tableView.reloadData()
                })
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
