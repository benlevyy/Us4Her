import SwiftUI
import MapKit
import FirebaseDatabase
import Firebase


struct MapView: View {
    
    @State var userTrackingMode: MapUserTrackingMode = .none
    
    /*
     map view delegete important
     */
    @State var region = MKCoordinateRegion()
    
    @ObservedObject var locManager = LocationManager()
    
    public var incidents = [IncidentPin]()
    
    
    @State  public var buttonDisplayedState: Bool = false
    @State public var displayedInfo: IncidentPin =  IncidentPin(latitude: 0, longitude: 0, type: "", ExtraInfo: "")
    @State private var zeroIncident = IncidentPin(latitude: 0, longitude: 0, type: "", ExtraInfo: "") //cleared var
    @State private var zero = CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620)
    
    private var displayUserSelectionAnnatation : Bool = false
    @State var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var centerCoordinate = CLLocationCoordinate2D  ()
    
    
    public mutating func addIncident(_ input: IncidentPin){
        // print(input)
        incidents.append(input)
        
        print("||||||")
        for element in incidents {
            print(element)
        }
    }
    
    func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: locManager.lastLocation?.coordinate ?? zero,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
    }
    
    

    
    public func saveInfo(_ input: IncidentPin){
        displayedInfo = input
        
        //debug
        print("info saved")
        print("button display state: ")
        print(buttonDisplayedState)
        
        
    }
    
    public func setCenter(){
        setRegion(locManager.lastLocation?.coordinate ?? zero)
        print("Center set")
    }
    
    public func clearVars(){
        displayedInfo = zeroIncident
        buttonDisplayedState = false
    }
    public func getRegion() -> Binding<MKCoordinateRegion>{
        return $region
    }
    
    public func getColor(_ input: IncidentPin)-> Color{
        let incidentOptions = ["Verbal Assualt/Cat Call", "Suspicous Behaviour", "Following/Stalking", "Other"]
        
        if(input.type.elementsEqual( incidentOptions[0])){
            return Color.red
        }
        if(input.type.elementsEqual( incidentOptions[1])){
            return Color.yellow
        }
        if(input.type.elementsEqual( incidentOptions[2])){
            return Color.orange
        }
        return Color.gray
    }
    func getZoom(_ regionDelta: Double) -> CGFloat{
        return 5 / CGFloat(regionDelta)
    }
 
    var body: some View {
        Map(
            coordinateRegion: getRegion(),
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: incidents
        ){ incident in
  //          MapMarker(coordinate: incident.coordinate , tint: getColor(incident)){
            MapAnnotation(coordinate: incident.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                Button(){
                    buttonDisplayedState = true
                    saveInfo(incident)
                } label: {
                    Circle()
                        .fill(getColor(incident))
                        .opacity(0.4)
                        .frame(width: getZoom(region.span.latitudeDelta) , height: getZoom(region.span.longitudeDelta))  //ADD MULTIPLIER TO SCALE SIZE --- FIGURE OUT PROBLEM WITH ENUM
                    }
                }

            }
        
        
        .onAppear{
            setCenter()
        }
        
        
        Button(){
            setCenter()
        } label:{
            Image("Recenter")
                .resizable()
                .frame(width: 55, height: 55)
                
        }
        .position(x: 38, y: 800)
        
        
        if(buttonDisplayedState){
            
            ZStack{
                Rectangle() //creating rectangle for incident report
                    .fill(getColor(displayedInfo))
                    .frame(width: 364, height: 264)
                    .cornerRadius(20.0)
                
                Rectangle() //creating rectangle for incident report
                    .fill(Color.white)
                    .frame(width: 352, height: 252)
                    .cornerRadius(14.0)
                
                HStack{
                    Spacer()
                    Text(displayedInfo.type)
                    Spacer()
                }
                //title
                .font(.title)
                .foregroundColor(Color.black)
                .position(x: 195, y: 330)
                
                HStack{
                    Text(displayedInfo.ExtraInfo)
                        .frame(width: 340, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                
                
                Button() { //close button
                    buttonDisplayedState  = false
                    clearVars()
                } label: {
                    ZStack{
                        Image("exit")
                            .resizable()
                            .frame(width: 50, height: 52)

                    }
                }
                .position(x: 350, y:325)
                
            }
            
            
        }
        
        
    }
}

