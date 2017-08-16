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
    lazy var baeminInfo: [BaeminInfo] = {
        return self.parentView.baeminInfo
    }()
    lazy var baeminInfoDic: [Int:[BaeminInfo]] = {
        return self.parentView.baeminInfoDic
    }()
    lazy var parentView: MainContainerViewController = {
        return self.parent as! MainContainerViewController
    }()
    lazy var infoView: ListTableViewCell = {
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
        cell.backgroundColor = UIColor.white
        cell.frame = CGRect(x: 5, y: self.view.frame.maxY, width: self.view.frame.width-10, height: 105)
        return cell
    }()
    var isZoom = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.addSubview(infoView)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("finishedCurrentLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("getBaeminInfoFinished"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        drawMap()
        redrawMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        infoViewAnimate(isTap: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recieve(notification: Notification) {
        if notification.name == NSNotification.Name("finishedCurrentLocation") {
            mapView.clear()
            drawMap()
        } else {
            guard let userInfo = notification.userInfo,
                let baeminInfo = userInfo["BaeminInfo"] as? [BaeminInfo],
                let baeminInfoDic = userInfo["BaeminInfoDic"] as? [Int:[BaeminInfo]] else { return }
            self.baeminInfo = baeminInfo
            self.baeminInfoDic = baeminInfoDic
            self.redrawMap()
        }
    }
    
    func drawMap() {
        location = Location.sharedInstance
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        mapView.camera = camera
        drawCurrentLocation()
    }
    

    func drawCurrentLocation() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude-0.00001, longitude: location.longitude)
        marker.icon = #imageLiteral(resourceName: "currentLocation")
        marker.map = mapView
    }
    
    func drawMarker() {
        drawCurrentLocation()
        
        for(count, shop) in baeminInfo.enumerated() {
            let marker = GMSMarker()
            DispatchQueue.main.async {
                marker.position = CLLocationCoordinate2D(latitude: shop.location["latitude"]!, longitude: shop.location["longitude"]!)
                marker.icon = count < 30 || self.isZoom ? #imageLiteral(resourceName: "chicken") : #imageLiteral(resourceName: "smallMarker")
                marker.map = self.mapView
                marker.userData = shop
            }
        }
    }
    
    func redrawMap() {
        mapView.clear()
        drawMarker()
    }
    
    func infoViewAnimate(isTap: Bool) {
        let filterButtonFrame = parentView.filterButton.frame
        if isTap {
            UIView.animate(withDuration: 0.4) {
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
                self.infoView.frame = CGRect(x: 5, y: self.mapView.frame.maxY-110, width: self.mapView.frame.width-10, height: 105)
                self.parentView.filterButton.frame = CGRect(x: filterButtonFrame.minX, y: self.infoView.frame.minY+50, width: filterButtonFrame.width, height: filterButtonFrame.height)
                self.mapView.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.infoView.frame = CGRect(x: 5, y: self.view.frame.maxY, width: self.view.frame.width-10, height: 105)
                self.parentView.filterButton.frame = CGRect(x: filterButtonFrame.minX, y: 494, width: filterButtonFrame.width, height: filterButtonFrame.height)
                self.mapView.layoutIfNeeded()
            }
        }
    }

}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        infoViewAnimate(isTap: true)
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17.0)
        mapView.animate(to: camera)
        
        let shop = marker.userData as! BaeminInfo
        let distance = shop.distance.convertDistance()
        if let url = shop.shopLogoImageUrl {
            infoView.shopImageView.af_setImage(withURL: URL(string: url)!)
        }
        infoView.titleLabel.text = shop.shopName
        infoView.reviewLabel.text = "최근리뷰 \(shop.reviewCount ?? 0)"
        infoView.ownerReviewLabel.text = "최근사장님댓글 \(shop.reviewCountCeo ?? 0)"
        infoView.ratingView.rating = shop.starPointAverage
        infoView.distanceLabel.text = "\(shop.distance > 1 ? "\(distance)km" : "\(Int(distance))m")"
        infoView.isBaropay(baro: shop.useBaropay)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoViewAnimate(isTap: false)
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if position.zoom < 17 && isZoom {
            isZoom = false
//            DispatchQueue.main.async {
                self.redrawMap()
//            }
        } else if position.zoom >= 17 && !isZoom {
            isZoom = true
//            DispatchQueue.main.async {
                self.redrawMap()
//            }
        }
    }
}
