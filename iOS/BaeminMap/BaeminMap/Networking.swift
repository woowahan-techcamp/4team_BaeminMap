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
    func getBaeminInfo(latitude: Double, longitude: Double) {
        let parameters = [
            "lat": latitude,
            "lng": longitude
        ]
        
        Alamofire.request("\(Config.standardURL)/shops", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let response):
                var baeminInfo = [BaeminInfo]()
                var baeminInfoDic = [String:[BaeminInfo]]()
                let contents = response as! [[String:Any]]
                contents.forEach({ (content) in
                    let shop = BaeminInfo(JSON: content)
                    if let shop = shop {
                        baeminInfo.append(shop)
                        if let _ = baeminInfoDic[shop.categoryName] {
                            baeminInfoDic[shop.categoryName]?.append(shop)
                        } else {
                            baeminInfoDic[shop.categoryName] = [shop]
                        }
                    }
                })
                
                NotificationCenter.default.post(name: NSNotification.Name("getBaeminInfoFinished"), object: self, userInfo: ["BaeminInfo": baeminInfo, "BaeminInfoDic": baeminInfoDic])
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func getFoods(shopNo: Int) {
        Alamofire.request("\(Config.standardURL)/menu/\(shopNo)").responseJSON { (response) in
            switch response.result {
            case .success(let response):
                var sections = [Section]()
                guard let contents = response as? [String:Any] else { return }
                for(key, value) in contents {
                    var foods = [Food]()
                    if let menus = value as? [[String:Any]] {
                        menus.forEach({ (menu) in
                            let food = Food(JSON: menu)
                            foods.append(food!)
                        })
                        sections.append(Section(title: key, items: foods))
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name("finishedGetFoodMenus"), object: self, userInfo: ["Sections" : sections])
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        
        
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
    }
}
