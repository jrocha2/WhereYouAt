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
        centerMapOnLocation(CLLocation(latitude: 41.701584, longitude: -86.236536), width: 5000, height: 5000)
        mapView.showsUserLocation = true
        
        let tabBar = self.tabBarController as! MainMenuTabBarController
        self.db = tabBar.db
        locations = db.getCampusTrends()
        for loc in locations {
            let ann = MKPointAnnotation()
            ann.coordinate = loc.coordinate
            mapView.addAnnotation(ann)
        }
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
    

    

}
