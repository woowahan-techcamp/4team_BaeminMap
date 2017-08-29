//
//  ViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import GooglePlaces

class MainContainerViewController: UIViewController {

    @IBOutlet weak var toggleButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    
    var listViewController = UIStoryboard.listViewStoryboard.instantiateViewController(withIdentifier: "ListView") as! ListViewController
    var mapViewController = UIStoryboard.mapViewStoryboard.instantiateViewController(withIdentifier: "MapView") as! MapViewController
    var isListView = Bool()
    lazy var filterButtonMaxY: CGFloat = {
        self.filterButton.frame.maxY
    }()
    lazy var filterButtonMinY: CGFloat = {
        self.view.frame.height-self.filterButtonConstraint.constant-self.filterButton.frame.height
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(mapViewController)
        mapViewController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        containerView.addSubview(mapViewController.view)
        mapViewController.didMove(toParentViewController: self)
        AnimationView.startLaunchView(target: self)
        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name.filterFrame, object: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func receive(notification: Notification) {
        if let userInfo = notification.userInfo as? [String:CGFloat],
            let infoViewHeight = userInfo["filterFrameY"] {
            let y = filterButtonMaxY - infoViewHeight
            filterButton.frame = CGRect(x: filterButton.frame.minX, y: y, width: filterButton.frame.width, height: filterButton.frame.height)
        } else {
            filterButton.frame = CGRect(x: filterButton.frame.minX, y: filterButtonMinY, width: filterButton.frame.width, height: filterButton.frame.height)
        }
    }

    @IBAction func searchLocationButtonAction(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        let addressFilter = GMSAutocompleteFilter()

        autocompleteController.delegate = self
        addressFilter.country = "KR"
        autocompleteController.autocompleteFilter = addressFilter

        let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 13)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "지번, 도로명, 건물명을 검색하세요", attributes: placeholderAttributes)
        UISearchBar.appearance().tintColor = UIColor.pointColor
        autocompleteController.primaryTextHighlightColor = UIColor.pointColor

        present(autocompleteController, animated: false, completion: nil)
    }

    @IBAction func toggleButtonAction(_ sender: UIBarButtonItem) {
        let newView: UIViewController
        let oldView = childViewControllers.last
        print(childViewControllers)
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
        let filterViewController = UIStoryboard.filterViewStoryboard.instantiateViewController(withIdentifier: "FilterView") as! FilterViewController
        present(filterViewController, animated: true, completion: nil)
    }

}

extension MainContainerViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        Location.sharedInstance = Location(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        Networking().getBaeminInfo(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        dismiss(animated: true) {
            AnimationView.noshopView.removeFromSuperview()
            AnimationView.startIndicator(target: self.view, image: "mapicon", alpha: 0.8)
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
