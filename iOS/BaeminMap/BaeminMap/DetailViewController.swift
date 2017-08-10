//
//  DetailViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var test3: UIView!
    @IBOutlet var test2: UIImageView!
    @IBOutlet var test1: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    var height = CGFloat()

    var test = CGFloat()
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections.append(Section(rowCount: 4))
        sections.append(Section(rowCount: 7))
        sections.append(Section())
        sections.append(Section())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        initView()

        test = test1.frame.height + test2.frame.height + test3.frame.height
        height = tableView.frame.height
        scrollView.contentSize.height = test + collectionView.frame.height + tableView.frame.height
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        print(collectionView.frame.maxY, "aaaa")
        //cell의 전체 개수와 cell의 height를 알고 있어 initView에 미리 해놓으려했으나 각 행 사이의 공백의 높이를 알지 못해 유동적으로 height을 변경함
        collectionView.frame = CGRect(x: 0, y: collectionView.frame.minY, width: collectionView.contentSize.width, height: collectionView.contentSize.height)
        print(collectionView.frame.maxY, "bbbb")
        tableView.frame = CGRect(x: 0, y: collectionView.frame.maxY, width: tableView.frame.width, height: tableView.frame.height)
        scrollView.contentSize.height = tableView.frame.maxY//collectionView.frame.height + tableView.frame.height
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].open == true {
            return sections[section].rowCount
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableTableViewHeader()
        header.titleLabel.text = "section"
        
        header.section = section
        header.delegate = self
        
        return header
    }
}

extension DetailViewController: ExpandableTableViewHeaderDelegate {
    func toggleSection(header: ExpandableTableViewHeader, section: Int) {
        var height: CGFloat
        
        if sections[header.section].open == true {
            sections[header.section].open = false
            height = tableView.frame.height - 44 * CGFloat(sections[section].rowCount)
        }else {
            sections[header.section].open = true
            height = tableView.frame.height + 44 * CGFloat(sections[section].rowCount)
        }
        
        tableView.frame = CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: self.view.frame.width, height: height)
        scrollView.contentSize.height = tableView.frame.maxY
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
