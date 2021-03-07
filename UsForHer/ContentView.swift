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
        return CLLocationCoordinate2D(latitude: 0, longitude: 0) //if location is not allowed this is the location shown instead
    }
    var userCoords: CLLocationCoordinate2D{
        return locManager.lastLocation?.coordinate ?? zero
        //active user coordinates
    }
    
    
    @State var addButtonState: Bool = false
    @State private var typeUserInput = ""
    
    
    var body: some View {
        ZStack{
            MapView(coordinate: userCoords)
                .frame(height: 850) //change size
            
            VStack{
                Spacer()
                    .frame(height: 35)
                HStack(){
                    Spacer()
                    Image("LogoV2")
                        .resizable()
                        .frame(width:158, height:86)
                        .shadow(radius: 5)
                        .shadow(radius: 5)
                    
                    Spacer()
                }
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
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 350, height: 200)
                                .cornerRadius(20.0)
                            VStack{
                                Text("Report an Incident")
                                    .padding(.bottom, 150.0)
                            }
//                            TextField("Enter Type of Incident:", text: $typeUserInput, onCommit: {print("Commit")})
                            HStack{
                                VStack{
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
