//
//  LocationAnnotation.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/13/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let locationType : LocationType
    
    init(loc: Location) {
        self.title = loc.name
        self.subtitle = "\(loc.numberOfPeople) people currently here"
        self.coordinate = loc.coordinate
        self.locationType = loc.type
        
        super.init()
    }
}
