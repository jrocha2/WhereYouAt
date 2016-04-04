//
//  Event.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation

class Event {
    var eventId: String
    var statuses: [Status]
    var location: Location
    
    var numberOfPeople: Int {
        return statuses.count
    }
    
    init(eventId: String, statuses: [Status], location: Location){
        self.eventId = eventId
        self.statuses = statuses
        self.location = location
    }
}
