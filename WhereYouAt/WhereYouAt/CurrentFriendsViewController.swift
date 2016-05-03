//
//  CurrentFriendsViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/24/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class CurrentFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var db : Database!
    var friends : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload the friends in the database to ensure they are up to date
        db.getFriends({
            self.friends.removeAll()
            for friend in self.db.friendsList {
                self.friends.append(friend.1)
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
        let row = indexPath.row
        
        cell.textLabel?.text = friends[row]
        return cell
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("unwindFromCurrentFriends", sender: self)
    }

    // Hide status bar due to weird tableview
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
