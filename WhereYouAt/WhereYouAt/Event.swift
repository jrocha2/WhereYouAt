//
//  Event.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation

class Event: CustomStringConvertible {
    var eventId: String?
    var statuses: [Status]
    var location: Location
    
    var numberOfPeople: Int {
        return statuses.count
    }
    
    var description: String {
        return "\(eventId) = \(location) = \(statuses)"
    }
    
    var fbDescription: [String: AnyObject] {
        let statusArray = [:] as NSMutableDictionary
        for status in statuses {
            //statusArray[status.statusId!] = status.fbDescription
        }
        return ["Location": location.fbDescription, "Statuses": statusArray]
    }
    
    func setEventId(id: String) {
        self.eventId = id
    }
    
    init(statuses: [Status], location: Location){
        self.statuses = statuses
        self.location = location
    }
}
