//
//  Status.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation

class Status {
    var statusId: String
    var personId: String
    var personName: String
    var timestamp: NSDate
    
    init(statusId: String, personId: String, personName: String, time: NSDate) {
        self.statusId = statusId
        self.personId = personId
        self.personName = personName
        self.timestamp = time
    }
}
