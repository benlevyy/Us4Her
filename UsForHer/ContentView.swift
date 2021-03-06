//
//  ContentView.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import SwiftUI
import MapKit


struct ContentView: View {
    /*
     TO DO
     adjust startup location zoom
     Add plus button
     Create "adding incident pin" pop up
     Create hover view of other incident pin
     Add center button which relocate d map to current pos
     */
    
 
    @ObservedObject var locManager = LocationManager()

    
    private var zero: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: 0, longitude: 0) //if location is not allowed this is the location shown instead
    }
    
    var userCoords: CLLocationCoordinate2D{
        return locManager.lastLocation?.coordinate ?? zero
        //active user coordinates
    }
    
    
    var incidentsList: [IncidentPin] = [
        .init(latitude: 0, longitude: 0, type: "test", ExtraInfo: "Ex Test")
    ]
    var body: some View {
        ZStack{
            MapView(coordinate: userCoords, incidentPin: incidentsList[0])
                .frame(height: 850) //change size

            VStack{
                HStack(){
                    Spacer()
                    Image("logo")
                        .shadow(radius: 10)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                    Spacer()
                }
                Spacer()
                HStack{
                    Spacer()
                    Image("add")
                        .padding(.bottom, 50.0)
                        .padding(.trailing, 25.0)
                        .shadow(radius: 10)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
