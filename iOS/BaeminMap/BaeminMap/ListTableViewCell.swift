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
    @IBOutlet weak var rightArrowImage: UIImageView!
    @IBOutlet weak var moveButton: UIButton!
    @IBOutlet weak var infoView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        ratingView.isUserInteractionEnabled = false
        shopImageView.layer.cornerRadius = (shopImageView.frame.size.height) / 2
        shopImageView.layer.masksToBounds = true
        moveButton.isEnabled = false
    }

    func isPay(baro: Bool, meet: Bool) {
        baropayLabel.backgroundColor = baro ? UIColor.pointColor : UIColor.lightGray
        meetingpayLabel.backgroundColor = meet ? UIColor.pointColor : UIColor.lightGray
    }
}
