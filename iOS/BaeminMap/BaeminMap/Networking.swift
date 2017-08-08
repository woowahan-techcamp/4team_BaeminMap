//
//  Networking.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    func getAccessToken() {
        let parameters: Parameters = [
            "grant_type": "password",
            "client_id": Config.clientID,
            "scope": "read",
            "username": Config.beaminID,
            "password": Config.baeminPassword
        ]
        
        Alamofire.request("https://\(Config.clientID):\(Config.clientSecret)@\(Config.tokenURL)", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            let result = response.result.value as! [String:Any]
            Config.token = result["access_token"] as! String
        }
    }
    
//    func getBaeminInfo(latitude: Double, longitude: Double) {
//        let parameters: Parameters = [
//            "lat": latitude,
//            "lng": longitude
//        ]
//        
//        Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
//    }
    
}
