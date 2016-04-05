//
//  Profile.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/3/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation

class Profile {
    var userId: String
    var firstName: String
    var lastName: String
    var gender: Gender
    var year: Year
    var phone: String
    var dateOfBirth: String?
    var dorm: String?
    //var picture: UIImage?
    
    enum Gender: String {
        case Male = "Male"
        case Female = "Female"
    }
    
    enum Year: String {
        case Senior = "Senior"
        case Junior = "Junior"
        case Sophomore = "Sophomore"
        case Freshman = "Freshman"
    }
    
    init(userId: String, firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.year = year
        self.phone = phoneNumber
        self.dateOfBirth = nil
        self.dorm = nil
    }
    
    convenience init(userId: String, firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String, dateOfBirth: String) {
        self.init(userId: userId, firstName: firstName, lastName: lastName, gender: gender, year: year, phoneNumber: phoneNumber)
        self.dateOfBirth = dateOfBirth
    }
    
    convenience init(userId: String, firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String, dorm: String) {
        self.init(userId: userId, firstName: firstName, lastName: lastName, gender: gender, year: year, phoneNumber: phoneNumber)
        self.dorm = dorm
    }
    
    convenience init(userId: String, firstName: String, lastName: String, gender: Gender, year: Year, phoneNumber: String, dateOfBirth: String, dorm: String) {
        self.init(userId: userId, firstName: firstName, lastName: lastName, gender: gender, year: year, phoneNumber: phoneNumber)
        self.dateOfBirth = dateOfBirth
        self.dorm = dorm
    }
}