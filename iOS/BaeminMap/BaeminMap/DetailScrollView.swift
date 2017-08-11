//
//  DetailScrollView.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class DetailScrollView: UIScrollView {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    override func layoutSubviews() {
        DispatchQueue.main.async {
            self.tableView.frame.size.height = self.tableView.contentSize.height
            self.contentSize.height = self.tableView.frame.maxY
        }
    }
}
