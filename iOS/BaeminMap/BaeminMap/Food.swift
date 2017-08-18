//
//  Food.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import Foundation
import ObjectMapper

class Food: Mappable {
    private(set) var shopFoodSeq: Int!
    private(set) var shopFoodGrpSeq: Int!
    private(set) var foodName: String!
    private(set) var foodConts: String?
    private(set) var foodPrice: String!
    private(set) var imgUrl: String?
    
    required init?(map: Map) {}
    
    init() {}
    func mapping(map: Map) {
        shopFoodSeq <- map["shopFoodSeq"]
        shopFoodGrpSeq <- map["shopFoodGrpSeq"]
        foodName <- map["foodNm"]
        foodConts <- map["foodConts"]
        foodPrice <- map["foodPrice"]
        imgUrl <- map["imgUrl"]
    }

    
}
