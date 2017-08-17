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
    private(set) var useMeetPay: Bool!
    private(set) var useCardPay: Bool!
    private(set) var canDelivery: Bool!
    private(set) var shopOpened: Bool!
    private(set) var location: [String:Double]!
    private(set) var distance: Double!
    private(set) var shopLogoImageUrl: String?
    
    required init?(map: Map) {}
    
    init() { }
  
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
        useMeetPay <- map["useMeetPay"]
        useCardPay <- map["useCardPay"]
        canDelivery <- map["canDelivery"]
        shopOpened <- map["shopOpened"]
        location <- map["location"]
        distance <- map["distance"]
        shopLogoImageUrl <- map["shopLogoImageUrl"]
    }
    
}
