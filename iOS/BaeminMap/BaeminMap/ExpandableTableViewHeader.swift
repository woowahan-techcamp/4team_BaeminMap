//
//  ExpandableTableViewHeader.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class ExpandableTableViewHeader: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        // Content View
        contentView.backgroundColor = UIColor(red: 84/255, green: 77/255, blue: 70/255, alpha: 1)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
