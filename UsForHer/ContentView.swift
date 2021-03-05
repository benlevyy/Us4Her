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
     Add center button which relocated map to current pos
     */
    @State var locationManager = CLLocationManager()
     @State var showMapAlert = false

    
    var body: some View {
        ZStack{
            MapView(locationManager: $locationManager, showMapAlert: $showMapAlert)
                .frame(height: 850) //change size
                 .alert(isPresented: $showMapAlert) { //this happens if user has location off
                   Alert(title: Text("Location access denied"),
                         message: Text("Your location is needed"),
                         primaryButton: .cancel(),
                         secondaryButton: .default(Text("Settings"),
                                                   action: { self.goToDeviceSettings() }))
             }
            VStack{
                HStack(){
                    Spacer()
                    Image("logo")
                        .shadow(radius: 10)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                    Spacer()
                }

               Spacer()
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
