//
//  UpdateProfileTableViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/24/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit

class UpdateProfileTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var db: Database!
    var dorms = ["Alumni",
        "Badin",
        "Breen-Phillips",
        "Carroll",
        "Cavanaugh",
        "Dillon",
        "Duncan",
        "Farley",
        "Fisher",
        "Howard",
        "Keenan",
        "Keough",
        "Knott",
        "Lewis",
        "Lyons",
        "McGlinn",
        "Morrissey",
        "O’Neill",
        "Pangborn",
        "Pasquerilla East",
        "Pasquerilla West",
        "Ryan",
        "Saint Edward’s",
        "Siegfried",
        "Sorin",
        "Stanford",
        "Walsh",
        "Welsh Family",
        "Zahm"]
    
    @IBOutlet var genderPicker: UIPickerView!
    @IBOutlet var classPicker: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dormPicker: UIPickerView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Place their current profile information into the text boxes
        let profile = db.profile
        firstName.text = profile?.firstName
        lastName.text = profile?.lastName
        
        var g: Int
        switch profile!.gender {
        case .Male: g = 0
        case .Female: g = 1
        }
        
        var c: Int
        switch profile!.year {
        case .Freshman: c = 0
        case .Sophomore: c = 1
        case .Junior: c = 2
        case .Senior: c = 3
        case .Grad: c = 4
        }
        genderPicker.selectRow(g, inComponent: 0, animated: false)
        classPicker.selectRow(c, inComponent: 0, animated: false)
        phoneNumber.text = profile?.phone

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.dateFromString((profile?.dateOfBirth)!)
        datePicker.date = date!
        
        var d: Int = 0
        if let i = dorms.indexOf({$0 == profile?.dorm}) {
             d = i
        }
        dormPicker.selectRow(d, inComponent: 0, animated: false)
        
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
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(genderPicker) {
            return Profile.Gender.allValues.count
        } else if pickerView.isEqual(dormPicker) {
            return dorms.count
        } else {
            return Profile.Year.allValues.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.isEqual(genderPicker) {
            return Profile.Gender.allValues[row]
        } else if pickerView.isEqual(dormPicker) {
            return dorms[row]
        } else {
            return Profile.Year.allValues[row]
        }
    }
    
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
            let yearIndex = self.classPicker.selectedRowInComponent(0)
            let year = Profile.Year(rawValue: Profile.Year.allValues[yearIndex])
            
            let newProfile = Profile(firstName: firstName.text!, lastName: lastName.text!, gender: gender!, year: year!, phoneNumber: phoneNumber.text!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let strDate = dateFormatter.stringFromDate(datePicker.date)
            newProfile.dateOfBirth = strDate
            
            let dormIndex = self.dormPicker.selectedRowInComponent(0)
            let dorm = dorms[dormIndex]
            newProfile.dorm = dorm
            
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
