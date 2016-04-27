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
        
        firebase = FirebaseManager(myUID: userId)
        //insertDummyLocations()
        //insertDummyData()
        self.getFriends(callback)
        self.getFriendRequests({})
        self.getPendingFriends({})
        self.getLocationsAndStatuses()
        self.getAllUsers({})
        if( hasProfile ) {
            self.getProfile()
        }
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
        self.firebase.addNewFriend(uid, userName: name, myName: (self.profile?.name)!)
    }
    
    // Respond to a friend request
    func respondToFriendRequest(uid: String, name: String, accept: Bool) {
        self.firebase.respondToFriendRequest(uid, userName: name, acceptRequest: accept, myName: (self.profile?.name)!)
    }
    
    // Get your friend requests
    func getFriendRequests(callback: () -> Void) {
        self.firebase.getFriendRequests() {
            (requests) in
            self.friendRequests = requests
            callback()
        }
    }
    
    // Get your sent friend requests
    func getPendingFriends(callback: () -> Void) {
        self.firebase.getPendingFriends() {
            (pending) in
            self.friendsPending = pending
            print("Should run  callback")
            callback()
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
    func getAllUsers(callback: () -> Void) {
        self.firebase.getAllUsers() {
            (users) in
            self.allUsers = users
            print("Saving USers")
            callback()
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