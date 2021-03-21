//
//  mapAnnotation.swift
//  UsForHer
//
//  Created by Ben Levy on 3/20/21.
//

import Foundation
import MapKit
class mapAnnotation: MKPointAnnotation {
     var tag: String

     init(tag: String) {
          self.tag = tag
     }
}
