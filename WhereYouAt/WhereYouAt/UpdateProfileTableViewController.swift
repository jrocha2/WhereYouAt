//
//  UpdateProfileTableViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/24/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class UpdateProfileTableViewController: UITableViewController {
    
    var db: Database!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var classification: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var dorm: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Place their current profile information into the text boxes
        let profile = db.profile
        firstName.text = profile?.firstName
        lastName.text = profile?.lastName
        gender.text = profile?.gender.rawValue
        classification.text = profile?.year.rawValue
        phoneNumber.text = profile?.phone
        if profile?.dateOfBirth != nil {
            dateOfBirth.text = profile?.dateOfBirth
        }
        if profile?.dorm != nil {
            dorm.text = profile?.dorm
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 8
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 0
        } else {
            return 1
        }
    }
    
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
                print("Updated Profile in Database!")
                self.performSegueWithIdentifier("unwindFromUpdateProfile", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
