//
//  NewUserTableViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/5/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class NewUserTableViewController: UITableViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var classification: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var dorm: UITextField!
    var db : Database!
    var myUID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Database for this instance of the app
        db = Database(myUID: myUID, hasProfile: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // User taps this button when they are supposedly done filling out info
    @IBAction func userDone(sender: AnyObject) {
        
        // Check the non-optional information
        if firstName.text == "" || lastName.text == "" || gender.text == "" || classification.text == "" || phoneNumber.text == "" {
            let alert = UIAlertController(title: "Incomplete Form!", message: "Make sure to fill out all the info that is not marked as optional", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Ok",
                                              style: .Default,
                                              handler: { (action:UIAlertAction) -> Void in
            })
            
            alert.addAction(confirmAction)
            
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let newProfile = Profile(firstName: firstName.text!, lastName: lastName.text!, gender: Profile.Gender(rawValue: gender.text!)!, year: Profile.Year(rawValue: classification.text!)!, phoneNumber: phoneNumber.text!)
            if dateOfBirth.text != "" {
                newProfile.dateOfBirth = dateOfBirth.text
            }
            if dorm.text != "" {
                newProfile.dorm = dorm.text
            }
            
            db.updateProfile(newProfile, call: {
                () in
                print("Added Profile to Database!")
                self.performSegueWithIdentifier("loginFromUserInfo", sender: self)
            })
            
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destinationViewController as? UINavigationController {
            if let tab = dest.topViewController as? MainMenuTabBarController {
                if let first = tab.viewControllers![0] as? FeedViewController {
                    first.myUID = self.myUID
                }
            }
        }
    }
 

}
