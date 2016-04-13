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
        
        db = Database(myUID: self.myUID, hasProfile: true)
        
        // Store the reference to db in the tabbarcontroller so the other tabs
        // may share the instance without having to pass it around
        let tabBar = self.tabBarController as! MainMenuTabBarController
        tabBar.db = self.db
        
        // Do any additional setup after loading the view.
        db.firebase.getProfile(myUID, callback: {
            (profile) in
            self.db.firebase.myName = profile.name
        })
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Whenever the new location data received, call a function to update table
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateTableView), name: newLocationDataNotification, object: nil)
    }
    
    // Update friend statuses everytime the view appears
    override func viewWillAppear(animated: Bool) {
        friendStatuses = db.getFriendStatuses()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell")! as UITableViewCell
        let row = indexPath.row
        let status = friendStatuses[row]
        cell.textLabel?.text = status.userName + " " + status.body
        
        return cell
    }
    
    func updateTableView() {
        friendStatuses = db.getFriendStatuses()
        tableView.reloadData()
    }
}
