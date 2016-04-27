//
//  Database.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation
import Firebase

// Global Notification IDs
let newLocationDataNotification = "com.newLocationDataNotification.whereyouat"

class Database {
    
    var userId: String = ""
    var locations: [Location] = []
    var profile: Profile?
    var firebase: FirebaseManager
    var allUsers : [String:String] = [:]
    var friendsList: [String: String] = [:]
    var friendRequests : [String : String] = [:]
    var friendsPending : [String : String] = [:]
    
    //The init method calls the methods in the Firebase class
    init(myUID: String, hasProfile: Bool, callback: () -> Void) {
        self.userId = myUID
        
        firebase = FirebaseManager(myUID: userId, myName: "Loading Name")
        //insertDummyLocations()
        //insertDummyData()
        self.getFriends(callback)
        self.getFriendRequests()
        self.getPendingFriends()
        self.getLocationsAndStatuses()
        self.getAllUsers()
        if( hasProfile ) {
            self.getProfile()
        }
    }
    
    //Inserts dummy data into the DB
    func insertDummyLocations() {
        let brothers = Location(locationName: "Brother's Bar and Grill", locationType: .Bar, latitude: 41.6919844, longitude: -86.2344451)
        let oRos = Location(locationName: "O'Rourke's", locationType: .Bar, latitude: 41.6925968, longitude: -86.2360118)
        self.createNewLocation(brothers, callback: nil)
        self.createNewLocation(oRos, callback: nil)
    }
    func insertDummyData() {
        self.createNewStatus(Status(userId: "102590562384346485497", userName: "Cory Jbara", body: "I love Brother's Bar!"), locationId: "-KEiWP4dujG9jBU9-GO2", callback: nil)
        self.createNewStatus(Status(userId: "116019746140165652297", userName: "Brad Sherman", body: "Going to sing Karaoke!"), locationId: "-KEiWP4dujG9jBU9-GO3", callback: nil)
        self.createNewStatus(Status(userId: "103452395065219160297", userName: "John Rocha", body: "Brother's is great"), locationId: "-KEiWP4dujG9jBU9-GO2", callback: nil)
    }
    
    //Creates a new location
    func createNewLocation(location: Location, callback: (() -> ())?) {
        self.firebase.addNewLocation(location, callback: callback)
    }
    
    //Creates a new status for a location, inserts it into the existing location
    func createNewStatus(status: Status, locationId: String, callback: (() -> ())?) {
        self.firebase.addNewStatus(status, locationId: locationId, callback: callback)
    }

    //Gets a users profile
    func getProfile() {
        self.firebase.getProfile(self.userId) {
            (profile) in
            self.profile = profile
            self.profile!.userId = self.userId
            print(self.profile)
        }
    }
    
    //Gets a user's friends
    func getFriends(callback: () -> Void) {
        self.firebase.getAllFriends() {
            (friends) in
            print("Got friends \(friends)")
            self.friendsList = friends
            callback()
        }
    }
    
    // Send a friend request
    func sendFriendRequest(uid: String, name: String) {
        self.firebase.addNewFriend(uid, userName: name)
    }
    
    // Respond to a friend request
    func respondToFriendRequest(uid: String, name: String, accept: Bool) {
        self.firebase.respondToFriendRequest(uid, userName: name, acceptRequest: accept)
    }
    
    // Get your friend requests
    func getFriendRequests() {
        self.firebase.getFriendRequests() {
            (requests) in
            self.friendRequests = requests
        }
    }
    
    // Get your sent friend requests
    func getPendingFriends() {
        self.firebase.getPendingFriends() {
            (pending) in
            self.friendsPending = pending
        }
    }
    
    //Gets the locations and update events
    func getLocationsAndStatuses() {
        self.locations = []
        self.firebase.getLocations({
            (locations) in
            self.locations = locations
            // Posts a notification whenever new data is received
            NSNotificationCenter.defaultCenter().postNotificationName(newLocationDataNotification, object: self)
        })
    }
    
    // Gets all the users in the database
    func getAllUsers() {
        self.firebase.getAllUsers() {
            (users) in
            self.allUsers = users
        }
    }
    
    // Updates the profile
    func updateProfile(profile: Profile, call: () -> ()) {
        self.firebase.updateProfile(profile, callback: {
            (newProfile) in
            self.profile = newProfile
            call()
        })
    }
    
    // Return all statuses with sorted so that the latest are first
    func getEventData() -> [Status] {
        var statuses : [Status] = []
        for loc in locations {
            for status in loc.statuses {
                statuses.append(status)
            }
        }
        
        statuses.sortInPlace( {
          return $0.timestamp > $1.timestamp
        })
        
        return statuses
    }
    
    // Return all statuses of friends sorted so that the latest are first
    func getFriendStatuses(callback: ([Status])-> Void) {
        print("Getting friend's statuses")
        var friendStatuses : [Status] = []
        let allStatuses = getEventData()
        for status in allStatuses {
            for friend in friendsList {
                if status.userId == friend.0 {
                    friendStatuses.append(status)
                }
            }
        }
        callback(friendStatuses)
    }
    
    // Return locations sorted by most number of people in attendence
    func getCampusTrends() -> [Location] {
        var locs = locations
        locs.sortInPlace({$0.numberOfPeople > $1.numberOfPeople})
        return locs
    }
    
    /*//Returns an array of events with a particular category
    func getTrendWithCategory(category: LocationType) -> [Event] {
        var events: [Event] = []
        for event in eventData {
            if event.location.type == category {
                events.append(event)
            }
        }
        events.sortInPlace({$0.numberOfPeople > $1.numberOfPeople})
        return events
    }*/
}