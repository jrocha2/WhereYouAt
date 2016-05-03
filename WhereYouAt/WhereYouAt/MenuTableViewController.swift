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
