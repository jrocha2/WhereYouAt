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
    var userId: String
    var userName: String
    var body: String
    var timestamp: Double
    
    var time: NSDate {
        return NSDate(timeIntervalSince1970: timestamp)
    }
    
    init(statusId: String, userId: String, userName: String, body: String, time: Double) {
        self.statusId = statusId
        self.userId = userId
        self.userName = userName
        self.body = body
        self.timestamp = time
    }
}
