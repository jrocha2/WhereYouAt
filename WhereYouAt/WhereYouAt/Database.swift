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
    var eventData : [Event] = []
    var locations: [Location] = []
    var profile: Profile?
    var firebase: FirebaseManager
    
    //The init method calls the methods in the Firebase class
    init(myUID: String) {
        self.userId = myUID
        
        firebase = FirebaseManager(myUID: userId, myName: "Cory Jbara")
        self.firebase.getAllFriends() {
            (friends) in
            self.friendsList = friends
        }
        /*self.firebase.getEventData() {
            (events) in
            self.eventData = events
        }
        self.firebase.getLocations() {
            (locations) in
            self.locations = locations
        }*/
        self.firebase.getProfile("107819875842607976572") {
            (profile) in
            self.profile = profile
        }
    }

    //This gets your feed for your friend's statuses
    func getStatusFeed() -> [Status] {
        var friendsStatuses: [Status] = []
        for event in eventData {
            for status in event.statuses {
                if let _ = friendsList[status.personId] {
                    friendsStatuses.append(status)
                }
            }
        }
        friendsStatuses.sortInPlace( {
            return $0.timestamp.compare($1.timestamp) == .OrderedAscending
        })
        return friendsStatuses
    }
    
    //This gets an array of events which your friends are going to sorted by friends going
    func getEventsForFriends() -> [Event] {
        var friendsEvents: [Event] = []
        for event in eventData {
            for status in event.statuses {
                if let _ = friendsList[status.personId] {
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
    }
}