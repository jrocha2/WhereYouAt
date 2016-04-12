//
//  HomeViewController.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/6/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var myUID: String = ""
    var db: Database!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
