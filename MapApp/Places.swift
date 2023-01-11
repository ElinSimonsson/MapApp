//
//  Places.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import Foundation

class Places : ObservableObject, Identifiable {
    var id = UUID()
    @Published var places = [Place]()
    @Published var showMap = true
    
    init() {
        places.append(Place(name: "nice place", latitude: 37.3323341, longitude: -122.032))
        places.append(Place(name: "food", latitude: 37.3323341, longitude: -122.030))
        places.append(Place(name: "nice food", latitude: 37.3323341, longitude: -122.029))
        
    }
    
    func deletePlace (indexSet: IndexSet) {
        places.remove(atOffsets: indexSet)
    }
    
    func addPlace(place: Place) {
        places.append(place)
    }
    
    func addPlaceWithLL (latitude: Double, longitude: Double) {
        let place = Place(name: "", latitude: latitude, longitude: longitude)
        places.append(place)
    }
    
    func updateName (place: Place, with name: String) {
        if let index = places.firstIndex(of: place) {
            places[index].name = name
        }
    }
}
