//
//  ViewController.swift
//  BeaminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var toggleButton: UIBarButtonItem!
    var isMapView = Bool()
    var listViewController = UIStoryboard.ListViewStoryboard.instantiateViewController(withIdentifier: "ListView") as! ListViewController
    var mapViewController = UIStoryboard.MapViewStoryboard.instantiateViewController(withIdentifier: "MapView") as! MapViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}

