//
//  Profile.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation

class Profile: CustomStringConvertible {
    var userId: String?
    var firstName: String
    var lastName: String
    var gender: Gender
    var year: Year
    var phone: String
    var dateOfBirth: String?
    var dorm: String?
    //var picture: UIImage?
    var name: String {
        return firstName+" "+lastName
    }
    
    var fbDescription: [String: AnyObject] {
        var userData : [String : String] = [:]
        userData["firstName"] = self.firstName
        userData["lastName"] = self.lastName
        userData["gender"] = String(self.gender)
        userData["year"] = String(self.year)
        userData["phone"] = self.phone
        if let dob = self.dateOfBirth {
            userData["dateOfBirth"] = dob
        }
        if let home = self.dorm {
            userData["dorm"] = home
        }
        return userData
    }
    
    var description: String {
        return "\(name) \(year) \(phone)"
    }
    
    enum Gender: String {
        case Male = "Male"
        case Female = "Female"
        
        static let allValues = ["Male", "Female"]
    }
    
    enum Year: String {
        case Freshman = "Freshman"
        case Sophomore = "Sophomore"
        case Junior = "Junior"
        case Senior = "Senior"
        case Grad = "Grad Student"
        
        static let allValues = ["Freshman", "Sophomore", "Junior", "Senior", "Grad Student"]
    }
    
    init(firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.year = year
        self.phone = phoneNumber
        self.dateOfBirth = nil
        self.dorm = nil
    }
    
    convenience init(firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String, dateOfBirth: String) {
        self.init(firstName: firstName, lastName: lastName, gender: gender, year: year, phoneNumber: phoneNumber)
        self.dateOfBirth = dateOfBirth
    }
    
    convenience init(firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String, dorm: String) {
        self.init(firstName: firstName, lastName: lastName, gender: gender, year: year, phoneNumber: phoneNumber)
        self.dorm = dorm
    }
    
    convenience init(firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String, dateOfBirth: String, dorm: String) {
        self.init(firstName: firstName, lastName: lastName, gender: gender, year: year, phoneNumber: phoneNumber)
        self.dateOfBirth = dateOfBirth
        self.dorm = dorm
    }
    
    init(fromFirebaseUserData userData: [String:String]){
        // Initialize different Profile depending on which details are available
        self.firstName = userData["firstName"]!
        self.lastName = userData["lastName"]!
        self.gender = Gender(rawValue: userData["gender"]!)!
        let newYear = Year(rawValue: userData["year"]!)
        if (newYear == nil) {
            self.year = .Grad
        } else{
            self.year = newYear!
        }
        self.phone = userData["phone"]!
        
        if let dob = userData["dateOfBirth"] {
            self.dateOfBirth = dob
        } else {
            self.dateOfBirth = nil
        }
        if let home = userData["dorm"]
        {
            self.dorm = home
        } else {
            self.dorm = nil
        }
        
    }
}