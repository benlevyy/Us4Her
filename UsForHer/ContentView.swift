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
    //General Variables
    @ObservedObject var locManager = LocationManager()
    @State var addButtonState: Bool = false
    private var incidentOptions = ["Verbal Assault/Cat Call", "Suspicious Behaviour", "Following/Stalking", "Other"]
    @State private var selection = 1
    @State var otherUserInput: String = ""
    @State var userDescriptionInput: String = "Description"
    @State var submitState: Bool = false
    @State var mapSelector: Bool = false
    @State private var locSelection = 1
    private var locOptions = ["Use my Location", "Use other Location"]
    @State private var displayCircle: Bool = false
    let logoColor = Color(red: 0.9137, green: 0.6313, blue: 0.9058)
    
    @State var incidents = [IncidentPin]()
    //Map Stuff Variables
    
    @State var selctedPlace = MKPointAnnotation()
    @State var showingPlaceDetails = false
    //    @State var mapView : MapView = MapView()
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var zero = CLLocationCoordinate2D(latitude: 37.342159, longitude: -122.025620)
    
    //Time Management Variables
    @State var timeManager = TimeManager()
    let timer = Timer.publish(every: 30, on: .current, in: .common).autoconnect()
    @State var newDate = Date()
    
    //Notification Variable
    let locationNotificationScheduler = LocationNotificationScheduler()
    
    //Anti-Spam Variable
    @State var submitTime = Timestamp.init().seconds
    @State var mostRecentIncidentPin = IncidentPin.init(latitude: 0, longitude: 0, type: "", ExtraInfo: "", time: Timestamp.init(seconds: 0, nanoseconds: 0))
    
    
    //Getting Device Size()
    let screenSize = UIScreen.main.bounds.size
    
    
    //AntiSpam
    func checkIfEnoughTimePassed(_ submitTime: Timestamp, _ timePassed: Int64 ) -> Bool{
        let currentTime = Timestamp.init()
        let dif = currentTime.seconds - submitTime.seconds
        
        if(dif > timePassed){
            return true
        }
        return false
    }
    
    //Notifications
    func scheduleLocationNotification(_ sender: Any) {
        for element in incidents{
            let titleText = "WARNING: \(element.type) near your location)"
            let notInfo = LocationNotificationInfo.init(notificationId: element.id, locationId: element.id, radius: 1200, latitude: element.latitude, longitude: element.longitude, title: titleText, body: element.ExtraInfo)
            locationNotificationScheduler.requestNotification(with: notInfo)
        }
    }
    
    //General Update Method SUPER IMPORTANT (runs every second)
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
                if(incidents.count < lat.count){
                    for i in 0..<lat.count{
                        print("ARRAYS DONT MATCH....UPDATING")
                        incidents.append(IncidentPin(id : id[i] as! String, latitude: lat[i] as! Double, longitude: long[i] as! Double, type: t[i] as! String, ExtraInfo: extraInfo[i] as! String, time: time[i] as! Timestamp))
                    }
                    }else{
                        print("ARRAY MATCHES DB")
                    }
                
                print("Running Update")
                var removeList = [String]()
                
                for element in incidents {
                    if(checkIncidentTime(element, 43200)){
                        remove(element)
                        let targetID: String = element.id
                        removeList.append(targetID)
                        if(contains(id, element.id)){
                            ref.document(element.id).delete()
                            locationNotificationScheduler.deleteNotif(element.id)
                            print(" REMOVED ")
                        }
                    }
                }
                
            }
        scheduleLocationNotification(self) //compare db to
        locationNotificationScheduler.removeNotificationAfterShow() //delete already shown 
        
