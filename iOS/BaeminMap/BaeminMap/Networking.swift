//
//  Networking.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class Networking {
    func getAccessToken() {
        let parameters = [
            "grant_type": "password",
            "client_id": Config.clientID,
            "scope": "read",
            "username": Config.baeminID,
            "password": Config.baeminPassword
        ]
        
        Alamofire.request("https://\(Config.clientID):\(Config.clientSecret)@\(Config.tokenURL)", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            let result = response.result.value as! [String:Any]
            Config.token = result["access_token"] as! String
            self.getBaeminInfo(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        }
    }
    
    func getBaeminInfo(latitude: Double, longitude: Double) {
        let header = ["Authorization": "Bearer \(Config.token)", "Content-Type": "application/json"]
        let parameters = [
            "lat": latitude,
            "lng": longitude,
            "category": 1
        ]
        
        Alamofire.request("\(Config.baeminApiURL)/v2/shops", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseObject { (response: DataResponse<BaeminInfo>) in
            print(response)
        }

    }
    
}
