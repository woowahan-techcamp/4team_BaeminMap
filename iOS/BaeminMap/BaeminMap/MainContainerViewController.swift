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
    var isMapView = Bool()
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
    
    @IBAction func searchLocationButtonAction(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func toggleButtonAction(_ sender: UIBarButtonItem) {
        let newView: UIViewController
        let oldView = childViewControllers.last
        
        if isMapView {
            newView = mapViewController
            toggleButton.image = #imageLiteral(resourceName: "mapicon")
            mapViewController.baeminInfo = baeminInfo
        } else {
            newView = listViewController
            toggleButton.image = #imageLiteral(resourceName: "listicon")
            listViewController.baeminInfo = baeminInfo
        }
        oldView?.willMove(toParentViewController: nil)
        addChildViewController(newView)
        newView.view.frame = oldView!.view.frame
        transition(from: oldView!, to: newView, duration: 0.1, options: isMapView ? .transitionCrossDissolve : .transitionCrossDissolve, animations: nil) { (_) in
            newView.didMove(toParentViewController: self)
        }
        isMapView = !isMapView
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
