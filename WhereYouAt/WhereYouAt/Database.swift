//
//  Database.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation
import Firebase

class Database {
    
    var userId: String = ""
    var friendsList: [String: String] = [:]
    var locations: [Location] = []
    var profile: Profile?
    var firebase: FirebaseManager
    
    //The init method calls the methods in the Firebase class
    init(myUID: String, hasProfile: Bool) {
        self.userId = myUID
        
        firebase = FirebaseManager(myUID: userId, myName: "Loading Name")
        //insertDummyLocations()
        //insertDummyData()
        self.getFriends()
        self.getLocationsAndStatuses()
        if( hasProfile ) {
            self.getProfile()
        }
    }
    
    //Inserts dummy data into the DB
    func insertDummyLocations() {
        let brothers = Location(locationName: "Brother's Bar", locationType: .Bar, latitude: 40, longitude: 45)
        let oRos = Location(locationName: "O'Rourke's Bar", locationType: .Bar, latitude: 45, longitude: 40)
        self.createNewLocation(brothers)
        self.createNewLocation(oRos)
    }
    func insertDummyData() {
        self.createNewStatus(Status(userId: "102590562384346485497", userName: "Cory Jbara", body: "I love Brother's Bar!"), locationId: "-KEhzjsQkaYTgGU0UVbp")
        self.createNewStatus(Status(userId: "116019746140165652297", userName: "Brad Sherman", body: "Going to sing Karaoke!"), locationId: "-KEhzjsZrjRZi-QxulO7")
        self.createNewStatus(Status(userId: "103452395065219160297", userName: "John Rocha", body: "Brother's is great"), locationId: "-KEhzjsQkaYTgGU0UVbp")
    }
    
    //Creates a new location
    func createNewLocation(location: Location) {
        self.firebase.addNewLocation(location)
    }
    
    //Creates a new status for a location, inserts it into the existing location
    func createNewStatus(status: Status, locationId: String) {
        self.firebase.addNewStatus(status, locationId: locationId)
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
    func getFriends() {
        self.firebase.getAllFriends() {
            (friends) in
            self.friendsList = friends
        }
    }
    
    //Gets the locations and update events
    func getLocationsAndStatuses() {
        self.firebase.getLocations() {
            (location) in
            self.locations.append(location)
            print(self.locations)
        }
    }
    
    //Updates the profile
    func updateProfile(profile: Profile, call: () -> ()) {
        self.firebase.updateProfile(profile, callback: {
            (newProfile) in
            self.profile = newProfile
            call()
        })
    }
    
    //This gets your feed for your friend's statuses
    /*func getStatusFeed() -> [Status] {
        var friendsStatuses: [Status] = []
        for event in eventData {
            for status in event.statuses {
                if let _ = friendsList[status.userId] {
                    friendsStatuses.append(status)
                }
            }
        }
        friendsStatuses.sortInPlace( {
            return $0.timestamp > $1.timestamp
        })
        return friendsStatuses
    }
    
    //This gets an array of events which your friends are going to sorted by friends going
    func getEventsForFriends() -> [Event] {
        var friendsEvents: [Event] = []
        for event in eventData {
            for status in event.statuses {
                if let _ = friendsList[status.userId] {
                    friendsEvents.append(event)
                }
            }
        }
        friendsEvents.sortInPlace({$0.numberOfPeople > $1.numberOfPeople})
        return friendsEvents
    }
    
    //Returns an array of events for the whole campus
    func getCampusTrends() -> [Event] {
        var campusEvents = eventData
        campusEvents.sortInPlace({$0.numberOfPeople > $1.numberOfPeople})
        return campusEvents
    }
    
    //Returns an array of events with a particular category
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