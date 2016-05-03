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
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet var genderPicker: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dormPicker: UIPickerView!
    
    var db : Database!
    var myUID : String = ""
    var picURL : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Database for this instance of the app
        db = Database(myUID: myUID, hasProfile: false, callback: {
            self.db.setProfilePic(self.picURL)
        })
        
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
        if section == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    // User taps this button when they are supposedly done filling out info
    @IBAction func userDone(sender: AnyObject) {
        
        // Check the non-optional information
        if firstName.text == "" || lastName.text == "" || phoneNumber.text == "" {
            let alert = UIAlertController(title: "Incomplete Form!", message: "Make sure to fill out all the info", preferredStyle: .Alert)
            
            let confirmAction = UIAlertAction(title: "Ok",
                                              style: .Default,
                                              handler: { (action:UIAlertAction) -> Void in
            })
            
            alert.addAction(confirmAction)
            
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            //Get the gender
            let genderIndex = self.genderPicker.selectedRowInComponent(0)
            let gender = Profile.Gender(rawValue: Profile.Gender.allValues[genderIndex])
            
            //Get the year
            let yearIndex = self.genderPicker.selectedRowInComponent(1)
            var year = Profile.Year(rawValue: Profile.Year.allValues[yearIndex])
            if year == nil {
                year = .Grad
            }
            
            let newProfile = Profile(firstName: firstName.text!, lastName: lastName.text!, gender: gender!, year: year!, phoneNumber: phoneNumber.text!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let strDate = dateFormatter.stringFromDate(datePicker.date)
            newProfile.dateOfBirth = strDate
            
            let dormIndex = self.dormPicker.selectedRowInComponent(0)
            let dorm = db.dorms[dormIndex]
            newProfile.dorm = dorm
            
            db.updateProfile(newProfile, call: {
                () in
                print("Added Profile to Database!")
                self.performSegueWithIdentifier("loginFromUserInfo", sender: self)
            })
            
        }
    }
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.isEqual(genderPicker) {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(genderPicker) {
            if component == 0 {
                return Profile.Gender.allValues.count
            } else {
                return Profile.Year.allValues.count
            }
        } else {
            return db.dorms.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(genderPicker) {
            if component == 0 {
                return Profile.Gender.allValues[row]
            } else {
                return Profile.Year.allValues[row]
            }
        } else {
            return db.dorms[row]
        }
    }
    
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
