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
    @IBOutlet weak var currentLocationButton: UIButton!
    
    var location = Location.sharedInstance
    lazy var parentView: MainContainerViewController = {
        return self.parent as! MainContainerViewController
    }()
    lazy var baeminInfo: [BaeminInfo] = {
        return self.parentView.filterBaeminInfo
    }()
    lazy var cell: ListTableViewCell = {
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
        cell.backgroundColor = UIColor.white
//        cell.frame = CGRect(x: 5, y: self.view.frame.maxY, width: self.view.frame.width-10, height: 105)
        cell.moveButton.isEnabled = true
        cell.moveButton.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
        return cell
    }()
    lazy var infoView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 105)
        scrollView.contentSize.width = 1000
        return scrollView
    }()
    lazy var filterButtonFrameY: CGFloat = {
        return self.parentView.filterButton.frame.minY
    }()
    var isZoom = true
    
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
    
    func recieve(notification: Notification) {
        if notification.name == NSNotification.Name("finishedCurrentLocation") {
            mapView.clear()
            drawMap()
        } else {
            self.baeminInfo = parentView.filterBaeminInfo
            self.mapView.selectedMarker = nil
            self.redrawMap()
        }
    }
    
    func showDetailView() {
        let detailViewController = UIStoryboard.detailViewStoryboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        detailViewController.baeminInfo = mapView.selectedMarker?.userData as! BaeminInfo
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func moveToCurrentLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        mapView.animate(to: camera)
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
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: shop.location["latitude"]!, longitude: shop.location["longitude"]!)
            marker.map = self.mapView
            marker.userData = shop
            marker.zIndex = 0
            if let selectedShop = selectedMarker?.userData as? BaeminInfo, shop === selectedShop {
                marker.icon = UIImage(named: shop.categoryEnglishName+"Fill")
                self.mapView.selectedMarker = marker
            } else {
                marker.icon = count < 30 || self.isZoom ? UIImage(named: shop.categoryEnglishName) : #imageLiteral(resourceName: "smallMarker")
            }
        }
    }
    
    func redrawMap() {
        let selectedMarker = mapView.selectedMarker
        mapView.clear()
        drawMarker(selectedMarker: selectedMarker)
    }
    
    func infoViewAnimate(isTap: Bool) {
        cell.frame = CGRect(x: 20, y: 0, width: self.view.frame.width-50, height: 100)
        infoView.addSubview(cell)
        
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
        
        guard let shop = marker.userData as? BaeminInfo else { return false }
        
        infoViewAnimate(isTap: true)
        if let selectedMarker = mapView.selectedMarker,
            let selectedShop = selectedMarker.userData as? BaeminInfo {
            selectedMarker.zIndex = 0
            selectedMarker.icon = UIImage(named: selectedShop.categoryEnglishName)
        }
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: mapView.camera.zoom > 17 ? mapView.camera.zoom : 17)
        mapView.selectedMarker = marker
        marker.map = mapView
        marker.zIndex = 1
        marker.icon = UIImage(named: shop.categoryEnglishName+"Fill")
        mapView.animate(to: camera)
        
        let distance = shop.distance.convertDistance()
        if let url = shop.shopLogoImageUrl {
            cell.shopImageView.af_setImage(withURL: URL(string: url)!)
        }
        cell.titleLabel.text = shop.shopName
        cell.reviewLabel.text = "최근리뷰 \(String(shop.reviewCount))"
        cell.ownerReviewLabel.text = "최근사장님댓글 \(String(shop.reviewCountCeo))"
        cell.ratingView.rating = shop.starPointAverage
        cell.distanceLabel.text = "\(shop.distance > 1 ? "\(distance)km" : "\(Int(distance))m")"
        cell.isPay(baro: shop.useBaropay, meet: shop.useMeetPay)
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoViewAnimate(isTap: false)
        self.redrawMap()
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if position.zoom < 17 && isZoom {
            isZoom = false
            self.redrawMap()
        } else if position.zoom >= 17 && !isZoom {
            isZoom = true
            self.redrawMap()
        }
    }
}
