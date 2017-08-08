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
//    private(set) var shopNumber: Int?
//    private(set) var shopName: String?
//    private(set) var categoryId: Int?
//    private(set) var categoryName: String?
//    private(set) var categoryEnglishName: String?
//    private(set) var address: String?
//    private(set) var addressDetail: String?
//    private(set) var phoneNumber: String?
//    private(set) var virtualPhoneNumber: String?
//    private(set) var franchiseNumber: String?
//    private(set) var franchiseMenuCount: String?
//    private(set) var viewCount: String?
//    private(set) var favoriteCount: String?
//    private(set) var callCount: String?
//    private(set) var orderCount: String?
//    private(set) var shopScore: String?
//    private(set) var starPointAverage: String?
//    private(set) var reviewCount: String?
//    private(set) var reviewCountCeo: String?
//    private(set) var reviewCountImage: String?
//    private(set) var minimumOrderPrice: String?
//    private(set) var closeDayDescription: String?
//    private(set) var deliveryInformation: String?
//    private(set) var shopIntroduction: String?
//    private(set) var useBaropay: String?
//    private(set) var shopOpened: String?
//    private(set) var shopLogoImageUrl: String?
//    private(set) var latitude: Double!
//    private(set) var longitude: Double!
//    private(set) var distance: String?
//    
    private(set) var shopNumber: Int!
    private(set) var shopName: String!
    private(set) var categoryId: Int?
    private(set) var categoryName: String!
    private(set) var categoryEnglishName: String!
    private(set) var address: String!
    private(set) var addressDetail: String!
    private(set) var phoneNumber: String?
    private(set) var virtualPhoneNumber: String?
    private(set) var franchiseNumber: Int?
    private(set) var shopMenuCount: Int?
    private(set) var franchiseMenuCount: Int?
    private(set) var viewCount: Int!
    private(set) var favoriteCount: Int!
    private(set) var callCount: Int!
    private(set) var orderCount: Int!
    private(set) var shopScore: Double?
    private(set) var starPointAverage: Double?
    private(set) var reviewCount: Int!
    private(set) var reviewCountCeo: Int!
    private(set) var reviewCountImage: Int!
    private(set) var minimumOrderPrice: Int?
    private(set) var closeDayDescription: String?
    private(set) var deliveryInformation: String?
    private(set) var shopIntroduction: String?
    private(set) var useBaropay: Bool!
    private(set) var shopOpened: Bool!
    private(set) var location: [String:Double]!
//    private(set) var latitude: Double!
//    private(set) var longitude: Double!
    private(set) var distance: Double?
    private(set) var shopLogoImageUrl: String?
    
    
    required init?(map: Map) {}
    
//    func mapping(map: Map) {
//        shopNumber <- map["shopNumber"]
//        shopName <- map["shopName"]
//        categoryId <- map["categoryId"]
//        categoryName <- map["categoryName"]
//        categoryEnglishName <- map["categoryEnglishName"]
//        address <- map["address"]
//        addressDetail <- map["addressDetail"]
//        phoneNumber <- map["phoneNumber"]
//        virtualPhoneNumber <- map["virtualPhoneNumber"]
//        franchiseNumber <- map["franchiseNumber"]
//        franchiseMenuCount <- map["franchiseMenuCount"]
//        viewCount <- map["viewCount"]
//        favoriteCount <- map["favoriteCount"]
//        callCount <- map["callCount"]
//        orderCount <- map["orderCount"]
//        shopScore <- map["shopScore"]
//        starPointAverage <- map["starPointAverage"]
//        reviewCount <- map["reviewCount"]
//        reviewCountCeo <- map["reviewCountCeo"]
//        reviewCountImage <- map["reviewCountImage"]
//        minimumOrderPrice <- map["minimumOrderPrice"]
//        closeDayDescription <- map["closeDayDescription"]
//        deliveryInformation <- map["deliveryInformation"]
//        shopIntroduction <- map["shopIntroduction"]
//        useBaropay <- map["useBaropay"]
//        shopOpened <- map["shopOpened"]
//        shopLogoImageUrl <- map["shopLogoImageUrl"]
//        print(map["location"]["latitude"])
//        latitude <- map["location"]["latitude"]
//        longitude <- map["location"]["longitude"]
//        distance <- map["distance"]
//    }
//    
    func mapping(map: Map) {
        shopNumber <- map["shopNumber"]
        shopName <- map["shopName"]
        categoryId <- map["categoryId"]
        categoryName <- map["categoryName"]
        categoryEnglishName <- map["categoryEnglishName"]
        address <- map["address"]
        addressDetail <- map["addressDetail"]
        phoneNumber <- map["phoneNumber"]
        virtualPhoneNumber <- map["virtualPhoneNumber"]
        franchiseNumber <- map["franchiseNumber"]
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
        //    private(set) var location: {
//        latitude <- map["location"]
//        longitude <- map["location"]["longitude"]
        distance <- map["distance"]
        shopLogoImageUrl <- map["shopLogoImageUrl"]
    }
    
}
