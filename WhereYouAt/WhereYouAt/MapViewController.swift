//
//  MapViewController.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/13/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var db : Database!
    var locations : [Location] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Check for access to user location and center map on ND
        checkLocationAuthorizationStatus()
        centerMapOnLocation(CLLocation(latitude: 41.701584, longitude: -86.236536), width: 5500, height: 5500)
        mapView.showsUserLocation = true
        
        let tabBar = self.tabBarController as! MainMenuTabBarController
        self.db = tabBar.db
        updateMapPins()
        
        // Add observer to call updatePins whenever new data present
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateMapPins), name: newLocationDataNotification, object: nil)
    }
    
    // Checks that user has authorized location tracking
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
            checkLocationAuthorizationStatus()
        }
    }
    
    // Centers the map on a given coordinate with provided map width and height
    func centerMapOnLocation(location: CLLocation, width: CLLocationDistance, height: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, width, height)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func updateMapPins() {
        locations = db.getCampusTrends()
        for loc in locations {
            mapView.addAnnotation(LocationAnnotation(loc: loc))
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
}
