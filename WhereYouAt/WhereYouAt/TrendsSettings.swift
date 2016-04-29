//
//  TrendsSettings.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/29/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation

class TrendsSettings {
    
    var genders: [String]? = Profile.Gender.allValues
    var dorms: [String]? = ["Alumni",
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
    var year: [String]? = Profile.Year.allValues
    var friends: Bool = false
}