//
//  MapLocationSelect.swift
//  UsForHer
//
//  Created by Ben Levy on 3/14/21.
//
import MapKit

import SwiftUI



struct MapLocationSelect: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @ObservedObject var locManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    
    func getCenterLat() -> Double{
        return self.centerCoordinate.latitude
    }
    func getCenterLong() -> Double{
        return self.centerCoordinate.longitude
    }
    func makeUIView(context: Context) -> MKMapView {
        let mapLocationSelect = MKMapView()
        mapLocationSelect.delegate = context.coordinator
        return mapLocationSelect
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("Updating")
        uiView.showsUserLocation = true
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapLocationSelect
        
        init(_ parent: MapLocationSelect) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
    }
    
}

extension MKPointAnnotation{
    static var example: MKPointAnnotation{
        let annatation = MKPointAnnotation()
        annatation.title = "London"
        annatation.subtitle = "Home to the 2012 Summer Olympics"
        annatation.coordinate = (CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13))
        return annatation
    }
}
struct MapLocationSelect_Previews: PreviewProvider {
    static var previews: some View {
        MapLocationSelect(centerCoordinate: .constant(MKPointAnnotation.example.coordinate))
    }
}

