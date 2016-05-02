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
        //********** This is good for deployment, but for dev it is not good ***********
        var uniquePeople = Set<String>()
        for status in statuses {
            let duration = -1 * NSDate(timeIntervalSince1970: status.timestamp!).timeIntervalSinceDate(NSDate())
            let maxDuration: Double = 86400
            if(duration < maxDuration) {
                uniquePeople.insert(status.userId)
            }
        }
        return uniquePeople.count
        //return statuses.count
    }
    
    var fbDescription: [String:AnyObject] {
        return ["Info": ["latitude": self.latitude, "longitude": self.longitude, "name": self.name, "type": String(type)]]
    }
    
    var description: String {
        return "\(name): \(numberOfPeople) people here"
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
    case Bar = "Bar"
    case House = "House"
    case Dorm = "Dorm"
    case Club = "Club"
    case Tailgate = "Tailgate"
    case Apartment = "Apartment"
    case Rave = "Rave"
    case OutOfTown = "Out Of Town"
    
    static let allValues = ["Bar", "House", "Dorm", "Club", "Tailgate", "Apartment", "Rave", "Out Of Town"]
}