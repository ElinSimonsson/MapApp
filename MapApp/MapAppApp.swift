//
//  MapAppApp.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import SwiftUI

@main
struct MapAppApp: App {
   @StateObject var places = Places()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(places)
        }
    }
}
