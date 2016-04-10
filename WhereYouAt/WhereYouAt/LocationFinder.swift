//
//  GoogleMaps.swift
//  WhereYouAt
//
//  Created by Cory Jbara on 4/9/16.
//  Copyright © 2016 Where You At. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class LocationFinder {
    var address: String
    var latitude: Double = 0
    var longitude: Double = 0
    var error = false
    var APIKey = "AIzaSyCe-Jqa1Gwlm9_XHoWqoMH5J754vtHbJXU"
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }

    init(address: String, callback: (finder: LocationFinder) -> ()) {
        self.address = address
        let urlAddress = address.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(urlAddress)&key=\(APIKey)")
        print(url)
        let request = NSMutableURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, responseText, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    print(error)
                    self.error = true
                } else {
                    let json = JSON(data: data!)
                    if json["status"] == "ZERO_RESULTS" {
                        print("Error")
                        self.error = true
                    } else {
                        let location = json["results"][0]["geometry"]["location"].dictionaryValue
                        self.latitude = Double(location["lat"]!.stringValue)!
                        self.longitude = Double(location["lng"]!.stringValue)!
                        print("\(self.latitude) \(self.longitude)")
                    }
                    callback(finder: self)
                }
            })
        }
        task.resume()
    }
}