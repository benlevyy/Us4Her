import SwiftUI
import MapKit


struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @State var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
        
    @State var incidents: [IncidentPin] = [
        IncidentPin(latitude: 0, longitude: 2, type: "test", ExtraInfo: "Ex Test"),
        IncidentPin(latitude: 0, longitude: 4, type: "test2", ExtraInfo: "Ex Test2"),
        IncidentPin(latitude: 0, longitude: 6, type: "test3", ExtraInfo: "Ex Test3")

    ]
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
    
    
        
    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: incidents
        ){ incident in
            MapPin(coordinate: incident.coordinate)
        }
        .onAppear{
            setRegion(coordinate)
        }
    }


}
