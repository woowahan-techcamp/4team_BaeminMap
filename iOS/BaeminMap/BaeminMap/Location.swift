//
//  Location.swift
//  BaeminMap
//
//  Created by HannaJeon on 2017. 8. 7..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import Foundation

class Location {
    static var sharedInstance = Location()
    private(set) var latitude: Double
    private(set) var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init() {
        self.init(latitude: 37.5168734, longitude: 127.1106057)
    }
}
