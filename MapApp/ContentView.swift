//
//  ContentView.swift
//  MapApp
//
//  Created by Elin Simonsson on 2023-01-10.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    var locationManager = LocationManager()
    @EnvironmentObject var places : Places
    @State var showList = false
    @State var map = MKMapView()
    @State var longPressLocation = CGPoint.zero
    @State var customPlace = Place(name: "", latitude: 0, longitude: 0)
    @State var addNewNamePlace = ""
    @State var isAddingName = true
    @State var showMap = true
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.3323341, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    init() {
        locationManager.startLocationUpdates()
    }
    
    
    var body: some View {
        if places.showMap {
            GeometryReader { proxy in
                Map(coordinateRegion: $region,
                    interactionModes: [.all],
                    showsUserLocation: true,
                    userTrackingMode: .constant(.follow),
                    annotationItems: places.places) { place in
                    MapMarker(coordinate: place.coordinate) //default map Marker
//                    MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) { // create own content on every map marker
//                        VStack {
//                            MapPinMarker(place: place)
//                                .onTapGesture {
//                                    isAddingName = true
//                                }
//                            if place.name == "" && isAddingName {
//                                TextField("New place´s name", text: $addNewNamePlace, onCommit: {
//                                    places.updateName(place: place, with: self.addNewNamePlace)
//                                    isAddingName = false
//                                }
//
//                                )
//                                    .padding()
//                                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
//                                    .onAppear() {
//                                        self.addNewNamePlace = ""
//                                    }
//                            }
//                        }
//                    }
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
//            .onDisappear() {
//                cleanupMap()
//            }
            
            Button(action:  {
                addPin()
            }) {
                Text("Add pin")
            }
        }
//        else {
//            List  {
//            ForEach (places.places) { place in
//                    HStack {
//                        Text(place.name)
//                        Text("\(place.longitude), \(place.latitude)")
//                    }
//                }
//            }
//        }
        
        Spacer()
        
        Button(action: {
            places.showMap = false
            showMap = false
            showList = true
        }) {
            ButtonContent(text: "List")
        }
        .fullScreenCover(isPresented: $showList, content: ListOfPlacesView.init)
//        HStack {
//            Spacer()
//            Button(action: {
//                showList = false
//            }) {
//                ButtonContent(text: "Map")
//            }
//            Spacer()
//            Button(action: {
//                showList = true
//            }) {
//                ButtonContent(text: "List")
//            }
//            Spacer()
//        }
    }
    
    func cleanupMap() {
        // Step 1: Remove all references to the map
        map.delegate = nil
        map.removeFromSuperview()
       // map = nil
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
            let newPlace = Place(name: "",
                                 latitude: location.latitude,
                                 longitude: location.longitude)
            places.addPlace(place: newPlace)
            isAddingName = true
        }
    }
}

private extension ContentView {
    
    func convertTap(at point: CGPoint, for mapSize: CGSize) -> Place {
        let lat = region.center.latitude
        let lon = region.center.longitude
        
        let mapCenter = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
        
        // X
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let xSpan = xValue * region.span.longitudeDelta/2
        
        // Y
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        let ySpan = yValue * region.span.latitudeDelta/2
        
        return Place(name: "", latitude: lat - ySpan, longitude: lon + xSpan)
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

