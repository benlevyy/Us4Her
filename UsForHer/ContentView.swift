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
    
    private var genderOptions = ["Cat Call", "Suspicous Vehicle", "Other"]
    @State private var selection = 1
    
    
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
            if(!addButtonState){
                ZStack{
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 350, height: 200)
                        .cornerRadius(20.0)
                    
                    
                    Text("Report an Incident")
                        .font(.title)
                        .position(x: 185, y: 353)
                    
                    HStack{
                        Picker("Test", selection: $selection) {
                            ForEach(0..<genderOptions.count) {
                                Text(self.genderOptions[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        .position(x: 150, y: 390)
                        .frame(width: 300)
                    }
                    .padding(.trailing, 0.0)
                    
                    
                    Button() {
                        addButtonState = false
                    } label: {
                        Image("exit")                                    }
                    .frame(width: 30, height: 30)
                    .position(x: 340, y:350)
                    
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
