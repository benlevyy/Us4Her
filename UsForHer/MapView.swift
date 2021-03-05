import SwiftUI
import MapKit


struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    var coordinate: CLLocationCoordinate2D
    @State private var region = MKCoordinateRegion()
    
    private let locationsToDisplay: [IncidentPin] = [
        IncidentPin(id: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), type: "Penis", ExtraInfo: "yash is shit")
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
            annotationItems: locationsToDisplay
        )
        { location -> MapMarker in
            let marker = MapMarker(coordinate: locationsToDisplay[0].loc)
            return marker
        }
        .onAppear{
            setRegion(coordinate)
        }
    }

}
