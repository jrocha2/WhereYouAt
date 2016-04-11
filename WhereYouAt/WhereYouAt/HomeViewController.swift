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
        
        // Do any additional setup after loading the view.
        db.firebase.getProfile(myUID, callback: {
            (profile) in
            self.name.text = profile.name
            self.db.firebase.myName = profile.name
            self.db.firebase.respondToFriendRequest("106842413723936243580", userName: "Test Friend", acceptRequest: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createStatus" {
            let navController = segue.destinationViewController as! UINavigationController
            let dest = navController.topViewController as! LocationsTableViewController
            dest.db = self.db
        }
        
    }
 

}
