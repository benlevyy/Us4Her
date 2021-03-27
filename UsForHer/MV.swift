//
//  MV.swift
//  UsForHer
//
//  Created by Ben Levy on 3/21/21.
//

import SwiftUI
import MapKit
import Firebase

struct MV: UIViewRepresentable {
    var annotations: [MKPointAnnotation]
    var incidents: [IncidentPin]
    @State var selectedAnnotation = mapAnnotation(tag: "", time: Timestamp.init())
    @State var locManager = LocationManager()
    
    var didSelect: (mapAnnotation) -> ()  // callback
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region =  MKCoordinateRegion(center: locManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false

        return mapView
    }
    func getAnnotCount()->Int{
        return annotations.count
    }
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MV
        
        init(_ parent: MV) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let annotationView = NonClusteringMKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.animatesWhenAdded = true
            annotationView.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure) //creating button
            annotationView.rightCalloutAccessoryView = btn
            switch annotation.title!! {
            case "Verbal Assault/Cat Call":
                annotationView.markerTintColor = UIColor.red
                annotationView.glyphImage = UIImage(named: "VerbalAssult")
            case "Suspicious Behaviour":
                annotationView.markerTintColor = UIColor.blue
                annotationView.glyphImage = UIImage(named: "SuspicousBehavior")
            case "Following/Stalking":
                annotationView.markerTintColor = UIColor.yellow
                annotationView.glyphImage = UIImage(named: "FollowingStalking")
            case "Other":
                annotationView.markerTintColor = UIColor.gray
                annotationView.glyphImage = UIImage(named: "OtherIcon")
            case "My Location":
                annotationView.markerTintColor = .clear
                annotationView.canShowCallout = false
                annotationView.image = UIImage(named: "user location")
                annotationView.titleVisibility = MKFeatureVisibility.hidden
            default:
                annotationView.markerTintColor = UIColor.gray
            }
            
            return annotationView
        }
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let v = view.annotation as? mapAnnotation{
                parent.didSelect(v) // << here !!
            }
        }
    }
}
