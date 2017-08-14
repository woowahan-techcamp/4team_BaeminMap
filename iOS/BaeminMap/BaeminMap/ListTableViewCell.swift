//
//  ListTableViewCell.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit
import Cosmos

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var shopImageView: UIImageView!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var ownerReviewLabel: UILabel!
    @IBOutlet var baropayLabel: UILabel!
    @IBOutlet var meetingpayLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingView.isUserInteractionEnabled = false
        shopImageView.layer.cornerRadius = (shopImageView.frame.size.height) / 2
        shopImageView.layer.masksToBounds = true
    }
    
    func isBaropay(baro: Bool) {
        if baro {
            baropayLabel.backgroundColor = UIColor.pointColor
            meetingpayLabel.backgroundColor = UIColor.pointColor
        } else {
            baropayLabel.backgroundColor = UIColor.lightGray
            meetingpayLabel.backgroundColor = UIColor.lightGray
        }
    }
    
}
