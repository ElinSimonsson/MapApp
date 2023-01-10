//
//  LocationManager.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import Foundation
import CoreLocation


class LocationManager : NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var location : CLLocationCoordinate2D?
    
   override init () {
       super.init()
       manager.delegate = self
       
    }
    
    func startLocationUpdates () {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
//    func stopDelegate () {
//        manager.delegate = nil
//    }
    
    
    
}
