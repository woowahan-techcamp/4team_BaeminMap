//
//  ListViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import AlamofireImage

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("getBaeminInfoFinished"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recieve(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let baeminInfo = userInfo["BaeminInfo"] as? [BaeminInfo] else { return }
        self.baeminInfo = baeminInfo
        listView.reloadData()
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
        let shop = baeminInfo[indexPath.row]
        let distance = shop.distance.convertDistance()
        if let url = shop.shopLogoImageUrl {
            cell.shopImageView.af_setImage(withURL: URL(string: url)!)
        }
        cell.titleLabel.text = shop.shopName
        cell.reviewLabel.text = "최근리뷰 \(shop.reviewCount ?? 0)"
        cell.ownerReviewLabel.text = "최근사장님댓글 \(shop.reviewCountCeo ?? 0)"
        cell.ratingView.rating = shop.starPointAverage
        cell.distanceLabel.text = "\(shop.distance > 1 ? "\(distance)km" : "\(Int(distance))m")"
        cell.isBaropay(baro: shop.useBaropay)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = UIStoryboard.DetailViewStoryboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
