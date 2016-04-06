//
//  Location.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation
import CoreLocation

class Location: CustomStringConvertible {
    var locationId: String
    var name: String
    var type: LocationType
    var latitude: CLLocationDegrees //CLLocationDegrees is a type alias for Double
    var longitude: CLLocationDegrees
    var location: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude);
    }
    
    var description: String {
        return "\(name) - \(type)"
    }
    
    init(locationId: String, locationName: String, locationType: LocationType, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.locationId = locationId
        self.name = locationName
        self.type = locationType
        self.latitude = latitude
        self.longitude = longitude
    }
}

enum LocationType: String {
    case Bar
    case House
    case Dorm
    case Club
    case Tailgate
    case Apartment
    case Rave
    case OutOfTown
}