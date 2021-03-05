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
     Add plus button
     Create "adding incident pin" pop up
     Create hover view of other incident pin
     Add center button which relocated map to current pos
     */
    
    var body: some View {
        ZStack{
            MapView(coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945)) //this coordinate is a random tester coord. Should be changed to match user loc
                
                .frame(height: 860)  //change this to match resolution of any iphone
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}
