import SwiftUI
import MapKit


struct MapView: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
        
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
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
    }
    
    func getExtraInfoState()-> Bool{
        return buttonDisplayedState
    }
    
    public func saveInfo(_ input: IncidentPin){
        displayedInfo = input
        
        //debug
        print("info saved")
        print("button display state: ")
        print(buttonDisplayedState)
      

    }

    
    
    public func clearVars(){
        displayedInfo = zeroIncident
        buttonDisplayedState = false
    }

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: MapInteractionModes.pan,
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
                    .fill(Color.red)
                    .opacity(0.2)
                    .frame(width: 100, height: 100)
                }
            }
            
        }
        .onAppear{
            setRegion(locManager.lastLocation?.coordinate ?? zero )
        }
        if(buttonDisplayedState){

                ZStack{
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.black)
                        .frame(width: 352, height: 252)
                        .cornerRadius(20.0)
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 350, height: 250)
                        .cornerRadius(20.0)
                    
                    HStack{
                        Spacer()
                        Text(displayedInfo.type)
                        Spacer()
                    }
                    //title
                    .font(.title)
                    .foregroundColor(Color.black)
                    .position(x: 185, y: 330)
                    
                    HStack{
                        Text(displayedInfo.ExtraInfo)
                            .frame(width: 340, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
        

                    Button() { //close button
                       buttonDisplayedState  = false
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color.black)
                                .frame(width: 40, height: 60)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 37, height: 38)
                            
                            
                            Image("exit")
                        }
                    }
                    .frame(width: 30, height: 30)
                    .position(x: 340, y:335)
                    
                }
            
             
               }
            

    }
    }
