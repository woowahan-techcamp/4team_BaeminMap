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
//    func getAccessToken() {
//        let parameters = [
//            "grant_type": "password",
//            "client_id": Config.clientID,
//            "scope": "read",
//            "username": Config.baeminID,
//            "password": Config.baeminPassword
//        ]
//        
//        Alamofire.request("https://\(Config.clientID):\(Config.clientSecret)@\(Config.tokenURL)", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
//            switch response.result {
//            case .success(let result):
//                Config.token = (result as! [String:Any])["access_token"] as! String
//                self.getBaeminInfo(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
//                self.getFoods(shopNo: 521977)
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
//    }
    
    func getBaeminInfo(latitude: Double, longitude: Double) {
        let parameters = [
            "lat": latitude,
            "lng": longitude
        ]
        
        Alamofire.request("\(Config.standardURL)/shops", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let response):
                var baeminInfo = [BaeminInfo]()
                var baeminInfoDic = [Int:[BaeminInfo]]()
                let contents = response as! [[String:Any]]
                contents.forEach({ (content) in
                    let shop = BaeminInfo(JSON: content)
                    if let shop = shop {
                        baeminInfo.append(shop)
                        if let _ = baeminInfoDic[shop.type] {
                            baeminInfoDic[shop.type]?.append(shop)
                        } else {
                            baeminInfoDic[shop.type] = [shop]
                        }
                    }
                })
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
//    func getFoods(shopNo: Int) {
//        let header = ["Authorization": "Bearer \(Config.token)", "Content-Type": "application/json"]
//        var parameters: Parameters = ["shopNo": shopNo]
//
//        func getFoodsGroups(completion: @escaping (_ foodsGroup: [String:String]) -> ()) {
//            Alamofire.request("\(Config.baeminApiURL)/v1/shops/\(shopNo)/foods-groups", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
//                switch response.result {
//                case .success(let foodsGroup):
//                    if let group = foodsGroup as? [[String:String]] {
//                        group.forEach({ (foodGroup) in
//                            completion(foodGroup)
//                        })
//                    }
//                case .failure(let error):
//                    print(String(describing: error))
//                }
//            }
//        }
//        
//        getFoodsGroups { (group) in
//            parameters["shopFoodGrpSeq"] = group["shopFoodGrpSeq"]
//            Alamofire.request("\(Config.baeminApiURL)/v1/shops/\(shopNo)/foods", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON(completionHandler: { (response) in
//                guard let result = response.result.value as? [String:Any] else { return }
//                let contents = result["content"] as! [[String:Any]]
//                var foodList = [Food]()
//
//                contents.forEach({ (content) in
//                    let food = Food(JSON: content)
//                    foodList.append(food!)
//                })
//                NotificationCenter.default.post(name: NSNotification.Name("finishedFoodList"), object: self, userInfo: ["FoodList": foodList, "key": group["shopFoodGrpNm"]!])
//            })
//        }
//    }
}
