//
//  DetailViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var constraintHeightCollectionView: NSLayoutConstraint!

    @IBOutlet weak var constraintHeightTableView: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        
        constraintHeightCollectionView.constant = collectionView.contentSize.height
        self.view.setNeedsLayout()
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width / 2 - 15
        let height = (width * 151) / 143
        return CGSize(width: width, height: height)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        scrollView.contentSize.height = tableView.frame.maxY
        
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].open ? sections[section].items.count : 0
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
        let beforeSectionHeight = tableView.rect(forSection: section).height
        
        sections[section].open = !sections[section].open
        self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        
        var newTableHeight: CGFloat = 0
        if sections[section].open {
            let sectionRowHeight = tableView.rect(forSection: section).height - 33
            newTableHeight = constraintHeightTableView.constant + sectionRowHeight
        }else {
            let diff = beforeSectionHeight - tableView.rect(forSection: section).height
            newTableHeight = constraintHeightTableView.constant - diff
        }

        tableView.frame.size.height = newTableHeight
        constraintHeightTableView.constant = newTableHeight
        scrollView.contentSize.height = tableView.frame.maxY
    }
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
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

