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
    private var zero: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620)
        //Ortega Park Long: 37.342159, Lat -122.025620
        //if location is not allowed this is the location shown instead
    }
    var userCoords: CLLocationCoordinate2D{
        return locManager.lastLocation?.coordinate ?? zero
        //active user coordinates
    }
    
    
    @State var addButtonState: Bool = false
    
    private var incidentOptions = ["Cat Call", "Suspicous Vehicle", "Other"]
    @State private var selection = 1
    @State var otherUserInput: String = ""
    @State var userDescriptionInput: String = "Desription"
    
    
    
    var body: some View {
        ZStack{
            MapView(coordinate: userCoords)
                .frame(height: 860) //change size
            
            VStack{
                Spacer()
                    .frame(height: 35)
                HStack{
                    
                    Image("tlogo")
                        .padding(.top, 20.0)
                        .frame(width:158, height:86)
                    
                    Spacer()
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
            if(addButtonState){
                ZStack{
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 352, height: 502)
                        .cornerRadius(20.0)
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 350, height: 500)
                        .cornerRadius(20.0)
                    
                    
                    Text("Report an Incident") //title
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
                    
                    if(selection == 2){ //if selection == other
                        TextField("Enter the type of Incident", text: $otherUserInput)
                            .position(x: 230, y: 350)
                    }
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 325, height: 115, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .frame(width: 323, height: 113, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    TextEditor( text: $userDescriptionInput)
                        .font(.title3)
                        .frame(width: 305, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
            
        }
        
        
        
    }
}
extension ContentView { //if loc isn't enable redirect user to go to settings
    func goToDeviceSettings() {
        guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
