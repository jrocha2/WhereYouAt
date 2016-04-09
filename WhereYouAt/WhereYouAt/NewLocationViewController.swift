//
//  NewLocationViewController.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/9/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import MapKit

class NewLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var locationName: UITextField!
    @IBOutlet var locationType: UITextField!
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
                
                self.location = Location(locationName: self.locationName.text!, locationType: LocationType(rawValue: self.locationType.text!)!, latitude: finder.latitude, longitude: finder.longitude)
                self.addressError.text = ""
                self.checkedAddress = true
            }
        }
    }
    @IBAction func saveLocation(sender: UIButton) {
        if checkedAddress == true {
            print("Saving location \(location)")
        } else {
            addressError.text = "You must check the address before you save the location"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
