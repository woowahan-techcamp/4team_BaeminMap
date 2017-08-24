//
//  Extension.swift
//  BaeminMap
//
//  Created by HannaJeon on 2017. 8. 7..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static let listViewStoryboard = UIStoryboard(name: "ListView", bundle: nil)
    static let mapViewStoryboard = UIStoryboard(name: "MapView", bundle: nil)
    static let mainContainerViewStoryboard = UIStoryboard(name: "MainContainerView", bundle: nil)
    static let detailViewStoryboard = UIStoryboard(name: "DetailView", bundle: nil)
    static let filterViewStoryboard = UIStoryboard(name: "FilterView", bundle: nil)
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
    
    func scrollToPage(x: CGFloat, animated: Bool, after delay: TimeInterval) {
        let offset: CGPoint = CGPoint(x: x, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.setContentOffset(offset, animated: animated)
        })
    }
}

extension UINavigationBar {
    static func setNavigation() {
        self.appearance().tintColor = UIColor.black
        self.appearance().barTintColor = UIColor.white
        self.appearance().backIndicatorImage = #imageLiteral(resourceName: "backbutton")
        self.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backbutton")
    }
}

extension UILabel {
    func ablePay() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.layer.frame.height/2
    }
}

extension Int {
    func convertCountPlus() -> String {
        if self >= 10000 {
            return "\(String((Double(self)/10000.0).roundTo(places: 1)))만+"
        } else if self >= 1000 {
            return "\(String(self/1000))000+"
        } else if self >= 100 {
            return "\(String(self/100))00+"
        } else if self >= 10 {
            return "\(String(self/10))0+"
        } else {
            return "1+"
        }
    }
}
