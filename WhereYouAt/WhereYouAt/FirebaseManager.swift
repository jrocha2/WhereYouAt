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
    
    //Adds a new user to the database
    func addNewUser(uid: String) {
        rootRef.childByAppendingPath("Users").childByAppendingPath(uid).childByAppendingPath("Profile").setValue("New User")
    }
    
    //Adds a new location to the database
    func addNewLocation(loc: Location) {
        rootRef.childByAppendingPath("Locations").childByAutoId().setValue(loc.fbDescription) {
            (error, snapshot) in
            loc.setLocationId(snapshot.key as String)
        }
    }
    
//    //Adds a new event to the database
//    func addNewEvent(event: Event) {
//        rootRef.childByAppendingPath("Events").childByAutoId().setValue(event.fbDescription)
//    }
    
    //Adds a new status to a particular location
    func addNewStatus(status: Status, locationId: String, callback: (() -> ())?) {
        let newRef = rootRef.childByAppendingPath("Locations/"+locationId)
        newRef.observeSingleEventOfType(.Value, withBlock: {
            (snapshot) in
            if snapshot.exists() {
                newRef.childByAppendingPath("Statuses").childByAutoId().setValue(status.fbDescription, withCompletionBlock: {
                    (error, snapshot) in
                    status.setStatusId(snapshot.key as String)
                    callback?()
                })
            } else {
                print("error: This location does not exist")
            }
        })
    }
    
    //Checks if a user is has a profile
    func checkForUserId(uid: String, callback: (Bool) -> ()) {
        let ref = rootRef.childByAppendingPath("Users").childByAppendingPath(uid)
        ref.observeSingleEventOfType(.Value, withBlock: {
            (snapshot) in
            //Check if they are in the DB
            if snapshot.exists() {
                callback(true)
            } else {
                callback(false)
            }
        })
    }
    
    /*
    func addFriend(uid: String, userId: String) {
        userRef.childByAppendingPath("Friends").childByAppendingPath(uid).setValue(userId)
        rootRef.childByAppendingPath("Users/\(uid)/Friends/Requests/\(myUID)").setValue(myName)
    }*/
    
    func getAllFriends(callback: [String:String] -> ()) {
        var friends : [String : String] = [:]
        let friendsRef = userRef.childByAppendingPath("Friends")
        
        friendsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    let uid = child.key as String
                    let username = child.value as String
                    friends[uid] = username
                }
            
                callback(friends)
            }
        })
    }
    
    // Creates dictionary out of Profile's properties and sets appropriate node
    func updateProfile(profile: Profile, callback: (Profile) -> ()) {
        
        userRef.childByAppendingPath("Profile").setValue(profile.fbDescription, withCompletionBlock: {
            (snap) in
            callback(profile)
        })
        
    }
    
    //Gets a profile for a specific userId
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
            callback(Profile(fromFirebaseUserData: userData))
        })
    }
 
    //Gets every location in the database and the statuses for the location
    func getLocations(callback: ([Location]) -> ()) {
        let locationRef = rootRef.childByAppendingPath("Locations")
        var locationData: [Location] = []
        var statusData: [Status] = []
        locationRef.observeEventType(.Value, withBlock: {
            (snapshot) in
            for child in snapshot.children {
                let id = child.key as String
                let info = child.childSnapshotForPath("Info")
                let statuses = child.childSnapshotForPath("Statuses")
                for status in statuses.children {
                    
                    //For each status, add this to a status array
                    let id = status.key as String
                    let body = status.childSnapshotForPath("body").value as! String
                    let timestamp = status.childSnapshotForPath("timestamp").value as! Double
                    let userId = status.childSnapshotForPath("userId").value as! String
                    let userName = status.childSnapshotForPath("userName").value as! String
                    let newStatus = Status(statusId: id, userId: userId, userName: userName, body: body, time: timestamp)
                    statusData.append(newStatus)
                }
                let lat = info.childSnapshotForPath("latitude").value as! Double
                let lon = info.childSnapshotForPath("longitude").value as! Double
                let name = info.childSnapshotForPath("name").value as! String
                let type = LocationType(rawValue: String(info.childSnapshotForPath("type").value))!
                let loc = Location(locationId: id, locationName: name, locationType: type, latitude: lat, longitude: lon)
                locationData.append(loc)
                loc.addStatuses(statusData)
                
                //Reset status data
                statusData = []
            }
            callback(locationData)
            locationData = []
        })
        
    }
}
