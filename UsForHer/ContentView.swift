//
//  ContentView.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import SwiftUI
import MapKit


struct ContentView: View {
    var test = CLLocationCoordinate2D(latitude: 38.593_382, longitude:  -103.829_884)
    
    var body: some View {
        HStack{
        VStack(alignment: .center){
        Text("Us4Her")
            .font(.title)
            .padding()
            
            Spacer();
        }
            Spacer();
        }
        MapView(coordinate: test)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
