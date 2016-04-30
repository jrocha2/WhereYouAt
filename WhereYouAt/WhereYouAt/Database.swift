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
    var profilePictures : [String : String] = [:]
    var dorms = ["Alumni",
                 "Badin",
                 "Breen-Phillips",
                 "Carroll",
                 "Cavanaugh",
                 "Dillon",
                 "Duncan",
                 "Farley",
                 "Fisher",
                 "Howard",
                 "Keenan",
                 "Keough",
                 "Knott",
                 "Lewis",
                 "Lyons",
                 "McGlinn",
                 "Morrissey",
                 "O’Neill",
                 "Pangborn",
                 "Pasquerilla East",
                 "Pasquerilla West",
                 "Ryan",
                 "Saint Edward’s",
                 "Siegfried",
                 "Sorin",
                 "Stanford",
                 "Walsh",
                 "Welsh Family",
                 "Zahm"]
    
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
        self.getProfilePics({})
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
        }
    }
    
    //Gets a user's friends
    func getFriends(callback: () -> Void) {
        self.firebase.getAllFriends() {
            (friends) in
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
    
    func getProfilePics(callback: () -> Void) {
        self.firebase.getProfilePictures({
            (pictures) in
            self.profilePictures = pictures
            callback()
        })
    }
    
    // Return locations sorted by most number of people in attendence
    func getCampusTrends() -> [Location] {
        return self.getFilteredCampusTrends(false, getOnlyYear: nil, getOnlyDorm: nil, getOnlyGender: nil, getType: nil)
    }
    
    func getFilteredCampusTrends(getOnlyFriends: Bool, getOnlyYear: Profile.Year?, getOnlyDorm: String?, getOnlyGender: Profile.Gender?, getType: LocationType?) -> [Location] {
        var locs: [Location] = []
        
        //If getType is not nil, only include events of a particular type
        if let type = getType {
            locations = locations.filter({ (locat) -> Bool in
                return locat.type == type
            })
        }
        
        //If getOnlyFriends is true, only include the friends
        if getOnlyFriends {
            for location in locations {
                location.statuses = location.statuses.filter({ (stat) -> Bool in
                    return self.friendsList[stat.profile.userId!] != nil
                })
            }
        }
        
        //If getOnlyGender is not nil, get only people of particular gender
        if let gender = getOnlyGender {
            for location in locations {
                location.statuses = location.statuses.filter({ (stat) -> Bool in
                    return stat.profile.gender == gender
                })
            }
        }
        
        //If getOnlyYear is not nil, get only people from a particular year
        if let year = getOnlyYear {
            for location in locations {
                location.statuses = location.statuses.filter({ (stat) -> Bool in
                    return stat.profile.year == year
                })
            }
        }
        
        //If getOnlyDorm is true, return only those statuses from a particular dorm
        if let dorm = getOnlyDorm {
            for location in locations {
                location.statuses = location.statuses.filter({ (stat) -> Bool in
                    return stat.profile.dorm == dorm
                })
            }
        }
        
        // Filter locations so that only those with people are shown
        locs = locations.filter { loc in
            return loc.numberOfPeople > 0
        }
        
        locs.sortInPlace({$0.numberOfPeople > $1.numberOfPeople})
        return locs
    }
}