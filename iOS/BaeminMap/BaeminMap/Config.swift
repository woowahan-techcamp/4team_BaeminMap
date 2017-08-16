//
//  Config.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import Foundation

class Config {
    static private let plist: NSDictionary? = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: path) else { return nil }
        return plist
    }()
    
    static let googleMapKey: String = {
        return plist?["GoogleMapApiKey"] as! String
    }()
    
    static let standardURL: String = {
        return plist?["standardURL"] as! String
    }()
    
}
