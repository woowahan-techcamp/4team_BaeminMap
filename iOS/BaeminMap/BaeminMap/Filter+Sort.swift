//
//  Filter+Sort.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class Filter {
    func filterManager(category: [String], range: Int, sort: Int, baeminInfoDic: [String:[BaeminInfo]]) -> [BaeminInfo] {
        var resultBaeminInfo = [BaeminInfo]()
        resultBaeminInfo = filter(baeminInfoDic: baeminInfoDic, selected: category)
        resultBaeminInfo = filterRange(baeminInfo: resultBaeminInfo, selected: range)
        resultBaeminInfo = sortManager(baeminInfo: resultBaeminInfo, selected: sort)
        
        return resultBaeminInfo
    }
    
    func filter(baeminInfoDic: [String:[BaeminInfo]], selected: [String]) -> [BaeminInfo] {
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
            return baeminInfo.sorted(by: {$0.starPointAverage > $1.starPointAverage })
        case 3:
            return baeminInfo.sorted(by: { $0.viewCount > $1.viewCount })
        default:
            return baeminInfo.sorted(by: { $0.favoriteCount > $1.favoriteCount })
        }
    }
}
