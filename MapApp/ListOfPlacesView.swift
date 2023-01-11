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
    @State var selectedPlace : Place? = nil
    @State var newName = ""
    
    var body: some View {
        List  {
        ForEach (places.places) { place in
                HStack {
                    //if selectedPlace == place && selectedPlace != nil {
                       // guard let selectedPlace = selectedPlace else {return}
                        if let selectedPlace = self.selectedPlace, selectedPlace == place {
                            TextField("change the name", text: self.$newName, onCommit: {
                                places.updateName(place: selectedPlace, with: self.newName)
                                self.selectedPlace = nil
                            })
                            .onAppear() {
                                self.newName = ""
                            }
                        }
                    //}
                    if selectedPlace != place {
                        Text(place.name)
                    }
                    Text("\(place.longitude), \(place.latitude)")
                }
                .onTapGesture {
                    print("\(place.name) is tapped")
                    selectedPlace = place
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