//2021-03-21 22:20:15.934527-0700 UsForHer[27466:5509415] [VKDefault] Style Z is requested for an invisible rect

    }
     func remove(_ element: IncidentPin){
        let index = find(value: element, in: incidents)!
        incidents.remove(at: index)
    }
    private func find(value searchValue: IncidentPin, in array: [IncidentPin]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value.id == searchValue.id {
                return index
            }
        }

        return nil
    }
    
    //Helper
    func contains(_ idArr: [Any],_ target: String)-> Bool{
        for elemennt in idArr{
            if(elemennt as! String == target){
                return true
            }
        }
        return false
        
    }
    //Helper
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
    func getRegion() -> MKCoordinateRegion{
        return MKCoordinateRegion(
            center: locManager.lastLocation?.coordinate ?? zero,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
    }
    func convertToAnnot()-> [mapAnnotation]{
        var out = [mapAnnotation]()
        for element in incidents{
            let loc = mapAnnotation(tag: element.id)
            loc.coordinate = element.coordinate
            loc.title = element.type
            loc.subtitle = element.ExtraInfo
            out.append(loc)
        }
        return out
    }
    var body: some View{
        let horizCenter = screenSize.width/2
        
        let mls: MapLocationSelect = MapLocationSelect(centerCoordinate: $centerCoordinate)
        ZStack{
            MV(annotations: convertToAnnot(), incidents: incidents)
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
                .position(x:100, y:100)
                
                
                Spacer()
                Spacer()
                Button {
                    //  scheduleLocationNotification(self)
                    addButtonState = true
                } label: {
                    ZStack{
                        Circle()
                            .fill(Color.black)
                            .frame(width: 66, height: 66)
                        Circle()
                            .fill(logoColor)
                            .frame(width: 59, height: 59)
                        Text("!")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                            .font(.custom("San Francisco", size: 40))
                    }
                }
                .position(x: (screenSize.width) - 70,y: (screenSize.height/2) - 70 )
                
                
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
                            .fontWeight(.bold)
                        Spacer()
                    }
                    //title
                    .font(.title)
                    .foregroundColor(Color.black)
                    .position(x: horizCenter, y: 240)
                    
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
                    
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 325, height: 165, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:horizCenter,y:510)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 323, height: 163, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:horizCenter,y:510)
                    
                    TextEditor( text: $userDescriptionInput)
                        .font(.title3)
                        .frame(width: 305, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .position(x:horizCenter,y:480)
                        .onTapGesture {
                            userDescriptionInput = ""
                        }
                    
                    
                    //next button
                    Button(){
                        //close the view
                        addButtonState = false
                        mapSelector = true
                        
                        UIApplication.shared.endEditing() // Call to dismiss keyboard
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
                        
//                        Circle()
//                            .fill(Color.blue)
//                            .opacity(0.3)
//                            .frame(width: 32, height: 32)
                        
                        Image("MapMarker")
                            .resizable()
                            .frame(width: 90.0, height: 90.0)
                            
                            
                            
                        
                    }
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.black)
                        .frame(width: 352, height: 142)
                        .cornerRadius(20.0)
                        .position(x: horizCenter, y: 200)
                    
                    Rectangle() //creating rectangle for incident report
                        .fill(Color.white)
                        .frame(width: 350, height: 140)
                        .cornerRadius(19.0)
                        .position(x: horizCenter, y: 200)
                    
                    HStack{
                        Spacer()
                        Text("Where?")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    .font(.title)
                    .foregroundColor(Color.black)
                    .position(x: horizCenter, y: 150)
                    
                    
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
                    
                    
                    //Submit Button
                    
                    if(!checkIfEnoughTimePassed(mostRecentIncidentPin.time, 10)){
                        ZStack{
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 182.0, height: 37.0)
                                .cornerRadius(12)
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 180.0, height: 35.0)
                                .cornerRadius(11)
                            
                            
                            
                            Text("You just submitted!")
                                .font(.headline)
                                .foregroundColor(Color.white)
                            
                            
                        }
                        .position(x: horizCenter, y: 240)
                    }else{
                        
                        Button(){
                            var pos: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                            
                            if(locSelection == 0){
//                                mapView.addIncident(IncidentPin(latitude: locManager.lastLocation?.coordinate.latitude ?? 0.0 , longitude: locManager.lastLocation?.coordinate.longitude ?? 0.0, type: incidentOptions[selection], ExtraInfo: userDescriptionInput, time: Timestamp(seconds: 0, nanoseconds: 0)
//                                ))
                                pos = CLLocationCoordinate2D(latitude: locManager.lastLocation?.coordinate.latitude ?? 0.0, longitude: locManager.lastLocation?.coordinate.longitude ?? 0.0)
                                
                            }
                            if(locSelection == 1){
//                                mapView.addIncident(IncidentPin(latitude: mls.getCenterLat(), longitude: mls.getCenterLong(), type:  incidentOptions[selection], ExtraInfo: userDescriptionInput, time: Timestamp(seconds: 0, nanoseconds: 0)
//                                ))
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
                            
                            mostRecentIncidentPin = IncidentPin.init(latitude: pos.latitude, longitude: pos.longitude, type: incidentOptions[selection], ExtraInfo: userDescriptionInput, time: Timestamp.init()) //save most recent incident to check for spam
                            
                            userDescriptionInput = ""
                            mapSelector = false
                            update()
                        } label:{
                            ZStack{
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 72.0, height: 37.0)
                                    .cornerRadius(12)
                                Rectangle()
                                    .fill(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/)
                                    .frame(width: 70.0, height: 35.0)
                                    .cornerRadius(11)
                                Text("Submit")
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                
                            }
                        }
                        .position(x: horizCenter, y: 240)
                    }
                    
                }
                
            }
            
        }
        .onAppear(){
            locationNotificationScheduler.clearAll()
            incidents.removeAll()
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


