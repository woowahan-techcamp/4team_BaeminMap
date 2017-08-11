//
//  MapViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var location = Location.sharedInstance
    var locationManager = CLLocationManager()
    var parentView: MainContainerViewController!
    lazy var baeminInfo: [BaeminInfo] = {
        let parentView = self.parent as! MainContainerViewController
        return parentView.baeminInfo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(drawMap), name: NSNotification.Name("finishedCurrentLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("getBaeminInfoFinished"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        drawMap()
        drawMarker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recieve(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let baeminInfo = userInfo["BaeminInfo"] as? [BaeminInfo] else { return }
        self.baeminInfo = baeminInfo
        self.redrawMap()
    }

}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func drawMap() {
        location = Location.sharedInstance
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        mapView.camera = camera
    }
    
    func drawMarker() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude-0.00001, longitude: location.longitude)
        marker.icon = #imageLiteral(resourceName: "currentLocation")
        marker.map = mapView
        
        baeminInfo.forEach({ (shop) in
            let marker = GMSMarker()
            DispatchQueue.main.async {
                marker.position = CLLocationCoordinate2D(latitude: shop.location["latitude"]!, longitude: shop.location["longitude"]!)
                marker.icon = #imageLiteral(resourceName: "chicken")
                marker.map = self.mapView
            }
        })
    }
    
    func redrawMap() {
        mapView.clear()
        drawMarker()
    }
    
}
