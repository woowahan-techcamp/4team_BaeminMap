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
            self.getFoods(shopNo: 521977)
        }
    }
    
    func getBaeminInfo(latitude: Double, longitude: Double) {
        let header = ["Authorization": "Bearer \(Config.token)", "Content-Type": "application/json"]
        // TODO: size 추가 예정
        let parameters = [
            "lat": latitude,
            "lng": longitude,
            "category": 1
        ]
        print(Config.token)
        Alamofire.request("\(Config.baeminApiURL)/v2/shops", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
    
    func getFoods(shopNo: Int) {
        let header = ["Authorization": "Bearer \(Config.token)", "Content-Type": "application/json"]
        var parameters: Parameters = ["shopNo": shopNo]

        func getFoodsGroups(completion: @escaping (_ foodsGroup: [String:String]) -> ()) {
            Alamofire.request("\(Config.baeminApiURL)/v1/shops/\(shopNo)/foods-groups", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
                switch response.result {
                case .success(let foodsGroup):
                    if let group = foodsGroup as? [[String:String]] {
                        group.forEach({ (foodGroup) in
                            completion(foodGroup)
                        })
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
        }
        
        getFoodsGroups { (group) in
            parameters["shopFoodGrpSeq"] = group["shopFoodGrpSeq"]
            Alamofire.request("\(Config.baeminApiURL)/v1/shops/\(shopNo)/foods", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
                guard let result = response.result.value as? [String:Any] else { return }
                let contents = result["content"] as! [[String:Any]]
                var foodList = [Food]()

                contents.forEach({ (content) in
                    let food = Food(JSON: content)
                    foodList.append(food!)
                })
                NotificationCenter.default.post(name: NSNotification.Name("finishedFoodList"), object: self, userInfo: ["FoodList": foodList, "key": group["shopFoodGrpNm"]!])
            })
        }
    }
}
