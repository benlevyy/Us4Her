//
//  NonClusteringMKMarkerAnnotationView.swift
//  UsForHer
//
//  Created by Ben Levy on 3/27/21.
//

import UIKit
import MapKit

class NonClusteringMKMarkerAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            displayPriority = MKFeatureDisplayPriority.required
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
