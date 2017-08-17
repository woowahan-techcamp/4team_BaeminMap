//
//  MapViewController.swift
//  BaeminMap
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//
// TODO: mapView didChange에 줌기능 디바이스에서만 GCD 적용되어 현재는 주석상태. 추후 주석해제 예정

import UIKit
import GoogleMaps
import AlamofireImage

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    var location = Location.sharedInstance
    lazy var parentView: MainContainerViewController = {
        return self.parent as! MainContainerViewController
    }()
    lazy var baeminInfo: [BaeminInfo] = {
        return self.parentView.filterBaeminInfo
    }()
    lazy var infoView: ListTableViewCell = {
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
        cell.backgroundColor = UIColor.white
        cell.frame = CGRect(x: 5, y: self.view.frame.maxY, width: self.view.frame.width-10, height: 105)
        return cell
    }()
    var isZoom = true
    lazy var filterButtonFrameY: CGFloat = {
        return self.parentView.filterButton.frame.minY
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.addSubview(infoView)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("finishedCurrentLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("filterManager"), object: nil)
        currentLocationButton.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
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
    
    func moveToCurrentLocation(_ btn: UIButton) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        mapView.animate(to: camera)
    }
    
    func recieve(notification: Notification) {
        if notification.name == NSNotification.Name("finishedCurrentLocation") {
            mapView.clear()
            drawMap()
        } else {
            self.baeminInfo = parentView.filterBaeminInfo
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
    
    func drawMarker(selectedMarker: GMSMarker?) {
        drawCurrentLocation()
        for(count, shop) in baeminInfo.enumerated() {
            if shop.canDelivery {
                let marker = GMSMarker()
                DispatchQueue.main.async {
                    marker.position = CLLocationCoordinate2D(latitude: shop.location["latitude"]!, longitude: shop.location["longitude"]!)
                    marker.map = self.mapView
                    marker.userData = shop
                    if let selectedShop = selectedMarker?.userData as? BaeminInfo, shop === selectedShop {
                        marker.icon = UIImage(named: shop.categoryEnglishName+"Fill")
                        self.mapView.selectedMarker = marker
                    } else {
                        marker.icon = count < 30 || self.isZoom ? UIImage(named: shop.categoryEnglishName) : #imageLiteral(resourceName: "smallMarker")
                    }
                }
            }
        }
    }
    
    func redrawMap() {
        let selectedMarker = mapView.selectedMarker
        mapView.clear()
        drawMarker(selectedMarker: selectedMarker)
    }
    
    func infoViewAnimate(isTap: Bool) {
        let filterButtonFrame = parentView.filterButton.frame
        if isTap {
            UIView.animate(withDuration: 0.4) {
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
                self.infoView.frame = CGRect(x: 5, y: self.mapView.frame.maxY-110, width: self.mapView.frame.width-10, height: 105)
                let y = self.filterButtonFrameY - self.infoView.frame.height+20
                self.parentView.filterButton.frame = CGRect(x: filterButtonFrame.minX, y: y, width: filterButtonFrame.width, height: filterButtonFrame.height)
                self.mapView.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.infoView.frame = CGRect(x: 5, y: self.view.frame.maxY, width: self.view.frame.width-10, height: 105)
                self.parentView.filterButton.frame = CGRect(x: filterButtonFrame.minX, y: self.filterButtonFrameY, width: filterButtonFrame.width, height: filterButtonFrame.height)
                self.mapView.layoutIfNeeded()
            }
        }
    }

}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        infoViewAnimate(isTap: true)
        
        let shop = marker.userData as! BaeminInfo
        if let selectedMarker = mapView.selectedMarker {
            let selectedShop = selectedMarker.userData as! BaeminInfo
            selectedMarker.icon = UIImage(named: selectedShop.categoryEnglishName)
        }
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: mapView.camera.zoom > 17 ? mapView.camera.zoom : 17)
        mapView.selectedMarker = marker
        marker.map = mapView
        marker.icon = UIImage(named: shop.categoryEnglishName+"Fill")
        mapView.animate(to: camera)
        
        let distance = shop.distance.convertDistance()
        if let url = shop.shopLogoImageUrl {
            infoView.shopImageView.af_setImage(withURL: URL(string: url)!)
        }
        infoView.titleLabel.text = shop.shopName
        infoView.reviewLabel.text = "최근리뷰 \(shop.reviewCount ?? 0)"
        infoView.ownerReviewLabel.text = "최근사장님댓글 \(shop.reviewCountCeo ?? 0)"
        infoView.ratingView.rating = shop.starPointAverage
        infoView.distanceLabel.text = "\(shop.distance > 1 ? "\(distance)km" : "\(Int(distance))m")"
        infoView.isPay(baro: shop.useBaropay, meet: shop.useMeetPay)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoViewAnimate(isTap: false)
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if position.zoom < 17 && isZoom {
            isZoom = false
//            DispatchQueue.global().async {
                self.redrawMap()
//            }
        } else if position.zoom >= 17 && !isZoom {
            isZoom = true
//            DispatchQueue.global().async {
                self.redrawMap()
//            }
        }
    }
}
