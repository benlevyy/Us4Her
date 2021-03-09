import SwiftUI
import MapKit


struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
  //  @State var coordinate: CLLocationCoordinate2D
    @State var region = MKCoordinateRegion()
        
    @ObservedObject var locManager = LocationManager()

    @State var incidents: [IncidentPin] = [
        IncidentPin(latitude: 37.342159, longitude: -122.025620, type: "test", ExtraInfo: "Ex Test"),
        IncidentPin(latitude: 0, longitude: 4, type: "test2", ExtraInfo: "Ex Test2"),
        IncidentPin(latitude: 0, longitude: 6, type: "test3", ExtraInfo: "Ex Test3")
        
        
    ]
    
    @State var lonZ : Double = 0.2
    @State var latZ : Double = 0.2

    

    
    
    private var zero = CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620)
    
    public func addIncident(_ i: IncidentPin){
        print("added to array")
        incidents.append(i)
    }
    
     func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: locManager.lastLocation?.coordinate ?? zero,
            span: MKCoordinateSpan(latitudeDelta: latZ, longitudeDelta: lonZ)
        )
       // print(region)
    }
    
    
        
    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: incidents
        ){ incident in
            MapAnnotation(coordinate: incident.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                Circle()
                    .strokeBorder(Color.red, lineWidth: 10)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .frame(width: 44, height: 44)
            }
        }
        .onAppear{
            setRegion(locManager.lastLocation?.coordinate ?? zero )
        }
    }


}
