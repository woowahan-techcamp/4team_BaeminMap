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
    
    static let clientID: String = {
        return plist?["ClientID"] as! String
    }()
    
    static let clientSecret: String = {
        return plist?["ClientSecret"] as! String
    }()
    
    static let tokenURL: String = {
        return plist?["TokenURL"] as! String
    }()
    
    static let baeminID: String = {
        return plist?["BaeminID"] as! String
    }()
    
    static let baeminPassword: String = {
        return plist?["BaeminPassword"] as! String
    }()
    
    static let baeminApiURL: String = {
        return plist?["BaeminApiURL"] as! String
    }()
    
    static var token = String()
}
