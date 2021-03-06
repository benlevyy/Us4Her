//
//  IncidentPin.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import Foundation
import SwiftUI
import CoreLocation


struct IncidentPin: Identifiable {


//properties
    var id = UUID()
    var latitude: Double
    var longitude: Double
    var type: String
    var ExtraInfo: String
    var coordinate: CLLocationCoordinate2D {
      return .init(latitude: latitude, longitude: longitude)
    }

    


}
