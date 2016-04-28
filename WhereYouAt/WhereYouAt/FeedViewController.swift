//
//  FeedViewController.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/6/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var myUID: String = ""
    var db: Database!
    var friendStatuses : [Status] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Database(myUID: self.myUID, hasProfile: true, callback: {
            // Store the reference to db in the tabbarcontroller so the other tabs
            // may share the instance without having to pass it around
            
            // Do any additional setup after loading the view.
            self.db.firebase.getProfile(self.myUID, callback: {_ in })
            
            self.tableView.dataSource = self
            self.tableView.delegate = self
            // Whenever the new location data received, call a function to update table
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateTableView), name: newLocationDataNotification, object: nil)
            self.updateTableView()
        })
        let tabBar = self.tabBarController as! MainMenuTabBarController
        tabBar.db = self.db
        
    }
    
    // Update friend statuses everytime the view appears
    override func viewWillAppear(animated: Bool) {
        updateTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendStatuses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FeedTableViewCell
        let row = indexPath.row
        let status = friendStatuses[row]
        // Need to edit data hierarchy somewhere so we have access to location name here too
        cell.nameLabel.text = status.userName
        cell.statusLabel.text = status.body
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE 'at' h:mm a"
        let date = NSDate(timeIntervalSince1970: status.timestamp!)
        cell.timeLabel.text = formatter.stringFromDate(date)
        cell.locationLabel.text = status.location?.name
        
        return cell
    }
    
    func updateTableView() {
        db.getFriendStatuses { (friends) in
            self.friendStatuses = friends
            self.tableView.reloadData()
        }
    }
}
