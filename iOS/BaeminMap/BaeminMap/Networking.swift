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
        // TODO: size 추가 예정
        let parameters = [
            "lat": latitude,
            "lng": longitude,
            "category": 2
        ]
        print(Config.token)
        Alamofire.request("\(Config.baeminApiURL)/v2/shops?size=2000", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let responseDic = value as! [String:Any]
                let contents = responseDic["content"] as! [[String:Any]]
                var baeminInfo = [BaeminInfo]()
                contents.forEach({ (content) in
                    let shop = BaeminInfo(JSON: content)
                    if let shop = shop {
                        baeminInfo.append(shop)
                    }
                })
                NotificationCenter.default.post(name: NSNotification.Name("getBaeminInfoFinished"), object: self, userInfo: ["BaeminInfo" : baeminInfo])
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
}
