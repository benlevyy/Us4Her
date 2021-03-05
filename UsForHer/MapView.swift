import SwiftUI
import MapKit

struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @ObservedObject var locManager = LocationManager()

    
    func getUserLoc() -> CLLocationCoordinate2D{
        return locManager.lastLocation!.coordinate
    }
    
    lazy var currentLoc :  CLLocationCoordinate2D = locManager.lastLocation!.coordinate
    
//    init(currentLoc: CLLocationCoordinate2D){
//        self.currentLoc = locManager.lastLocation!.coordinate
//    }

    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 39.3682791,
            longitude: -111.093750),
        span: MKCoordinateSpan(
            latitudeDelta: 10,
            longitudeDelta: 10
        )
    )

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode
        )
    }
}
