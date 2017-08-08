//
//  Config.swift
//  BeaminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation

class Config {
    static let googleMapKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
        let plist = NSDictionary(contentsOfFile: path) else { return String() }
        let key = plist["GoogleMapApiKey"] as! String
        return key
    }()
}
