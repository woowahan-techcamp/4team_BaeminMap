//
//  Indicator.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class AnimationView: UIView {
    @IBOutlet weak var deliverymanImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!

    static var indicator = UIView()

    override func awakeFromNib() {
        self.frame = UIScreen.main.bounds
        deliverymanImageView.frame = CGRect(x: self.frame.maxY, y: deliverymanImageView.frame.minY, width: deliverymanImageView.frame.width, height: deliverymanImageView.frame.height)

        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            self.logoImageView.frame = CGRect(x: self.logoImageView.frame.minX, y: self.logoImageView.frame.minY-10, width: self.logoImageView.frame.width, height: self.logoImageView.frame.height)
        }, completion: nil)
        UIView.animate(withDuration: 0.8, animations: {
            self.deliverymanImageView.frame = CGRect(x: self.center.x/2, y: self.deliverymanImageView.frame.minY, width: self.deliverymanImageView.frame.width, height: self.deliverymanImageView.frame.height)
        }) { (_) in
            UIView.animate(withDuration: 0.6, delay: 1.4, animations: {
                self.deliverymanImageView.frame = CGRect(x: self.frame.minX-self.deliverymanImageView.frame.width, y: self.deliverymanImageView.frame.minY, width: self.deliverymanImageView.frame.width, height: self.deliverymanImageView.frame.height)
            }, completion: nil)
        }
    }

    static func startLaunchView(target: MainContainerViewController) {
        let launchView = UINib(nibName: "LaunchView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        target.view.addSubview(launchView)
        target.navigationController?.isNavigationBarHidden = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3.5) {
            launchView.removeFromSuperview()
            if BaeminInfoData.shared.baeminInfo.isEmpty {
                startIndicator(target: target.view, image: "mapicon", alpha: 0.8)
            }
            target.navigationController?.isNavigationBarHidden = false
        }
    }

    static func startIndicator(target: UIView, image: String, alpha: CGFloat) {
        indicator = UIView()
        indicator.frame = UIScreen.main.bounds
        indicator.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        indicator.backgroundColor = UIColor(white: 1, alpha: alpha)

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
        messageLabel.text = "Loading..."
        messageLabel.textColor = UIColor.pointColor
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: 2)
        messageLabel.sizeToFit()
        messageLabel.center.x = hudView.frame.width/2

        hudView.addSubview(loadingView)
        hudView.addSubview(messageLabel)
        indicator.addSubview(hudView)

        target.addSubview(indicator)
    }

    static func stopIndicator(delay: Bool) {
        if delay {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                indicator.removeFromSuperview()
            }
        } else {
            indicator.removeFromSuperview()
        }
    }
}
