//
//  ListViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var listView: UITableView!
    lazy var baeminInfo: [BaeminInfo] = {
        let parentView = self.parent as! MainContainerViewController
        return parentView.baeminInfo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.delegate = self
        listView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baeminInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
//         tableView.rowHeight = cell.frame.height
        let shop = baeminInfo[indexPath.row]
        cell.titleLabel.text = shop.shopName
        cell.reviewLabel.text = "최근리뷰 \(shop.reviewCount)"
        cell.ownerReviewLabel.text = "최근사장님댓글 \(shop.reviewCountCeo)"
        cell.ratingView.rating = shop.shopScore
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard.DetailViewStoryboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
