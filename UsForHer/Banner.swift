//
//  Banner.swift
//  UsForHer
//
//  Created by Ben Levy on 3/31/21.
//

import Foundation
class Banner: ObservableObject {
     var Description: String
    var Version: String

    init(Description: String, Version: String) {
          self.Description = Description
            self.Version = Version
     }
}
