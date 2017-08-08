//
//  ViewController.swift
//  BeaminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import GooglePlaces

class MainContainerViewController: UIViewController {

    @IBOutlet weak var toggleButton: UIBarButtonItem!
    var isMapView = Bool()
    var listViewController = UIStoryboard.ListViewStoryboard.instantiateViewController(withIdentifier: "ListView") as! ListViewController
    var mapViewController = UIStoryboard.MapViewStoryboard.instantiateViewController(withIdentifier: "MapView") as! MapViewController
    var baeminInfo: [BaeminInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receive), name: NSNotification.Name("getBaeminInfoFinished"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func searchLocationButtonAction(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func toggleButtonAction(_ sender: UIBarButtonItem) {
        toggleButton.image = isMapView ? #imageLiteral(resourceName: "mapicon") : #imageLiteral(resourceName: "listicon")
        
        let newView = isMapView ? mapViewController : listViewController
        let oldView = childViewControllers.last
        
        oldView?.willMove(toParentViewController: nil)
        addChildViewController(newView)
        newView.view.frame = oldView!.view.frame
        
        transition(from: oldView!, to: newView, duration: 0, options: isMapView ? .transitionCrossDissolve : .transitionCrossDissolve, animations: nil) { (_) in
            oldView?.removeFromParentViewController()
            newView.didMove(toParentViewController: self)
        }
        isMapView = !isMapView
    }
    
    func receive(notification: Notification) {
        guard let userInfo = notification.userInfo,
        let baeminInfo = userInfo["BaeminInfo"] as? [BaeminInfo] else { return }
        self.baeminInfo = baeminInfo
    }

}

extension MainContainerViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        Location.sharedInstance = Location(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
