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
    var standardColor = UIColor(red: 37/255, green: 183/255, blue: 177/255, alpha: 1)
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? standardColor : UIColor.clear
            self.layer.borderColor = isSelected ? UIColor.white.cgColor : standardColor.cgColor
            foodNameLabel.textColor = isSelected ? UIColor.white : standardColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.layer.frame.height/2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = standardColor.cgColor
        foodNameLabel.textColor = isSelected ? UIColor.white : standardColor
        foodNameLabel.sizeToFit()
    }
}
