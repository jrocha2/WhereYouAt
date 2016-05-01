//
//  LocationsTableViewController.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/6/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    var db: Database!
    var locations: [Location] = []
    var filteredLocations: [Location] = []
    let searchController = UISearchController(searchResultsController: nil)
    var selectedScope = "All"
    
    @IBAction func cancelPost(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        locations = db.locations
        locations.sortInPlace({$0.name < $1.name})
        filteredLocations = locations
        
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "Bar", "House", "Dorm"]
        searchController.searchBar.delegate = self
        
        // Somewhat keep the scope consistent
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!], forState: UIControlState.Normal)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSForegroundColorAttributeName: UIColor.flatMintColorDark(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!], forState: UIControlState.Selected)
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.reloadData()
    }
    
    deinit {
        self.searchController.loadViewIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Returns to unfiltered before exiting to avoid seg fault
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar(self.searchController.searchBar, selectedScopeButtonIndexDidChange: 0)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if( searchController.active ) {
            return filteredLocations.count
        } else {
            return locations.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! LocationTableViewCell

        let loc = filteredLocations[indexPath.row]
        cell.locationName.text = loc.name
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destinationViewController as? NewStatusViewController,
            cell = sender as? LocationTableViewCell,
            indexPath = self.tableView.indexPathForCell(cell) {
            dest.db = self.db
            dest.location = self.locations[indexPath.row]
        }
        if let dest = segue.destinationViewController as? NewLocationViewController {
            dest.db = self.db
        }
    }

}

extension LocationsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension LocationsTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.selectedScope = searchBar.scopeButtonTitles![selectedScope]
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
