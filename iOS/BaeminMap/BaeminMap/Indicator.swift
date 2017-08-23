//
//  Indicator.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class Indicator {
    static var indicator = UIView()
    
    static func startIndicator(target: UIView, message: String, image: String) {
        indicator.frame = UIScreen.main.bounds
        indicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        indicator.backgroundColor = UIColor.white
        
        let hudView = UIView()
        hudView.frame.size = CGSize(width: 100, height: 80)
        hudView.center = indicator.center
        
        let loadingView = UIImageView()
        loadingView.frame.size = CGSize(width: 50, height: 60)
        loadingView.contentMode = .center
        loadingView.center.x = hudView.frame.width/2
        loadingView.image = UIImage(named: image)!
        UIView.animate(withDuration: 0.7, delay: 0, options: .repeat, animations: {
            loadingView.frame = CGRect(x: loadingView.frame.minX, y: loadingView.frame.minY+10, width: loadingView.frame.width, height: loadingView.frame.height)
        }, completion: nil)

        let messageLabel = UILabel()
        messageLabel.frame = CGRect(x: 0, y: loadingView.frame.maxY, width: hudView.frame.width, height: 20)
        messageLabel.text = message
        messageLabel.textColor = UIColor.pointColor
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: 2)
        messageLabel.sizeToFit()
        messageLabel.center.x = hudView.frame.width/2
        
        hudView.addSubview(loadingView)
        hudView.addSubview(messageLabel)
        indicator.addSubview(hudView)
        
        target.addSubview(indicator)
    }
    
    static func stopIndicator() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            indicator.removeFromSuperview()
            indicator = UIView()
        }
    }
}
