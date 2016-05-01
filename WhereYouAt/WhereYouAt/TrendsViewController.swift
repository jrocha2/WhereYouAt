//
//  TrendsViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/13/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import ChameleonFramework

class TrendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var db : Database!
    var locations : [Location] = []
    var filteredLocations : [Location] = []
    let searchController = UISearchController(searchResultsController: nil)
    var selectedScope = "All"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Receive reference to database from tabbarcontroller
        let tabBar = self.tabBarController as! MainMenuTabBarController
        db = tabBar.db
        
        updateTableView()
        filteredLocations = locations
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Whenever the new location data received, call a function to update table
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateTableView), name: newLocationDataNotification, object: nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "Bar", "House", "Dorm"]
        searchController.searchBar.delegate = self
        
        // Somewhat keep the scope consistent
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!], forState: UIControlState.Normal)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName: UIColor.flatMintColorDark(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!], forState: UIControlState.Selected)
    }
    
    deinit {
        self.searchController.loadViewIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Receive updated locations everytime this view appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateTableView()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( searchController.active ) {
            return filteredLocations.count
        } else {
            return locations.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trendCell", forIndexPath: indexPath) as! TrendTableViewCell
        let row = indexPath.row
        let loc = filteredLocations[row]
        cell.numberOfPeopleLabel.text = String(loc.numberOfPeople)
        cell.locationNameLabel.text = "Going to " + loc.name
        switch loc.type {
            case .Apartment:
            cell.typeImage.image = UIImage(named: "housePin")
            case .Bar:
            cell.typeImage.image = UIImage(named: "barPin")
            case .Club:
            cell.typeImage.image = UIImage(named: "clubPin")
            case .Dorm:
            cell.typeImage.image = UIImage(named: "dormPin")
            case .House:
            cell.typeImage.image = UIImage(named: "homePin")
            case .OutOfTown:
            cell.typeImage.image = UIImage(named: "outoftownPin")
            case .Rave:
            cell.typeImage.image = UIImage(named: "ravePin")
            case .Tailgate:
            cell.typeImage.image = UIImage(named: "tailgatePin")
        }
        
        return cell
    }
    
    func updateTableView() {
        locations = db.getCampusTrends()
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar(self.searchController.searchBar, selectedScopeButtonIndexDidChange: 0)
    }
    
    // Returns to unfiltered before exiting to avoid seg fault
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar(self.searchController.searchBar, selectedScopeButtonIndexDidChange: 0)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredLocations.removeAll()
        filteredLocations = locations.filter { location in
            let scope2 = self.selectedScope
            var correctType: Bool = false
            if(scope2 == "All") { correctType = true }
            else if(scope2 == "Bar" && location.type == .Bar) { correctType = true }
            else if(scope2 == "Dorm" && location.type == .Dorm) { correctType = true }
            else if(scope2 == "House" && location.type == .House) { correctType = true }
            
            let blankMatch = (searchText == "")
            
            let nameMatch = location.name.lowercaseString.containsString(searchText.lowercaseString)
            
            return correctType && (blankMatch || nameMatch)
        }
        
        tableView.reloadData()
        
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

extension TrendsViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension TrendsViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.selectedScope = searchBar.scopeButtonTitles![selectedScope]
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}