import SwiftUI
import MapKit


struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    
     var incidentPin: IncidentPin
    
    var incidents: [IncidentPin] = [
        .init(latitude: 0, longitude: 0, type: "test", ExtraInfo: "Ex Test")
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
        ){
            incidents in MapPin(coordinate: incidentPin.coordinate)

            
        }
        .onAppear{
            setRegion(coordinate)
        }
    }


}
