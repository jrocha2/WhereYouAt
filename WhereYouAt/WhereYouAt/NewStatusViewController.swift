//
//  NewStatusViewController.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/6/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import MapKit

class NewStatusViewController: UIViewController, MKMapViewDelegate {

    var db: Database!
    var location: Location!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var status: UITextField!
    @IBOutlet var charCount: UILabel!
    @IBOutlet var map: MKMapView!
    @IBOutlet var peopleHere: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.text = location.name
        charCount.text = "0/50"
        
        status.addTarget(self, action: #selector(NewStatusViewController.updateCharCount), forControlEvents: UIControlEvents.EditingChanged)

        self.map.delegate = self
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location.coordinate
        dropPin.title = location.name
        let region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        map.addAnnotation(dropPin)
        map.region = region
        peopleHere.text = "\(location.numberOfPeople) People Here"
    }
    
    func updateCharCount() {
        charCount.text = "\(status.text!.characters.count)/50"
    }

    @IBAction func submitStatus(sender: UIBarButtonItem) {
        let s = Status(userId: db.profile!.userId!, userName: db.profile!.name, body: status.text!)
        db.createNewStatus(s, locationId: location.locationId!, callback: {
            () in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
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
