//
//  Status.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation
import Firebase

class Status: CustomStringConvertible {
    var statusId: String?
    var userId: String
    var userName: String
    var body: String
    var timestamp: Double?
    
    var time: NSDate {
        return NSDate(timeIntervalSince1970: timestamp!)
    }
    
    var description: String {
        return "\(userName): \(body)"
    }
    
    var fbDescription: [String: AnyObject] {
        return ["userId": userId, "userName": userName, "body": body, "timestamp": FirebaseServerValue.timestamp()]
    }
    
    func setStatusId(id: String) {
        self.statusId = id
    }
    
    init(userId: String, userName: String, body: String) {
        self.userId = userId
        self.userName = userName
        self.body = body
        self.timestamp = nil
        self.statusId = nil
    }
    
    init(statusId: String, userId: String, userName: String, body: String, time: Double) {
        self.statusId = statusId
        self.userId = userId
        self.userName = userName
        self.body = body
        self.timestamp = time
    }
}
