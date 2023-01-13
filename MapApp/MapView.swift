//
//  MapView.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-11.
//

import SwiftUI
import MapKit

struct MapView: View {
    //var locationManager = LocationManager()
    var locationManager : LocationManager
    @EnvironmentObject var places : Places
    @State var map = MKMapView()
    @State var longPressLocation = CGPoint.zero
    @State var customPlace = Place(name: "", latitude: 0, longitude: 0)
    @State var addNewNamePlace = ""
    @State var isAddingName = true
    @FocusState var isFocused : Bool
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    
//    init() {
//        locationManager.startLocationUpdates()
//    }
    
    var body: some View {
        GeometryReader { proxy in
            Map(coordinateRegion: $region,
                interactionModes: [.all],
                showsUserLocation: true,
                userTrackingMode: .constant(.follow),
                annotationItems: places.places) { place in
               // MapMarker(coordinate: place.coordinate) //default map Marker
                MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) { // create own content on every map marker
                    VStack {
                        MapPinMarker(place: place)
                            .onTapGesture {
                                isAddingName = true
                            }
                        if place.name == "" && isAddingName {
                            TextField("New place´s name", text: $addNewNamePlace, onCommit: {
                                places.updateName(place: place, with: self.addNewNamePlace)
                                isAddingName = false
                                isFocused = false
                            }).focused($isFocused)
                            
                                .padding()
                                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                                .onAppear() {
                                    isFocused = true
                                    self.addNewNamePlace = ""
                                }
                        }
                    }
                }
            }
                .gesture(LongPressGesture(
                    minimumDuration: 0.25)
                    .sequenced(before: DragGesture(
                        minimumDistance: 0,
                        coordinateSpace: .local))
                        .onEnded { value in
                            switch value {
                            case .second(true, let drag):
                                longPressLocation = drag?.location ?? .zero
                                addPlaceByTap(at: longPressLocation, for: proxy.size)
                                
                            default:
                                break
                            }
                        })
                .highPriorityGesture(DragGesture(minimumDistance: 10))
        }
        
        Button(action:  {
            addPin()
            print("want to add")
        }) {
            Text("Add pin")
        }
    }
    
    func addPlaceByTap (at point: CGPoint, for mapSize: CGSize) {
        let lat = region.center.latitude
        let lon = region.center.longitude
        
        let mapCenter = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
        
        // X
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let xSpan = xValue * region.span.longitudeDelta/2
        
        // Y
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        let ySpan = yValue * region.span.latitudeDelta/2
        
        places.addPlaceWithLL(latitude: lat-ySpan, longitude: lon + xSpan)
        isAddingName = true
        
    }
    
    func addPin () {
        
        if let location = locationManager.location {
            print("funktion addpin körs")
            let newPlace = Place(name: "",
                                 latitude: location.latitude,
                                 longitude: location.longitude)
            places.addPlace(place: newPlace)
            isAddingName = true
        }
    }
    
}

struct MapPinMarker : View {
    var place : Place
    
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .resizable()
                .frame(width: 30, height: 30)
            Text(place.name)
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
