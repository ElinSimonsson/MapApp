//
//  Place.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import Foundation
import CoreLocation

struct Place : Identifiable, Equatable {
    var id = UUID()
    var name : String
    var latitude : Double
    var longitude : Double
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
