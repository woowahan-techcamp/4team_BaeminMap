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
    func roundTo(places: Int) -> Double {
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
        if bottomOffset.y > 0 {
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
    func checkPay(_ able: Bool) {
        self.layer.borderWidth = 1
        self.layer.borderColor = able ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        self.textColor = able ? UIColor.black : UIColor.lightGray
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
        } else if self > 0 {
            return "1+"
        } else {
            return "0"
        }
    }
}

extension String {
    func convertPhoneNumber() -> String {
        if self[self.startIndex] != "0" {
            var array = Array(self.characters)
            array[0] = "0"
            return String(array)
        } else {
            return self
        }
    }

    func drawPlusMarker() -> UIImage {
        let textColor = UIColor.pointColor
        let textFont = UIFont(name: "Helvetica Bold", size: 18)!
        let image = #imageLiteral(resourceName: "emptyMarker")
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: style
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let rect = CGRect(x: 0, y: 6, width: image.size.width, height: image.size.height)
        self.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension Notification.Name {
    static let location = Notification.Name("finishedCurrentLocation")
    static let listBaeminInfo = Notification.Name("listBaeminInfo")
    static let mapBaeminInfo = Notification.Name("mapBaeminInfo")
    static let foodMenu = Notification.Name("finishedGetFoodMenu")
    static let filterFrame = Notification.Name("changeFilterFrame")
}
