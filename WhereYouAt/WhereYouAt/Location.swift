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
    var locationId: String?
    var name: String
    var type: LocationType
    var latitude: CLLocationDegrees //CLLocationDegrees is a type alias for Double
    var longitude: CLLocationDegrees
    var statuses: [Status] = []
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude);
    }
    
    var numberOfPeople: Int {
        return statuses.count
    }
    
    var fbDescription: [String:AnyObject] {
        return ["Info": ["latitude": self.latitude, "longitude": self.longitude, "name": self.name, "type": String(type)]]
    }
    
    var description: String {
        return "\(locationId!): \(name) - \(statuses)"
    }
    
    func setLocationId(id: String) {
        self.locationId = id
    }
    
    func addStatuses(statuses: [Status]) {
        self.statuses = statuses
    }
    
    init(locationName: String, locationType: LocationType, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.name = locationName
        self.type = locationType
        self.latitude = latitude
        self.longitude = longitude
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