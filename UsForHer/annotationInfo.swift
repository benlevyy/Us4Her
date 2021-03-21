//
//  annotationInfo.swift
//  UsForHer
//
//  Created by Ben Levy on 3/20/21.
//

import SwiftUI
import Firebase


struct annotationInfo: View {
    
     var displayedInfo : IncidentPin
    
    @State var enabled = true
    
    let screenSize = UIScreen.main.bounds.size
    
    public func getColor(_ input: IncidentPin)-> Color{
        let incidentOptions = ["Verbal Assualt/Cat Call", "Suspicous Behaviour", "Following/Stalking", "Other"]
        
        if(input.type.elementsEqual( incidentOptions[0])){
            return Color.red
        }
        if(input.type.elementsEqual( incidentOptions[1])){
            return Color.yellow
        }
        if(input.type.elementsEqual( incidentOptions[2])){
            return Color.orange
        }
        return Color.gray
    }
    
    func hoursFromIncident(_ input: IncidentPin) -> String{
        let incidentTimestamp : Double = Double(input.time.seconds)
        let curTimestamp : Double = Double(Timestamp.init().seconds)
        
        let difTimestamp = curTimestamp - incidentTimestamp
        
        let difHours = difTimestamp / 3600
        
        let roundedDif = (difHours).rounded()
        let convertedToInt : Int64 = Int64(roundedDif)
        if(convertedToInt == 0){
            return "Within the Last Hour"
        }
        return "\(convertedToInt) hours ago"

    }
    
    
    var body: some View {
        if(enabled){
        ZStack{
            Rectangle() //creating rectangle for incident report
                .fill(getColor(displayedInfo))
                .frame(width: 364, height: 264)
                .cornerRadius(20.0)
            
            Rectangle() //creating rectangle for incident report
                .fill(Color.white)
                .frame(width: 352, height: 252)
                .cornerRadius(14.0)
            
            HStack{
                Spacer()
                Text(displayedInfo.type)
                    .fontWeight(.bold)
                Spacer()
            }
            //title
            .font(.title)
            .foregroundColor(Color.black)
            .position(x: (screenSize.width/2), y: 330)
            
            HStack{
                Text(displayedInfo.ExtraInfo)
                    .frame(width: 340, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            Text("\(hoursFromIncident(displayedInfo))")
                .fontWeight(.thin)
                .position(x: (screenSize.width/2), y: 530)

            
            
            Button() { //close button
                enabled = false
             //   clearVars()
            } label: {
                ZStack{
                    Image("exit")
                        .resizable()
                        .frame(width: 50, height: 52)

                }
            }
            .position(x: 350, y:325)
            
        }
        }
        
        
    }
}

struct annotationInfo_Preivews: PreviewProvider{
    static var previews: some View{
        annotationInfo(displayedInfo: IncidentPin(latitude: 0, longitude: 0, type: "", ExtraInfo: "", time: Timestamp.init()))
    }
}



