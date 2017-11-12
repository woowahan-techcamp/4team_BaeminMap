//
//  BaeminInfo.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import Foundation
//import ObjectMapper

class BaeminInfo: Hashable, Codable {
    var hashValue: Int { get { return (location["latitude"]! + location["longitude"]!).hashValue } }

    static func == (lhs: BaeminInfo, rhs: BaeminInfo) -> Bool {
        return lhs.location == rhs.location
    }

    private(set) var shopNumber: Int!
    private(set) var shopName: String!
    private(set) var categoryId: Int?
    private(set) var categoryName: String!
    private(set) var categoryEnglishName: String!
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
    private(set) var shopOpened: Bool!
    private(set) var location: [String:Double]!
    private(set) var distance: Double!
    private(set) var shopLogoImageUrl: String?

}

class BaeminInfoData {
    static let shared = BaeminInfoData()

    var baeminInfo = [BaeminInfo]()
    var baeminInfoDic = [String: [BaeminInfo]]()
    var listBaeminInfo = [BaeminInfo]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.listBaeminInfo, object: self)
        }
    }
    var mapBaeminInfo: [[BaeminInfo]]? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.mapBaeminInfo, object: self)
        }
    }

}
