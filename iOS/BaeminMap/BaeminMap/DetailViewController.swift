//
//  DetailViewController.swift
//  BaeminMap
//
//  Created by HannaJeon on 2017. 8. 15..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var baeminInfo = BaeminInfo()
    
    var sections: [Section] = [
        Section(title: "크런치 피자", items: [
            Item(name: "크런치 치즈 스테이크", price: 30000),
            Item(name: "크런치 치즈 스테이크", price: 30000),
            Item(name: "크런치 치즈 스테이크", price: 30000),
            Item(name: "크런치 치즈 스테이크", price: 30000)
            ]),
        Section(title: "핫 피자", items: [
            Item(name: "핫 치즈 스테이크", price: 20000),
            Item(name: "핫 치즈 스테이크", price: 20000),
            Item(name: "핫 치즈 스테이크", price: 330000),
            Item(name: "핫 치즈 스테이크", price: 304000)
            ]),
        Section(title: "ㅇㅇ 피자", items: [
            Item(name: "ㅇ 치즈 스테이크", price: 30000),
            Item(name: "ㅇㅇ 치즈 스테이크", price: 300),
            Item(name: "ㅇㅇ 치즈 스테이크", price: 30000),
            Item(name: "ㅇㅇㅇ 치즈 스테이크", price: 320000)
            ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print(baeminInfo.address)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.price)원"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableTableViewHeader()
        header.titleLabel.text = sections[section].title
        
        header.section = section
        header.delegate = self
        
        if sections[header.section].open == true {
            header.arrowImage.image = #imageLiteral(resourceName: "arrow_top")
        }
        
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].open ? sections[section].items.count : 0
    }
    
}

extension DetailViewController: ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int) {
        let headerHeight = header.frame.height
        sections[header.section].open = !sections[header.section].open
        self.tableView.reloadData()
        self.tableView.scrollToSection(y: self.tableView.rect(forSection: section).height-headerHeight)
    }
}

public struct Item {
    var name: String
    var price: Int
    
    public init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
}
