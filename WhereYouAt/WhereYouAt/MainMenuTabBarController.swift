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
        
        db = Database(myUID: self.myUID, hasProfile: true)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
