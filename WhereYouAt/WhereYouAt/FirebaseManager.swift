//
//  FirebaseManager.swift
//  WhereYouAt
//
//  Created by John Rocha on 4/5/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    var rootURL : String = "https://whereareu.firebaseio.com/"
    var rootRef : Firebase!
    var myUID : String = ""
    var myName : String = ""
    var userRef : Firebase!
    
    init(myUID: String, myName: String) {
        rootRef = Firebase(url: rootURL)
        self.myUID = myUID
        self.myName = myName
        userRef = rootRef.childByAppendingPath("Users").childByAppendingPath(myUID)
    }
    
    func addNewUser(uid: String) {
        rootRef.childByAppendingPath("Users").childByAppendingPath(uid).childByAppendingPath("Profile").setValue("New User")
    }
    
    func addFriend(uid: String, userId: String) {
        userRef.childByAppendingPath("Friends").childByAppendingPath(uid).setValue(userId)
        rootRef.childByAppendingPath("Users/\(uid)/Friends/Requests/\(myUID)").setValue(myName)
    }
    
    func getAllFriends(callback: [String:String] -> ()) {
        var friends : [String : String] = [:]
        let friendsRef = userRef.childByAppendingPath("Friends")
        
        friendsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let uid = child.key as String
                let username = child.value as String
                friends[uid] = username
            }
            
            callback(friends)
        })
    }
    
    // Creates dictionary out of Profile's properties and sets appropriate node
    func updateProfile(profile: Profile) {
        
        var userData : [String : String] = [:]
        //userData["userId"] = profile.userId
        userData["firstName"] = profile.firstName
        userData["lastName"] = profile.lastName
        userData["gender"] = String(profile.gender)
        userData["year"] = String(profile.year)
        userData["phone"] = profile.phone
        if let dob = profile.dateOfBirth {
            userData["dateOfBirth"] = dob
        }
        if let home = profile.dorm {
            userData["dorm"] = home
        }
        
        userRef.childByAppendingPath("Profile").setValue(userData)
        
    }
    
    func getProfile(uid: String, callback: (Profile) -> ()) {
        var userData : [String : String] = [:]
        let desiredRef = rootRef.childByAppendingPath("Users").childByAppendingPath(uid).childByAppendingPath("Profile")
        desiredRef.observeSingleEventOfType(.Value, withBlock: {
            (snapshot) in
            for child in snapshot.children {
                let key = child.key as String
                let value = child.value as String
                userData[key] = value
            }
            
            // Initialize different Profile depending on which details are available
            if let dob = userData["dateOfBirth"], home = userData["dorm"] {
                callback(Profile(firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!, dateOfBirth: dob, dorm: home))
            } else if let dob = userData["dateOfBirth"] {
                callback(Profile(firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!, dateOfBirth: dob))
            } else if let home = userData["dorm"] {
                callback(Profile(firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!, dorm: home))
            } else {
                callback(Profile(firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!))
            }
        })
    }
    
    //Inserts dummy data into the Firebase DB (This is the example of the data structure)
    func insertDummyData() {
        let desiredRef = rootRef.childByAppendingPath("Locations")
        let locations = ["1": ["name": "Brothers", "type": "Bar", "latitude": 40, "longitude": 45],
                         "2": ["name": "O'Rourke's", "type": "Bar", "latitude": 45, "longitude": 40]]
        //let brothers = ["name": "Brothers", "type": "Bar", "latitude": 40, "longitude": 45]
        //let oRos = ["name": "O'Rourke's", "type": "Bar", "latitude": 45, "longitude": 40]
        //desiredRef.childByAutoId().setValue(brothers)
        //desiredRef.childByAutoId().setValue(oRos)
        desiredRef.setValue(locations)
        
        let eventRef = rootRef.childByAppendingPath("Events")
        let event = ["locationId": "1"]
        eventRef.setValue(["1": event])
        //eventRef.childByAutoId().setValue(event)
        let statusRef = eventRef.childByAppendingPath("1").childByAppendingPath("statuses")
        let broStatus = ["userId": "107819875842607976572", "userName": "Cory Jbara", "body": "I'm so excited for Brother's Tonight!", "timestamp": FirebaseServerValue.timestamp()]
        let broStatus2 = ["userId": "103452395065219160297", "userName": "John Rocha", "body": "I love Brother's T-Shirts!", "timestamp": FirebaseServerValue.timestamp()]
        statusRef.childByAutoId().setValue(broStatus)
        statusRef.childByAutoId().setValue(broStatus2)
        
    }
    
    func getEventData(locations: [Location], callback: ([Event]) -> () ) {
        let eventRef = rootRef.childByAppendingPath("Events")
        var eventData: [Event] = []
        var statuses: [Status] = []
        //Whenever the events are updated, run this
        eventRef.observeEventType(.Value, withBlock: {
            (snapshot) in
            //For each event
            for child in snapshot.children {
                let eventId = child.key as String
                let locationId = child.value["locationId"] as! String
                //For each status that belongs to an event
                for status in child.value["statuses"] as! NSDictionary {
                    let statusId = status.key as! String
                    let userId = status.value["userId"] as! String
                    let userName = status.value["userName"] as! String
                    let body = status.value["body"] as! String
                    let time = status.value["timestamp"] as! Double
                    statuses.append(Status(statusId: statusId, userId: userId, userName: userName, body: body, time: time))
                }
                //Find the location in the list of locations
                for location in locations {
                    if location.locationId == locationId {
                        eventData.append(Event(eventId: eventId, statuses: statuses, location: location))
                    }
                }
                statuses = []
            }
            callback(eventData)
            eventData = []
        })
    }
 
    func getLocations(callback: ([Location]) -> () ) {
        let locationRef = rootRef.childByAppendingPath("Locations")
        var locationData: [Location] = []
        locationRef.observeEventType(.Value, withBlock: {
            (snapshot) in
            for child in snapshot.children {
                let id = child.key as String
                let latitude = child.value["latitude"] as! Double
                let longitude = child.value["longitude"] as! Double
                let name = child.value["name"] as! String
                let type = child.value["type"] as! String
                locationData.append(Location(locationId: id, locationName: name, locationType: LocationType(rawValue: type)!, latitude: latitude, longitude: longitude))
            }
            callback(locationData)
            locationData = []
        })
        
    }
}
