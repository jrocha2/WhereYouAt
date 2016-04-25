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
        db.getFriends()
        for friend in db.friendsList {
            friends.append(friend.1)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
