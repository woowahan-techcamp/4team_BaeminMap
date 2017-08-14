//
//  MapViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit
import GoogleMaps
import AlamofireImage

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var location = Location.sharedInstance
    var locationManager = CLLocationManager()
    var baeminInfo: [BaeminInfo]?
    lazy var parentView: MainContainerViewController = {
        let parent = self.parent as! MainContainerViewController
        return parent
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(drawMap), name: NSNotification.Name("finishedCurrentLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("getBaeminInfoFinished"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        drawMap()
        redrawMap()
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
        
        baeminInfo?.forEach({ (shop) in
            let marker = GMSMarker()
            DispatchQueue.main.async {
                marker.position = CLLocationCoordinate2D(latitude: shop.location["latitude"]!, longitude: shop.location["longitude"]!)
                marker.icon = #imageLiteral(resourceName: "chicken")
                marker.map = self.mapView
                marker.userData = shop
            }
        })
    }
    
    func redrawMap() {
        mapView.clear()
        drawMarker()
    }

}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
        let shop = marker.userData as! BaeminInfo
        if let url = shop.shopLogoImageUrl {
            cell.shopImageView.af_setImage(withURL: URL(string: url)!)
        }
        cell.frame = CGRect(x: 5, y: mapView.frame.maxY-110, width: mapView.frame.width-10, height: 105)
        cell.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: 10) {
            mapView.addSubview(cell)
        }
        parentView.filterButton.frame = CGRect(x: parentView.filterButton.frame.minX, y: cell.frame.minY+40, width: parentView.filterButton.frame.width, height: parentView.filterButton.frame.height)
        
        return true
    }
    
}
