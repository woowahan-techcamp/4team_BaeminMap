//
//  ViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import GooglePlaces

class MainContainerViewController: UIViewController, FilterViewDelegate {
    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIButton!
    
    var isListView = Bool()
    var baeminInfo = [BaeminInfo]()
    var selectedCategory = [String]()
    var listViewController = UIStoryboard.ListViewStoryboard.instantiateViewController(withIdentifier: "ListView") as! ListViewController
    var mapViewController = UIStoryboard.MapViewStoryboard.instantiateViewController(withIdentifier: "MapView") as! MapViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name("getBaeminInfoFinished"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selected(category: [String]) {
        selectedCategory = category
    }
    
    func receive(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let baeminInfo = userInfo["BaeminInfo"] as? [BaeminInfo] else { return }
        self.baeminInfo = baeminInfo
    }
    
    @IBAction func searchLocationButtonAction(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        let addressFilter = GMSAutocompleteFilter()
        let color = UIColor(red: 42/255, green: 193/255, blue: 188/255, alpha: 1)
        
        autocompleteController.delegate = self
        addressFilter.country = "KR"
        autocompleteController.autocompleteFilter = addressFilter
        
        let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "지번, 도로명, 건물명을 검색하세요", attributes: placeholderAttributes)
        UISearchBar.appearance().tintColor = color
        autocompleteController.primaryTextHighlightColor = color

        present(autocompleteController, animated: false, completion: nil)
    }
    
    @IBAction func toggleButtonAction(_ sender: UIBarButtonItem) {
        let newView: UIViewController
        let oldView = childViewControllers.last
        
        if isListView {
            newView = mapViewController
            toggleButton.image = #imageLiteral(resourceName: "listicon")
        } else {
            newView = listViewController
            toggleButton.image = #imageLiteral(resourceName: "mapicon")
        }
        oldView?.willMove(toParentViewController: nil)
        addChildViewController(newView)
        newView.view.frame = oldView!.view.frame
        transition(from: oldView!, to: newView, duration: 0.3, options: isListView ? .transitionCrossDissolve : .transitionCrossDissolve, animations: nil) { (_) in
            newView.didMove(toParentViewController: self)
        }
        isListView = !isListView
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        let filterViewController = UIStoryboard.FilterViewStoryboard.instantiateViewController(withIdentifier: "FilterView") as! FilterViewController
        filterViewController.delegate = self
        filterViewController.selectedCategory = selectedCategory
        present(filterViewController, animated: true, completion: nil)
    }

}

extension MainContainerViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        Location.sharedInstance = Location(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        Networking().getBaeminInfo(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
