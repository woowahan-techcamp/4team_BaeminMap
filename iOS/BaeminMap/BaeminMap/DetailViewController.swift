//
//  DetailViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    var scrollView = DetailScrollView()
    var FoodsList = [String:[Food]]()
    
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
        
//        sections.append(Section(rowCount: 4))
//        sections.append(Section(rowCount: 7))
//        sections.append(Section())
//        sections.append(Section())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)

        collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: collectionView.contentSize.width, height: collectionView.contentSize.height)
        tableView.frame = CGRect(x: 0, y: collectionView.frame.maxY, width: tableView.frame.width, height: tableView.frame.height)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].open ? sections[section].items.count : 0
//        return sections[section].open ? sections[section].rowCount : 0
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.price)원"
        return cell
    }
}

extension DetailViewController: ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int) {
        
        sections[header.section].open = !sections[header.section].open
        
        DispatchQueue.main.async {
            self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
            self.tableView.sizeToFit()
        }
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

