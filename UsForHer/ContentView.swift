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
                HStack{
                    Spacer()
                    Image("tlogo")
                        .resizable()
                        .padding(.top, 20.0)
                        .frame(width:158, height:106)
                        
                    
                    Spacer()
                }
                .position(x:100, y:70)
                
                
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        addButtonState = true
                        
                    } label: {
                        Image("add")
                            .resizable()
                            .frame(width: 100, height: 100)

                    }
                    .position(x:325,y:350)
                    
                }
            }
            
            //add Menu
            //!
            if(!addButtonState){
                ZStack{
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.black)
                        .frame(width: 352, height: 602)
                        .cornerRadius(20.0)
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 350, height: 600)
                        .cornerRadius(20.0)
                    
                    HStack{
                        Spacer()
                        Text("Report an Incident")
                        Spacer()
                    }
                    //title
                    .font(.title)
                    .foregroundColor(Color.black)
                    .position(x: 195, y: 180)
                    
                    HStack{ //picking an incident
                        Picker("Test", selection: $selection) {
                            ForEach(0..<incidentOptions.count) {
                                Text(self.incidentOptions[$0])
                                    .foregroundColor(Color.black)
                                
                            }
                            
                        }
                        .position(x: 150, y: 270)
                        .frame(width: 300)
                    }
                    
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 325, height: 115, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:195,y:400)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .frame(width: 323, height: 113, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:195,y:400)
                    TextEditor( text: $userDescriptionInput)
                        .font(.title3)
                        .frame(width: 305, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:195,y:400)
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
                                .fill(Color.black)
                                .frame(width: 102.0, height: 52.0)
                                .cornerRadius(12)
                                .position(x:195,y:470)
                            Rectangle()
                                .fill(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                                .frame(width: 100.0, height: 50.0)
                                .cornerRadius(11)
                                .position(x:195,y:470)
                            
                            
                            
                            Text("Submit")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .position(x:195,y:470)
                            
                        }
                        Spacer()
                    }
                    
                    .position(x: 185, y: 640)
                    
                    Button() { //close button
                        addButtonState = false
                    } label: {
                        ZStack{
                            
                            
                            Image("exit")
                                .resizable()
                                .frame(width:60, height:65)
                        }
                    }
                    .frame(width: 30, height: 30)
                    .position(x: 345, y:160)
                    
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


