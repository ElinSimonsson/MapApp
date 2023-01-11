//
//  ListOfPlacesView.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import SwiftUI

struct ListOfPlacesView: View {
    @EnvironmentObject var places : Places
    @State var selectedPlace : Place? = nil
    @State var newName = ""
    @FocusState var isFocused : Bool
    
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
                    Text("\(place.longitude), \(place.latitude)")
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
}



//struct ListOfPlacesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListOfPlacesView()
//    }
//}
