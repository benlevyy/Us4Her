//
//  ContentView.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import SwiftUI
import MapKit
import Firebase
import UIKit
import UserNotifications

struct ContentView: View {
    
    
    
    
    @ObservedObject var locManager = LocationManager()
    @State var addButtonState: Bool = false
    
    private var incidentOptions = ["Verbal Assualt/Cat Call", "Suspicous Behaviour", "Following/Stalking", "Other"]
    @State private var selection = 1
    @State var otherUserInput: String = ""
    @State var userDescriptionInput: String = "Description"
    @State var submitState: Bool = false
    
    @State var mapSelector: Bool = false
    @State private var locSelection = 1
    private var locOptions = ["Use my Location", "Use other Location"]
    @State private var displayCircle: Bool = false
    
    @State var mapView : MapView = MapView()
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var zero = CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620)
    
    @State var timeManager = TimeManager()
    let timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var newDate = Date()
    
    private let locationNotificationScheduler = LocationNotificationScheduler()

    func scheduleLocationNotification(_ sender: Any) {
        for element in mapView.incidents{
            let notInfo = LocationNotificationInfo.init(notificationId: element.id, locationId: element.id, radius: 500, latitude: element.latitude, longitude: element.longitude, title: element.type, body: element.ExtraInfo, data:  ["location": "NYC Brooklyn Promenade"])
            locationNotificationScheduler.requestNotification(with: notInfo)
        }
    }
    
    
    
    
    func update() {
        let ref = Firestore.firestore().collection("incident_DB")
        
        ref
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let id = documents.map{ $0 ["id"] ?? "ID NOT FOUND"}
                let t = documents.map { $0["type"]  ?? "INFO NOT FOUND" }
                let extraInfo = documents.map { $0["extra info"] ?? "INFO NOT FOUND" }
                let lat = documents.map { $0["lat"] ?? 0.0}
                let long = documents.map { $0["long"] ?? 0.0 }
                let time = documents.map{ $0["time"] ?? Timestamp(seconds: 0, nanoseconds: 0)}
                for i in 0..<lat.count{
                    if(mapView.incidents.count < lat.count){
                        mapView.incidents.append(IncidentPin(id : id[i] as! String, latitude: lat[i] as! Double, longitude: long[i] as! Double, type: t[i] as! String, ExtraInfo: extraInfo[i] as! String, time: time[i] as! Timestamp))
                    }else{
                        print("ARRAY FULL")
                    }
                }
                print("||||||")
                var removeList = [String]()
                for element in mapView.incidents {
                    print(element)
                    if(checkIncidentTime(element, 60)){
                        mapView.remove(element)
                        let targetID: String = element.id
                        removeList.append(targetID)
                        if(contains(id, element.id)){
                            ref.document(element.id).delete()
                            print(" REMOVED ")
                        }
                    }
                }
                
            }
