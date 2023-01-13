//
//  ListOfPlacesView.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import SwiftUI
import CoreLocation

struct ListOfPlacesView: View {
    @EnvironmentObject var places : Places
    //var locationManager = LocationManager()
    var locationManager : LocationManager
    @State var selectedPlace : Place? = nil
    @State var newName = ""
    @FocusState var isFocused : Bool
    @State var distance : Double = 0.0
    
    
    var body: some View {
        List  {
            ForEach (places.places) { place in
                HStack {
                    if let selectedPlace = self.selectedPlace, selectedPlace == place {
                        TextField("change the name", text: self.$newName, onCommit: {
                            places.updateName(place: selectedPlace, with: self.newName)
                            self.selectedPlace = nil
                            isFocused = false
                        })
                        .focused($isFocused)
                        .onAppear() {
                            self.isFocused = true
                            self.newName = place.name
                        }
                    }
                    if selectedPlace != place {
                        Text(place.name)
                    }
                    if place.kilometer {
                        Text("\(place.distance) km")
                    } else {
                        Text("\(place.distance) meter")
                    }
                   
                }
                .onAppear() {
                    calculateDistance()
                }
                .onTapGesture {
                    selectedPlace = place
                }
            }
            
            .onDelete() { indexSet in
                places.deletePlace(indexSet: indexSet)
            }
        }
    }
    
    func calculateDistance () {
        if let location = locationManager.location {
            print("funktion addpin körs")
            let currentLatitude = location.latitude
            let currentLongitude = location.longitude
            
            for place in places.places {
                let placeLocation = CLLocation(latitude: place.latitude, longitude: place.longitude)
                let currentLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
                var distance = currentLocation.distance(from: placeLocation)
                if distance > 1000 {
                    distance = distance / 1000 // get distance in kilometres
                    places.updateisKilometers(place: place, with: true)
                } else {
                    places.updateisKilometers(place: place, with: false)
                }
                places.calculateDistance(place: place, with: distance)
                print(place.distance, place.kilometer)
            }
            

        }
    }
}



//struct ListOfPlacesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListOfPlacesView()
//    }
//}
