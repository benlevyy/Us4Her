//
//  LocationNotificationInfo.swift
//  UsForHer
//
//  Created by Ben Levy on 3/18/21.
//

import Foundation
import CoreLocation

struct LocationNotificationInfo {
    
    // Identifiers
    let notificationId: String
    let locationId: String
    
    // Location
    let radius: Double
    let latitude: Double
    let longitude: Double
    
    // Notification
    let title: String
    let body: String    
    /// CLLocation Coordinates
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude,
                                      longitude: longitude)
    }
}
