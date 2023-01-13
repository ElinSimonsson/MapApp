//
//  ContentView.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import SwiftUI

struct ContentView: View {
    var locationManager = LocationManager()
    
    @State var showMap = true
    
    init() {
        locationManager.startLocationUpdates()
    }
    
    var body: some View {
        if showMap {
            MapView(locationManager: locationManager)
        } else {
            ListOfPlacesView(locationManager: locationManager)
        }
        Spacer()
        HStack {
            Spacer()
            Button(action: {
                showMap = true
            }) {
                ButtonContent(text: "Map")
            }
            Spacer()
            Button(action: {
                showMap = false
            }) {
                ButtonContent(text: "List")
            }
            Spacer()
        }
    }
}

struct ButtonContent : View {
    var text : String
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 180, height: 60)
            .background(Color.orange)
            .cornerRadius(15.0)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

