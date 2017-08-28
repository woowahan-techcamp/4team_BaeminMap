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
                BaeminInfoData.shared.baeminInfo = baeminInfo
                BaeminInfoData.shared.baeminInfoDic = baeminInfoDic
                Filter().filterManager()
                AnimationView.stopIndicator(delay: false)
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
                    if let menus = value as? [String:Any] {
                        menus.forEach({ (menu) in
                            if let value = menu.value as? [String:Any] {
                                let food = Food(JSON: value)
                                foods.append(food!)
                            }
                        })
                        sections.append(Section(title: key, items: foods))
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name.foodMenu, object: self, userInfo: ["Sections" : sections])
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
