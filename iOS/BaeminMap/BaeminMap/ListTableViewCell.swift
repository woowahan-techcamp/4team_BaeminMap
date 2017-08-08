//
//  ListTableViewCell.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var ShopImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ShopImageView.layer.cornerRadius = (ShopImageView.frame.size.height) / 2
        ShopImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
