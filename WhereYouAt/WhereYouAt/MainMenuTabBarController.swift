//
//  MainMenuTabBarController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/12/16.
//  Copyright © 2016 Where You At. All rights reserved.
//
//  Subclass of UITabBarController to maintain a common database accessible by all the tabs

import UIKit

class MainMenuTabBarController: UITabBarController {

    var db : Database!
    var myUID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.showMenu))
        swipe.edges = .Left
        self.view.addGestureRecognizer(swipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMenu() {
        performSegueWithIdentifier("showMenu", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createStatus" {
            if let navController = segue.destinationViewController as? UINavigationController {
                if let dest = navController.topViewController as? LocationsTableViewController {
                    dest.db = self.db
                }
            }
        }
    }
 

}
