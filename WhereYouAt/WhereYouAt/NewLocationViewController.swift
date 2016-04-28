//
//  NewLocationViewController.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/9/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import MapKit

class NewLocationViewController: UIViewController, MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var locationTypePicker: UIPickerView!
    @IBOutlet var locationName: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var addressError: UILabel!
    @IBOutlet var map: MKMapView!
    @IBAction func checkAddress(sender: UIButton) {
        let _ = LocationFinder(address: address.text!) {
            (finder) in
            if finder.error == true {
                self.addressError.text = "No address results found"
            } else {
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = finder.coordinate
                dropPin.title = self.locationName.text
                let region = MKCoordinateRegionMake(finder.coordinate, MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                self.map.addAnnotation(dropPin)
                self.map.setRegion(region, animated: true)
                
                let index = self.locationTypePicker?.selectedRowInComponent(0)
                let type = LocationType(rawValue: LocationType.allValues[index!])!
                self.location = Location(locationName: self.locationName.text!, locationType: type, latitude: finder.latitude, longitude: finder.longitude)
                self.addressError.text = ""
                self.checkedAddress = true
            }
        }
    }
    
    @IBAction func saveLocation(sender: UIBarButtonItem) {
        if locationName.text == "" {
            addressError.text = "Enter the name of your new location!"
        } else if checkedAddress == true {
            print("Saving location \(location?.fbDescription)")
            db.createNewLocation(location!, callback: {
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        } else {
            addressError.text = "You must check the address before you save the location!"
        }
    }
    
    var checkedAddress = false
    var db: Database!
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressError.text = ""
        
        self.map.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }

    // MARK: - UIPickerViewDataSource
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LocationType.allValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return LocationType.allValues[row]
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
