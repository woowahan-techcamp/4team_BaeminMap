//
//  Extension.swift
//  BaeminMap
//
//  Created by HannaJeon on 2017. 8. 7..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static let ListViewStoryboard = UIStoryboard(name: "ListView", bundle: nil)
    static let MapViewStoryboard = UIStoryboard(name: "MapView", bundle: nil)
    static let MainContainerViewStoryboard = UIStoryboard(name: "MainContainerView", bundle: nil)
    static let DetailViewStoryboard = UIStoryboard(name: "DetailView", bundle: nil)
    static let FilterViewStoryboard = UIStoryboard(name: "FilterView", bundle: nil)
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }

    func convertDistance() -> Double {
        if self > 1 {
            return self.roundTo(places: 1)
        } else {
            return Darwin.round(self * 1000)
        }
    }
}

extension UIColor {
    static let pointColor = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
}

extension UIScrollView {
    func scrollToSection(y: CGFloat) {
        let bottomOffset = CGPoint(x: 0, y: contentOffset.y + y)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
