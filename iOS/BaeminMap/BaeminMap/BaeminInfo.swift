//
//  BaeminInfo.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import Foundation
import ObjectMapper

class BaeminInfo: Mappable {
    private(set) var shopNumber: Int!
    private(set) var shopName: String!
    private(set) var categoryId: Int?
    private(set) var categoryName: String!
    private(set) var address: String!
    private(set) var addressDetail: String?
    private(set) var phoneNumber: String?
    private(set) var virtualPhoneNumber: String?
    private(set) var shopMenuCount: Int?
    private(set) var franchiseMenuCount: Int?
    private(set) var viewCount: Int!
    private(set) var favoriteCount: Int!
    private(set) var callCount: Int!
    private(set) var orderCount: Int!
    private(set) var shopScore: Double!
    private(set) var starPointAverage: Double!
    private(set) var reviewCount: Int!
    private(set) var reviewCountCeo: Int!
    private(set) var reviewCountImage: Int!
    private(set) var minimumOrderPrice: Int!
    private(set) var closeDayDescription: String?
    private(set) var deliveryInformation: String!
    private(set) var shopIntroduction: String?
    private(set) var useBaropay: Bool!
    private(set) var shopOpened: Bool!
    private(set) var location: [String:Double]!
    private(set) var distance: Double!
    private(set) var shopLogoImageUrl: String?
//    private(set) var type: Int!
    
    required init?(map: Map) {}
  
    func mapping(map: Map) {
        shopNumber <- map["shopNumber"]
        shopName <- map["shopName"]
        categoryId <- map["categoryId"]
        categoryName <- map["categoryName"]
        address <- map["address"]
        addressDetail <- map["addressDetail"]
        phoneNumber <- map["phoneNumber"]
        virtualPhoneNumber <- map["virtualPhoneNumber"]
        shopMenuCount <- map["shopMenuCount"]
        franchiseMenuCount <- map["franchiseMenuCount"]
        viewCount <- map["viewCount"]
        favoriteCount <- map["favoriteCount"]
        callCount <- map["callCount"]
        orderCount <- map["orderCount"]
        shopScore <- map["shopScore"]
        starPointAverage <- map["starPointAverage"]
        reviewCount <- map["reviewCount"]
        reviewCountCeo <- map["reviewCountCeo"]
        reviewCountImage <- map["reviewCountImage"]
        minimumOrderPrice <- map["minimumOrderPrice"]
        closeDayDescription <- map["closeDayDescription"]
        deliveryInformation <- map["deliveryInformation"]
        shopIntroduction <- map["shopIntroduction"]
        useBaropay <- map["useBaropay"]
        shopOpened <- map["shopOpened"]
        location <- map["location"]
        distance <- map["distance"]
        shopLogoImageUrl <- map["shopLogoImageUrl"]
//        type = type(type: categoryName)
    }
    
//    func type(type: String) -> Int {
//        switch type {
//            case "치킨": return 1
//            case "중식": return 2
//            case "피자": return 3
//            case "한식": return 32
//            case "분식": return 33
//            case "족발,보쌈": return 4
//            case "야식": return 5
//            case "찜,탕": return 6
//            case "돈까스,회,일식": return 10
//            case "도시락": return 9
//            default: return 7
//        }
//    }
    
}
