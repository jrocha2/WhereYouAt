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
    var userRef : Firebase!
    
    init(myUID: String) {
        rootRef = Firebase(url: rootURL)
        self.myUID = myUID
        userRef = rootRef.childByAppendingPath("Users").childByAppendingPath(myUID)
    }
    
    //Adds a new user to the database
    func addNewUser(uid: String) {
        rootRef.childByAppendingPath("Users").childByAppendingPath(uid).childByAppendingPath("Profile").setValue("New User")
    }
    
    //Adds a new location to the database
    func addNewLocation(loc: Location, callback: (() -> ())?) {
        rootRef.childByAppendingPath("Locations").childByAutoId().setValue(loc.fbDescription) {
            (error, snapshot) in
            loc.setLocationId(snapshot.key as String)
            callback!()
        }
    }
    
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
    
    // Sent friend requests appear under Friends/Pending node, and received requests under Friends/Requests
    func addNewFriend(uid: String, userName: String, myName: String) {
        userRef.childByAppendingPath("Friends/Pending").childByAppendingPath(uid).setValue(userName)
        rootRef.childByAppendingPath("Users/\(uid)/Friends/Requests/\(myUID)").setValue(myName)
    }
    
    // If accepted, removes users from pending/requests and places them under Friends/Accepted node
    func respondToFriendRequest(uid: String, userName: String, acceptRequest: Bool, myName: String) {
        if acceptRequest {
            userRef.childByAppendingPath("Friends/Accepted").childByAppendingPath(uid).setValue(userName)
            rootRef.childByAppendingPath("Users/\(uid)/Friends/Accepted/\(myUID)").setValue(myName)
        }
        userRef.childByAppendingPath("Friends/Requests").childByAppendingPath(uid).removeValue()
        rootRef.childByAppendingPath("Users/\(uid)/Friends/Pending/\(myUID)").removeValue()
    }
    
    func getAllFriends(callback: [String:String] -> ()) {
        var friends : [String : String] = [:]
        let friendsRef = userRef.childByAppendingPath("Friends/Accepted")
        
        friendsRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    let uid = child.key as String
                    let username = child.value as String
                    friends[uid] = username
                }
            
            }
            callback(friends)

        })
    }
    
    // Returns uids with usernames for use in respondToFriendRequest()
    func getFriendRequests(callback: [String:String] -> ()) {
        var requests : [String:String] = [:]
        let requestRef = userRef.childByAppendingPath("Friends/Requests")
        
        requestRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    let uid = child.key as String
                    let username = child.value as String
                    requests[uid] = username
                }
                
            }
            callback(requests)

        })
        
    }
    
    func getPendingFriends(callback: [String:String] -> ()) {
        var pending : [String:String] = [:]
        let pendingRef = userRef.childByAppendingPath("Friends/Pending")
        
        pendingRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                for child in snapshot.children {
                    let uid = child.key as String
                    let username = child.value as String
                    pending[uid] = username
                }
                
            }
            callback(pending)

        })
        
    }
    
    // Returns uids with usernames for all of the users in the database
    func getAllUsers(callback: [String:String] -> ()) {
        var users : [String:String] = [:]
        let usersRef = rootRef.childByAppendingPath("Users")
        
        usersRef.observeEventType(.Value, withBlock:  { snapshot in
            if snapshot.exists() {
                for user in snapshot.children {
                    let uid = user.key as String
                    let userFirstname = user.childSnapshotForPath("Profile/firstName").value as! String
                    let userLastname = user.childSnapshotForPath("Profile/lastName").value as! String
                    users[uid] = "\(userFirstname) \(userLastname)"
                }
                
                callback(users)
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
                let locId = child.key as String
                let info = child.childSnapshotForPath("Info")
                let statuses = child.childSnapshotForPath("Statuses")
                
                //Create the location
                let lat = info.childSnapshotForPath("latitude").value as! Double
                let lon = info.childSnapshotForPath("longitude").value as! Double
                let name = info.childSnapshotForPath("name").value as! String
                let type = LocationType(rawValue: String(info.childSnapshotForPath("type").value))!
                let loc = Location(locationId: locId, locationName: name, locationType: type, latitude: lat, longitude: lon)
                
                for status in statuses.children {
                    
                    //For each status, add this to a status array
                    let statusId = status.key as String
                    let body = status.childSnapshotForPath("body").value as! String
                    let timestamp = status.childSnapshotForPath("timestamp").value as! Double
                    
                    //Check if this status is older than a day, if it is, don't add to array, and delete from Firebase
                    let duration = NSDate(timeIntervalSince1970: timestamp).timeIntervalSinceDate(NSDate())
                    let numberOfDays: Double = 7
                    let maxDuration: Double = -86400 * numberOfDays //One day times numberOfDays
                    if duration < maxDuration {
                        //The status is too old, remove it
                        self.removeStatus(statusId, locationId: locId)
                    } else {
                        //Status is fine, add to array
                        let userId = status.childSnapshotForPath("userId").value as! String
                        let userName = status.childSnapshotForPath("userName").value as! String
                        let newStatus = Status(statusId: statusId, userId: userId, userName: userName, body: body, time: timestamp, loc: loc)
                        statusData.append(newStatus)
                    }
                }
                locationData.append(loc)
                loc.addStatuses(statusData)
                
                //Reset status data
                statusData = []
            }
            callback(locationData)
            locationData = []
        })
        
    }
    
    func removeStatus(statusId: String, locationId: String){
        print("Removing status \(statusId) for location \(locationId)")
        let ref = rootRef.childByAppendingPath("Locations/\(locationId)/Statuses/\(statusId)")
        ref.removeValue()
    }
}
