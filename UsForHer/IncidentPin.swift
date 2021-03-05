//
//  IncidentPin.swift
//  UsForHer
//
//  Created by Ben Levy on 3/4/21.
//

import Foundation
import SwiftUI
import CoreLocation


class IncidentPin: Codable{
    var type: String
    var ExtraInfo: String
    var lat: Double
    var lon: Double
    
    private var coordinates: Coordinates

    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
    }

    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
