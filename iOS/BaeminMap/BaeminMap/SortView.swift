//
//  SortView.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class SortView: UIView {
    
    @IBOutlet weak var nearButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func layoutSubviews() {
        nearButton.titleLabel?.textColor = UIColor.white
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
