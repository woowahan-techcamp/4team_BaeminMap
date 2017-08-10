//
//  ExpandableTableViewHeader.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

protocol ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int)
}

class ExpandableTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: ExpandableTableViewHeaderDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    let arrowImage = UIImageView()
    
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
        
        // Arrow ImageView
        contentView.addSubview(arrowImage)
        arrowImage.image = #imageLiteral(resourceName: "arrow_bottom")
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.heightAnchor.constraint(equalToConstant: 5.24)
        arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        arrowImage.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ExpandableTableViewHeader.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapHeader(_ gestureRecognizer: UIGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? ExpandableTableViewHeader else { return }
        
        delegate?.toggleSection(header: self, section: cell.section)
    }
}

class Section {
    var open: Bool
    //TODO: 아래는 테스트 용, 추후 row list 변수로 가지고 있을 예정
    var rowCount: Int
    
    init(rowCount: Int) {
        self.open = false
        self.rowCount = rowCount
    }
    
    convenience init() {
        self.init(rowCount: 1)
    }
}

