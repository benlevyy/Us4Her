import SwiftUI
import MapKit


struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
  //  @State var coordinate: CLLocationCoordinate2D
    
    
/*
     map view delegete important
     */
    @State var region = MKCoordinateRegion()
        
    @ObservedObject var locManager = LocationManager()

    public var incidents = [IncidentPin]()

    
     @State  public var buttonDisplayedState: Bool = false
     @State public var displayedInfo: IncidentPin =  IncidentPin(latitude: 0, longitude: 0, type: "", ExtraInfo: "")
    private var zeroIncident = IncidentPin(latitude: 0, longitude: 0, type: "", ExtraInfo: "") //cleared var

    
    private var zero = CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620)
    
    
    public mutating func addIncident(_ input: IncidentPin){
       // print(input)
        incidents.append(input)
    }
    
     func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: locManager.lastLocation?.coordinate ?? zero,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
       // print(region)
    }
    
    public func saveInfo(_ input: IncidentPin){
        displayedInfo = input
    }
    
    public func clearVars(){
        displayedInfo = zeroIncident
        buttonDisplayedState = false
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
                Button(){
                    buttonDisplayedState = true
                    saveInfo(incident)
                } label: {
                Circle()
                    .strokeBorder(Color.red, lineWidth: 10)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .frame(width: 44, height: 44)
                }
            }
            
        }
        .onAppear{
            setRegion(locManager.lastLocation?.coordinate ?? zero )
        }
    }


}
