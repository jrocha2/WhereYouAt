//
//  NewLocationAnnotation.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/28/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import UIKit
import MapKit

class NewLocationAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let locationType : LocationType
    
    init(name: String, type: LocationType, coordinate: CLLocationCoordinate2D) {
        self.title = name
        self.subtitle = ""
        self.coordinate = coordinate
        self.locationType = type
        
        super.init()
    }
}