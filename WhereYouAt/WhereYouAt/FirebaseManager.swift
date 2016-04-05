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
    
    var rootURL : String = ""
    var rootRef : Firebase!
    var myUID : String = ""
    var myName : String = ""
    var userRef : Firebase!
    
    init(URL: String, myUID: String, myName: String) {
        rootURL = URL
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
    
//    func getAllFriends() -> [String:String] {
//        var friends : [String : String] = [:]
//        let friendsRef = userRef.childByAppendingPath("Friends")
//        
//        friendsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            for child in snapshot.children {
//                let uid = child.key as String
//                let username = child.value as String
//                friends[uid] = username
//            }
//            
//            return friends
//        })
//    }
    
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
    
//    func getProfile(uid: String) -> Profile {
//        var userData : [String : String] = [:]
//        let desiredRef = rootRef.childByAppendingPath("Users").childByAppendingPath(uid).childByAppendingPath("Profile")
//        
//        desiredRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            for child in snapshot.children {
//                let key = child.key as String
//                let value = child.value as String
//                userData[key] = value
//            }
//            
//            // Initialize different Profile depending on which details are available
//            if let dob = userData["dateOfBirth"], home = userData["dorm"] {
//                return Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phoneNumber"]!, dateOfBirth: dob, dorm: home)
//            } else if let dob = userData["dateOfBirth"] {
//                return Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phoneNumber"]!, dateOfBirth: dob)
//            } else if let home = userData["dorm"] {
//                return Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phoneNumber"]!, dorm: home)
//            }else{
//                return Profile(userId: userData["userId"]!, firstName: userData["firstName"]!, lastName: userData["lastName"]!, gender: Profile.Gender(rawValue: userData["gender"]!)!, year: Profile.Year(rawValue: userData["year"]!)!, phoneNumber: userData["phoneNumber"]!, dateOfBirth: dob)
//            }
//        })
//    }
}
