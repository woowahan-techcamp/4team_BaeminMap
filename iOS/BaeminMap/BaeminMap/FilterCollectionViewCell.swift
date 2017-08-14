//
//  FilterCollectionViewCell.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foodNameLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? UIColor.pointColor : UIColor.clear
            self.layer.borderColor = isSelected ? UIColor.pointColor.cgColor : UIColor.lightGray.cgColor
            foodNameLabel.textColor = isSelected ? UIColor.white : UIColor.lightGray
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.layer.frame.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = isSelected ? UIColor.pointColor.cgColor : UIColor.lightGray.cgColor
        foodNameLabel.textColor = isSelected ? UIColor.white : UIColor.lightGray
        foodNameLabel.sizeToFit()
    }
}
