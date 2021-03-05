//
//  ContentView.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    

    
    var body: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275))
            .frame(height: 100)
            
        HStack{
            VStack(alignment: .center){
                Text("Us4Her")
                    .font(.title)
                    .padding()
            Spacer();
                }
        Spacer();
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}
