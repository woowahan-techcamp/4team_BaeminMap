//
//  Filter.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class Filter {
    static var category = [String]()
    static var sortTag = Int()
    static var rangeTag = Int()

    func filterManager() {
        var resultBaeminInfo = [BaeminInfo]()
        let baeminInfoDic = BaeminInfoData.shared.baeminInfoDic
        resultBaeminInfo = filter(baeminInfoDic: baeminInfoDic, selected: Filter.category)
        resultBaeminInfo = filterRange(baeminInfo: resultBaeminInfo, selected: Filter.rangeTag)
        resultBaeminInfo = sortManager(baeminInfo: resultBaeminInfo, selected: Filter.sortTag)

        BaeminInfoData.shared.listBaeminInfo = resultBaeminInfo
        findSamePlace()
    }

    func filter(baeminInfoDic: [String: [BaeminInfo]], selected: [String]) -> [BaeminInfo] {
        var filterArray = [BaeminInfo]()
        if selected.isEmpty {
            baeminInfoDic.forEach({ (shops) in
                filterArray += shops.value
            })
        } else {
            for(type, shops) in baeminInfoDic {
                if selected.contains(type) {
                    filterArray += shops
                }
            }
        }

        return filterArray
    }

    func filterRange(baeminInfo: [BaeminInfo], selected: Int) -> [BaeminInfo] {
        var range = Double()
        switch selected {
            case 0: range = 0.3
            case 1: range = 0.7
            default: range = 1.5
        }
        return baeminInfo.filter { $0.distance <= range }
    }

    func sortManager(baeminInfo: [BaeminInfo], selected: Int) -> [BaeminInfo] {
        switch selected {
        case 0:
            return baeminInfo.sorted(by: { $0.distance < $1.distance })
        case 1:
            return baeminInfo.sorted(by: { $0.orderCount > $1.orderCount })
        case 2:
            return baeminInfo.sorted(by: { $0.starPointAverage > $1.starPointAverage })
        case 3:
            return baeminInfo.sorted(by: { $0.viewCount > $1.viewCount })
        default:
            return baeminInfo.sorted(by: { $0.favoriteCount > $1.favoriteCount })
        }
    }

    func findSamePlace() {
        var samePlaceShops = [BaeminInfo: [BaeminInfo]]()
        for shop in BaeminInfoData.shared.listBaeminInfo {
            if let key = samePlaceShops[shop] {
                samePlaceShops[key[0]]?.append(shop)
            } else {
                samePlaceShops[shop] = [shop]
            }
        }
        BaeminInfoData.shared.mapBaeminInfo = samePlaceShops
    }
}
