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
    var latitude: Double
    var longitude: Double
    var APIKey = "AIzaSyCe-Jqa1Gwlm9_XHoWqoMH5J754vtHbJXU"
    var point: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }

    
    init(address: String) {
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&key=\(APIKey)")
        let request = NSMutableURLRequest(URL: url!)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, responseText, error) -> Void in
            if error != nil {
                print(error)
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {
                    self.parseJSONResponse(data!)
                })
            }
        }
        task.resume()
    }
    
    func parseJSONResponse(data: NSData) -> Void {
        let json = JSON(data: data)
        let location = json["results"][0]["geometry"]["location"].dictionaryValue
        self.latitude = Double(location["lat"]!.stringValue)!
        self.longitude = Double(location["lng"]!.stringValue)!
        let point = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        map.setRegion(MKCoordinateRegion(center: point, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
    }
}