//
//  ContentView.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.05))
    

    
    var body: some View {
        ZStack{
            MapView(coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945))
                .frame(height: 860)
            VStack{
               
                HStack{
                    Spacer()
                    Text("Us for Her")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .padding(.top, 41.0)
                        
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
