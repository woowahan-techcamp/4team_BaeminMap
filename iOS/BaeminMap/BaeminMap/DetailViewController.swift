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
    @IBOutlet weak var bottomInfoView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    var baeminInfo = BaeminInfo()
    var foodList = [Section]()
    var imageList = Section()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.title = baeminInfo.shopName
        
        Indicator.startIndicator(target: self.view, message: "Loading...", image: baeminInfo.categoryEnglishName)
        
        meetPayLabel.ablePay()
        baroPayLabel.ablePay()
        if let url = baeminInfo.shopLogoImageUrl {
            mainImageView.af_setImage(withURL: URL(string: url)!)
        }
        if baeminInfo.starPointAverage < 0 {
            hiddenBottomInfoView()
        } else {
            starPointLabel.text = String(baeminInfo.starPointAverage.roundTo(places: 1))
            starPointView.rating = baeminInfo.starPointAverage
            reviewCountLabel.text = String(baeminInfo.reviewCount)
            reviewCountCEOLabel.text = String(baeminInfo.reviewCountCeo)
            minOrderPriceLabel.text = "최소주문금액: \(String(baeminInfo.minimumOrderPrice))원"
        }
        
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
        } else {
            if let index = self.foodList.index(where: { $0.title == "imageMenu" }) {
                imageList = self.foodList.remove(at: index)
            }
            self.foodList[0].open = true
            if imageList.items.isEmpty {
                hiddenCollectionView()
            }
        }
        Indicator.stopIndicator()
        tableView.reloadData()
        collectionView.reloadData()
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

    func hiddenBottomInfoView() {
        topView.frame.size.height = topView.frame.height - bottomInfoView.frame.height
        bottomViewHeight.constant = 0
        bottomInfoView.isHidden = true
    }
    
    func hiddenCollectionView() {
        topView.frame.size.height = topView.frame.height - collectionView.frame.height + 10
        collectionView.isHidden = true
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        let item = imageList.items[indexPath.item]
        if let url = item.imgUrl {
            cell.foodImageView.af_setImage(withURL: URL(string: url)!)
            cell.foodImageView.contentMode = .scaleAspectFit
            cell.foodNameLabel.text = item.foodName
            if let price = item.price.first {
                if price.key.isEmpty {
                    cell.priceLabel.text = "\(price.value)원"
                } else {
                    cell.priceLabel.text = "\(price.key) : \(price.value)원"
                }
            }
        }
        
        collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: collectionView.contentSize.width, height: collectionView.contentSize.height)
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: collectionView.frame.maxY)
        
        let count = imageList.items.count < 6 ? imageList.items.count : 6
        if indexPath.item == count-1 {
            tableView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.items.count < 6 ? imageList.items.count : 6
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
