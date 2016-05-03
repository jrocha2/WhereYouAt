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
    let maxCharacters = 50
    
    @IBOutlet var name: UILabel!
    @IBOutlet var status: UITextField!
    @IBOutlet var charCount: UILabel!
    @IBOutlet var map: MKMapView!
    @IBOutlet var peopleHere: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        name.text = location.name
        charCount.text = "0/\(maxCharacters)"
        
        status.addTarget(self, action: #selector(NewStatusViewController.updateCharCount), forControlEvents: UIControlEvents.EditingChanged)
        
        let placeholder = NSAttributedString(string: "Tell your friends about \(location.name)!")
        status.attributedPlaceholder = placeholder

        self.map.delegate = self
        let region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        let annotation = LocationAnnotation(loc: location)
        map.addAnnotation(annotation)
        map.selectAnnotation(annotation, animated: true)
        map.region = region
        if location.numberOfPeople == 1 {
            peopleHere.text = "\(location.numberOfPeople) Person Here"
        } else {
            peopleHere.text = "\(location.numberOfPeople) People Here"
        }
    }
    
    func updateCharCount() {
        charCount.text = "\(status.text!.characters.count)/\(maxCharacters)"
        if status.text!.characters.count > maxCharacters {
            charCount.textColor = UIColor.redColor()
        } else {
            charCount.textColor = UIColor.blackColor()
        }
    }

    @IBAction func submitStatus(sender: UIBarButtonItem) {
        var s: Status
        if let text = status.text {
            s = Status(userId: db.profile!.userId!, profile: db.profile!, body: text)
        } else {
            s = Status(userId: db.profile!.userId!, profile: db.profile!, body: "")
        }
        
        if status.text!.characters.count > maxCharacters {
            print("Too many characters")
            charCount.text = "\(status.text!.characters.count)/\(maxCharacters) Too many characters"
        } else {
            db.createNewStatus(s, locationId: location.locationId!, callback: {
                () in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? LocationAnnotation {
            let identifier = "locationMarker"
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            
            // Images from https://icons8.com/
            switch annotation.locationType {
            case .Apartment:
                view.image = UIImage(named: "housePin")
            case .Bar:
                view.image = UIImage(named: "barPin")
            case .Club:
                view.image = UIImage(named: "clubPin")
            case .Dorm:
                view.image = UIImage(named: "dormPin")
            case .House:
                view.image = UIImage(named: "homePin")
            case .OutOfTown:
                view.image = UIImage(named: "outoftownPin")
            case .Rave:
                view.image = UIImage(named: "ravePin")
            case .Tailgate:
                view.image = UIImage(named: "tailgatePin")
            }
            
            return view
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
