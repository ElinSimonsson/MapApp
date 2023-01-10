//
//  ListOfPlacesView.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import SwiftUI

struct ListOfPlacesView: View {
    @EnvironmentObject var places : Places
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List  {
        ForEach (places.places) { place in
                HStack {
                    Text(place.name)
                    Text("\(place.longitude), \(place.latitude)")
                }
            }
        }
        Button(action: {
            places.showMap = true
            presentationMode.wrappedValue.dismiss()
        }) {
            ButtonContent(text: "Map")
        }
    }
}



//struct ListOfPlacesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListOfPlacesView()
//    }
//}
