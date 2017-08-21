//
//  DetailViewController.swift
//  BaeminMap
//
//  Created by HannaJeon on 2017. 8. 15..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var orderCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var meetPayLabel: UILabel!
    @IBOutlet weak var baroPayLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var starPointLabel: UILabel!
    @IBOutlet weak var starPointView: CosmosView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var reviewCountCEOLabel: UILabel!
    @IBOutlet weak var minOrderPriceLabel: UILabel!
    @IBOutlet weak var moveToBaemin: UIButton!
    @IBOutlet weak var topInfoView: UIView!
    
    var baeminInfo = BaeminInfo()
    var foodList = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.title = baeminInfo.shopName
        meetPayLabel.ablePay()
        baroPayLabel.ablePay()
        if let url = baeminInfo.shopLogoImageUrl {
            mainImageView.af_setImage(withURL: URL(string: url)!)
        }
        starPointLabel.text = String(baeminInfo.starPointAverage.roundTo(places: 1))
        starPointView.rating = baeminInfo.starPointAverage
        reviewCountLabel.text = String(baeminInfo.reviewCount)
        reviewCountCEOLabel.text = String(baeminInfo.reviewCountCeo)
        minOrderPriceLabel.text = "최소주문금액: \(String(baeminInfo.minimumOrderPrice))원"
    
        Networking().getFoods(shopNo: baeminInfo.shopNumber)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name("finishedGetFoodMenus"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receive(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let foodList = userInfo["Sections"] as? [Section] else { return }
        self.foodList = foodList
        if foodList.isEmpty {
            showCallImage()
        }
        tableView.reloadData()
    }
    
    func showCallImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: topInfoView.frame.maxY, width: tableView.frame.width, height: tableView.frame.height-moveToBaemin.frame.height))
        imageView.contentMode = .center
        imageView.backgroundColor = UIColor.white
        imageView.image = #imageLiteral(resourceName: "callOrderDefault")
        moveToBaemin.isHidden = true
        tableView.isUserInteractionEnabled = false
        tableView.addSubview(imageView)
    }

}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        
        collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: collectionView.contentSize.width, height: collectionView.contentSize.height)
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: collectionView.frame.maxY)
        
        if indexPath.item == 5 {
            tableView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - 30) / 2
        let height = ( 15 * width ) / 14
        
        return CGSize(width: width, height: height)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)

        let food = foodList[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = food.foodName
        cell.detailTextLabel?.text = food.foodPrice+"원"
        print(baeminInfo.shopNumber)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableTableViewHeader()
        header.titleLabel.text = foodList[section].title
        
        header.section = section
        header.delegate = self
        
        if foodList[header.section].open == true {
            header.arrowImage.image = #imageLiteral(resourceName: "arrow_top")
        }
        
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList[section].open ? foodList[section].items.count : 0
    }
    
}

extension DetailViewController: ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int) {
        let headerHeight = header.frame.height
        foodList[header.section].open = !foodList[header.section].open
        self.tableView.reloadData()
        self.tableView.scrollToSection(y: self.tableView.rect(forSection: section).height-headerHeight)
    }
}
