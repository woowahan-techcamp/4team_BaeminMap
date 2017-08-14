//
//  FilterViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func selected(category: [String])
}

class FilterViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var sortButton: [UIButton]!
    @IBOutlet var rangeButton: [UIButton]!
    @IBOutlet var sortCheckImageView: [UIImageView]!
    @IBOutlet var rangeCheckImageView: [UIImageView]!
    
    var delegate: FilterViewDelegate!
    var selectedCategory = [String]()
    
    var category = ["전체", "치킨", "중국집", "피자", "한식", "분식", "족발,보쌈", "야식", "찜,탕", "회,돈까스,일식", "도시락", "패스트푸드"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        scrollView.contentSize.height = self.view.frame.height

        checkSelected()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkSelected() {
        if selectedCategory.isEmpty {
            collectionView.selectItem(at: [0, 0], animated: false, scrollPosition: .top)
        } else {
            for item in selectedCategory {
                collectionView.selectItem(at: [0, category.index(of: item)!], animated: false, scrollPosition: .top)
            }
        }
    }
    
    @IBAction func selectedSort(_ sender: UIButton) {
        if sender == sortButton[sender.tag] {
            for i in 0..<sortButton.count {
                sortButton[i].setTitleColor(UIColor.lightGray, for: .normal)
                sortCheckImageView[i].isHidden = true
            }
            sortCheckImageView[sender.tag].isHidden = false
        } else {
            for i in 0..<rangeButton.count {
                rangeButton[i].setTitleColor(UIColor.lightGray, for: .normal)
                rangeCheckImageView[i].isHidden = true
            }
            rangeCheckImageView[sender.tag].isHidden = false
        }
        sender.setTitleColor(pointColor, for: .normal)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        delegate.selected(category: selectedCategory)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterCollectionViewCell
        cell.foodNameLabel.text = category[indexPath.item]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = category[indexPath.item].unicodeScalars.count * 10 + 25
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if !selectedCategory.isEmpty {
                for item in collectionView.indexPathsForSelectedItems! {
                    collectionView.deselectItem(at: item , animated: false)
                }
                collectionView.selectItem(at: [0, 0], animated: false, scrollPosition: .top)
                selectedCategory.removeAll()
            }
        } else {
            collectionView.deselectItem(at: [0, 0], animated: false)
            selectedCategory.append(category[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            collectionView.selectItem(at: [0, 0], animated: false, scrollPosition: .top)
        } else {
            let item = category[indexPath.item]
            if let index = selectedCategory.index(of: item) {
                 selectedCategory.remove(at: index)
            }
        }
    }
    
}
