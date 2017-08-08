//
//  SortRangeView.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 8..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class SortRangeView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var range3kmButton: UIButton!
    @IBOutlet weak var range5kmButton: UIButton!
    @IBOutlet weak var range7kmButton: UIButton!
    
    override func draw(_ rect: CGRect) {
        titleLabel.textColor = UIColor(red: 42/255, green: 191/255, blue: 186/255, alpha: 1)
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "bottomArrowicon_gray"), for: .normal)
        
        range3kmButton.backgroundColor = .white
        range5kmButton.backgroundColor = .white
        range7kmButton.backgroundColor = .white
        
        range3kmButton.titleLabel?.textColor = UIColor(red: 42/255, green: 191/255, blue: 186/255, alpha: 1)
        range5kmButton.titleLabel?.textColor = UIColor(red: 42/255, green: 191/255, blue: 186/255, alpha: 1)
        range7kmButton.titleLabel?.textColor = UIColor(red: 42/255, green: 191/255, blue: 186/255, alpha: 1)
        
    }

}
