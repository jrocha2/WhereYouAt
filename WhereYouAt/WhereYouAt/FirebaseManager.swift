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
        userData["userId"] = profile.userId
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
                callback(Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!, dateOfBirth: dob, dorm: home))
            } else if let dob = userData["dateOfBirth"] {
                callback(Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!, dateOfBirth: dob))
            } else if let home = userData["dorm"] {
                callback(Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!, dorm: home))
            } else {
                callback(Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phone"]!))
            }
        })
    }
    
//    func getEventData(callback: ([Event]) -> () ) {
//        let desiredRef = rootRef.childByAppendingPath("Events")
//        var events = ["1": "Brothers", "2": "O'Rourke's"]
//        desiredRef.setValue(events)
//        
//        desiredRef.observeEventType(.Value) {
//            (snapshot) in
//            for child in snapshot.children {
//                let key = child.key as String
//                let value = child.value
//                value.
//            }
//        }
//    }
    
//    func getLocations(callback: ([Location]) -> () ) {
//        let desiredRef = rootRef.childByAppendingPath("Locations")
//        let locations = ["1": ["name": "Brothers", "type": "Bar", "latitude": 40, "longitude": 45, "locationId": "1"]]
//        desiredRef.setValue(locations)
//        var locationData: [String:String] = [:]
//        desiredRef.observeEventType(.Value, withBlock: {
//            (snapshot) in
//            for child in snapshot.children {
//                let key = child.key as String
//                let value = child.value as String
//                locationData[key] = value
//            }
//            callback([Location(locationId: locationData["locationId"]!, locationName: locationData["name"]!, locationType: LocationType(rawValue: locationData["type"]!)!, latitude: Double(locationData["latitude"]!)!, longitude: Double(locationData["longitude"]!)!)])
//        })
//        
//    }
}
