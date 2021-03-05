//
//  IncidentPin.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import Foundation
import SwiftUI
import CoreLocation


struct IncidentPin {
    var type: String
    var ExtraInfo: String
    
    public var loc: CLLocationCoordinate2D
    
    init(loc: CLLocationCoordinate2D, type: String, ExtraInfo: String){
        self.loc = loc
        self.type = type
        self.ExtraInfo = ExtraInfo
    }
    


}
