//
//  ContentView.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import SwiftUI
import MapKit


struct ContentView: View {
    
    
    
    
    @ObservedObject var locManager = LocationManager()
    
    //user tracking
    //    lazy var zero: CLLocationCoordinate2D =  {
    //        return CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620)
    //        //Ortega Park Long: 37.342159, Lat -122.025620
    //        //if location is not allowed this is the location shown instead
    //    }()
    //    @State var userCoords: CLLocationCoordinate2D = {
    //        return (locManager.lastLocation!.coordinate ?? zero)
    //        //active user coordinates
    //    }
    
    
    @State var addButtonState: Bool = false
    
    private var incidentOptions = ["Verbal Assualt/Cat Call", "Suspicous Behaviour", "Following/Stalking", "Other"]
    @State private var selection = 1
    @State var otherUserInput: String = ""
    @State var userDescriptionInput: String = "Description"
    @State var submitState: Bool = false
    
    @State var mapView : MapView =  MapView()


    
    
    var body: some View {
        
        ZStack{
 
                
            mapView
                .frame(height: 860) //change size
            
            VStack{
                Spacer()
                    .frame(height: 35)
                HStack{
                    
                    //  Image("tlogo")
                    //                        .padding(.top, 20.0)
                    //  .frame(width:158, height:86)
                    //
                    //  Spacer()
                }
                .padding(.leading, 30.0)
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        addButtonState = true
                        
                    } label: {
                        Image("add")
                    }
                    .padding(.bottom, 50.0)
                    .padding(.trailing, 25.0)
                    .shadow(radius: 10)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }
            
            //add Menu
            //!
            if(addButtonState){
                ZStack{
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.black)
                        .frame(width: 352, height: 502)
                        .cornerRadius(20.0)
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 350, height: 500)
                        .cornerRadius(20.0)
                    
                    HStack{
                        Spacer()
                        Text("Report an Incident")
                        Spacer()
                    }
                    //title
                    .font(.title)
                    .foregroundColor(Color.black)
                    .position(x: 185, y: 220)
                    
                    HStack{ //picking an incident
                        Picker("Test", selection: $selection) {
                            ForEach(0..<incidentOptions.count) {
                                Text(self.incidentOptions[$0])
                                    .foregroundColor(Color.black)
                                
                            }
                            
                        }
                        .position(x: 150, y: 320)
                        .frame(width: 300)
                        
                    }
                    .padding(.trailing, 0.0)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 325, height: 115, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .frame(width: 323, height: 113, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    TextEditor( text: $userDescriptionInput)
                        .font(.title3)
                        .frame(width: 305, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    //submit button
                    Button(){
                        //close the view
                        addButtonState = false
                        //append data to array
                        mapView.addIncident(IncidentPin(latitude: locManager.lastLocation?.coordinate.latitude ?? 0.0 , longitude: locManager.lastLocation?.coordinate.longitude ?? 0.0, type: incidentOptions[selection], ExtraInfo: userDescriptionInput))
                        
                        print("|||||")
                        for element in mapView.incidents {
                            print(element)
                        }
                        
                        UIApplication.shared.endEditing() // Call to dismiss keyboard
                        
                    } label:{
                        Spacer()
                        ZStack{
                            Rectangle()
                                .fill(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                                .frame(width: 100.0, height: 50.0)
                                .cornerRadius(12)
                            
                            Text("Submit")
                                .font(.title)
                                .foregroundColor(Color.white)
                            
                        }
                        Spacer()
                    }
                    
                    .position(x: 185, y: 640)
                    
                    Button() { //close button
                        addButtonState = false
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
                    .position(x: 340, y:210)
                    
                }
                
            }
//            Button(){
//                mapView.centerMapOnLocation(location: locManager.lastLocation!.coordinate)
//            } label: {
//                Text("recenter")
//            }
            
        }
    }
}

extension ContentView { //if loc isn't enable redirect user to go to settings
    func goToDeviceSettings() {
        guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
    
    
}


