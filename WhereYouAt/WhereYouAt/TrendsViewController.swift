//
//  TrendsViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/13/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class TrendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var db : Database!
    var locations : [Location] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Receive reference to database from tabbarcontroller
        let tabBar = self.tabBarController as! MainMenuTabBarController
        db = tabBar.db
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Receive updated locations everytime this view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        locations = db.getCampusTrends()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trendCell", forIndexPath: indexPath) as! TrendTableViewCell
        let row = indexPath.row
        let loc = locations[row]
        cell.numberOfPeopleLabel.text = String(loc.numberOfPeople)
        cell.locationNameLabel.text = "Going to " + loc.name
        
        return cell
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