//        scheduleLocationNotification(self)
        
    }
    
    func contains(_ idArr: [Any],_ target: String)-> Bool{
        for elemennt in idArr{
            if(elemennt as! String == target){
                return true
            }
        }
        return false
        
    }
    
    func checkIncidentTime(_ n: IncidentPin, _ timeBeforeDeletion: Int) -> Bool{
        let current = Timestamp.init()
        let currentSecCount = current.seconds
        let dif = currentSecCount - n.time.seconds
        if(dif > timeBeforeDeletion){
            print("Removing /\(n)")
            return true
        }
        print("Theres this much time left :/\(dif)")
        print("on /\(n)")
        return false
    }
    
    
    var body: some View {
        let mls: MapLocationSelect = MapLocationSelect(centerCoordinate: $centerCoordinate)
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
                      //  scheduleLocationNotification(self)
                        addButtonState = true
                    } label: {
                        Image("add") // CHANGE IMAGE
                            .resizable()
                            .frame(width: 100, height: 100)
                        
                    }
                    .position(x:325,y:350)
                    
                }
            }
            
            Text("")
                .onReceive(timer){ input in
                    update()
                }
                .position(x: 1000, y: 1000)
            
            if(addButtonState){
                ZStack{
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.black)
                        .frame(width: 352, height: 432)
                        .cornerRadius(20.0)
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 350, height: 430)
                        .cornerRadius(19.0)
                    
                    HStack{
                        Spacer()
                        Text("Report an Incident")
                        Spacer()
                    }
                    //title
                    .font(.title)
                    .foregroundColor(Color.black)
                    .position(x: 195, y: 240)
                    
                    HStack{ //picking an incident
                        Picker("Test", selection: $selection) {
                            ForEach(0..<incidentOptions.count) {
                                Text(self.incidentOptions[$0])
                                    .foregroundColor(Color.black)
                                
                            }
                            
                        }
                        .position(x: 150, y: 340)
                        .frame(width: 300)
                    }
                    
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: 325, height: 165, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:195,y:510)
                    
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color.white)
                        .frame(width: 323, height: 163, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:195,y:510)
                    
                    TextEditor( text: $userDescriptionInput)
                        .font(.title3)
                        .frame(width: 305, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:195,y:480)
                    
                    
                    
                    //next button
                    Button(){
                        //close the view
                        addButtonState = false
                        mapSelector = true
                        
                        UIApplication.shared.endEditing() // Call to dismiss keyboard
                        // update()
                        
                    } label:{
                        Text("Next")
                    }
                    
                    .position(x: 325, y: 620)
                    
                    Button() { //close button
                        addButtonState = false
                        //  update()
                    } label: {
                        ZStack{
                            
                            
                            Image("exit")
                                .resizable()
                                .frame(width:50, height:55)
                        }
                    }
                    .position(x: 345, y:240)
                    
                }
                
            }
            if(mapSelector){
                ZStack{
                    
                    if(locSelection == 1){
                        mls //map location select
                        
                        Circle()
                            .fill(Color.blue)
                            .opacity(0.3)
                            .frame(width: 32, height: 32)
                        
                    }
                    
                    
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.black)
                        .frame(width: 352, height: 142)
                        .cornerRadius(20.0)
                        .position(x: 195, y: 200)
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 350, height: 140)
                        .cornerRadius(19.0)
                        .position(x: 195, y: 200)
                    
                    HStack{
                        Spacer()
                        Text("Where?")
                        Spacer()
                    }
                    
                    .font(.title)
                    .foregroundColor(Color.black)
                    .position(x: 195, y: 150)
                    
                    
                    HStack{
                        Picker("loc", selection: $locSelection) {
                            ForEach(0..<locOptions.count) {
                                Text(self.locOptions[$0])
                                    .foregroundColor(Color.black)
                                
                            }
                            
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .position(x: 150, y: 190 )
                        .frame(width: 300)
                    }
                    Button(){
                        mapSelector = false
                        addButtonState = true
                    }label: {
                        Text("Back")
                        
                        
                    }
                    .position(x: 55, y: 245)
                    
                    
                    
                    Button(){
                        var pos: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                        
                        if(locSelection == 0){
                            mapView.addIncident(IncidentPin(latitude: locManager.lastLocation?.coordinate.latitude ?? 0.0 , longitude: locManager.lastLocation?.coordinate.longitude ?? 0.0, type: incidentOptions[selection], ExtraInfo: userDescriptionInput, time: Timestamp(seconds: 0, nanoseconds: 0)
                            ))
                            pos = CLLocationCoordinate2D(latitude: locManager.lastLocation?.coordinate.latitude ?? 0.0, longitude: locManager.lastLocation?.coordinate.longitude ?? 0.0)
                            
                        }
                        if(locSelection == 1){
                            mapView.addIncident(IncidentPin(latitude: mls.getCenterLat(), longitude: mls.getCenterLong(), type:  incidentOptions[selection], ExtraInfo: userDescriptionInput, time: Timestamp(seconds: 0, nanoseconds: 0)
                            ))
                            pos = CLLocationCoordinate2D(latitude: mls.getCenterLat(), longitude: mls.getCenterLong())
                        }
                        print("adding incident at")
                        print(Timestamp.init())
                        let curID = UUID().uuidString
                        
                        let incidentDictionary: [String: Any] = [
                            "id" : curID,
                            "type" : incidentOptions[selection],
                            "extra info":userDescriptionInput,
                            "lat": pos.latitude,
                            "long": pos.longitude,
                            "time": Timestamp.init()
                        ]
                        
                        let docRef = Firestore.firestore().document("incident_DB/\(curID)")
                        print("setting data")
                        
                        docRef.setData(incidentDictionary){ (error) in
                            if let error = error{
                                print("error = \(error)")
                            }else{
                                print("data uploaded successfully")
                            }
                        }
                        
                        mapSelector = false
                        //  update()
                    } label:{
                        ZStack{
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 72.0, height: 37.0)
                                .cornerRadius(12)
                            //.position(x:195,y:470)
                            Rectangle()
                                .fill(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                                .frame(width: 70.0, height: 35.0)
                                .cornerRadius(11)
                            //.position(x:195,y:470)
                            
                            
                            
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(Color.white)
                            // .position(x:195,y:470)
                            //.background(Color.blue)
                            
                        }
                    }
                    .position(x: 195, y: 240)
                    
                    
                }
                
            }
        }
        .onAppear(){
            update()
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


