//
//  Filter+Sort.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class Filter {
    static var category = [String]()
    static var range = Int()
    static var sort = Int()
    
    static func filterManager(category: [String]?=nil, range: Int?=nil, sort: Int?=nil, baeminInfoDic: [String:[BaeminInfo]], baeminInfo: [BaeminInfo]) -> [BaeminInfo] {
//        var resultBaeminInfo = [BaeminInfo]()
//        
//        if !category?.isEmpty {
//            var a = filter(baeminInfoDic: baeminInfoDic, selected: category)
//            if range != nil {
//                var b = filterRange(baeminInfo: a, range: self.range)
//                return b
//            }
//            return a
//        } else if range != nil {
//            filterRange(baeminInfo: baeminInfo, range: self.range)
//        }
    
//        if category != nil || range != nil {
//            self.range = range!
//            if range == nil || range! > self.range {
//                self.category = category!
//                //카테고리 필터 함수 호출
//            }
//            //range 함수 호출
//        }else if sort != nil {
//            //sort 함수 호출
//        }
        
        return [baeminInfo[0]]
    }
    
//    static func filter(baeminInfoDic: [String:[BaeminInfo]], selected: [String]) -> [BaeminInfo] {
//        var filterDic = [BaeminInfo]()
//        for(type, shops) in baeminInfoDic {
//            if selected.contains(type) {
//                filterDic += shops
//            }
//        }
//        return filterDic
//    }
//    
//    static func filterRange(baeminInfo: [BaeminInfo], range: Double) -> [BaeminInfo] {
//        return baeminInfo.filter { $0.distance <= range }
//    }
}

class Sort {
//    static func sortRange() {
//        
//    }
}
