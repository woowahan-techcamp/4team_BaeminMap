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
    lazy var baeminInfo: [BaeminInfo:[BaeminInfo]] = {
        return self.parentView.mapBaeminInfo
    }()
    lazy var infoView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 105)
        scrollView.contentSize.width = self.view.frame.width
        return scrollView
    }()
    lazy var filterButtonFrameY: CGFloat = {
        return self.parentView.view.frame.height - 42 - self.parentView.filterButton.frame.height
    }()
    var isZoom = true
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.addSubview(infoView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("finishedCurrentLocation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name("mapBaeminInfo"), object: nil)
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
            self.baeminInfo = parentView.mapBaeminInfo
            self.mapView.selectedMarker = nil
            self.redrawMap()
        }
    }
    
    func showDetailView() {
        let detailViewController = UIStoryboard.detailViewStoryboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        if let shops = mapView.selectedMarker?.userData as? [BaeminInfo] {
            detailViewController.baeminInfo = shops[pageControl.currentPage]
            navigationController?.pushViewController(detailViewController, animated: true)
        }
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
            marker.map = mapView
            marker.zIndex = 0
            marker.position = CLLocationCoordinate2D(latitude: shop.key.location["latitude"]!, longitude: shop.key.location["longitude"]!)
            let index = pageControl.currentPage
            if let selectedShop = selectedMarker?.userData as? [BaeminInfo],
                shop.key == selectedShop[index] || shop.value.contains(selectedShop[index]) {
                marker.icon = UIImage(named: selectedShop[index].categoryEnglishName+"Fill")
                marker.userData = selectedShop
                mapView.selectedMarker = marker
            } else {
                if shop.value.count == 1 {
                    marker.userData = [shop.value[0]]
                    marker.icon = count < 30 || isZoom ? UIImage(named: shop.value[0].categoryEnglishName) : #imageLiteral(resourceName: "smallMarker")
                } else {
                    marker.userData = shop.value
                    marker.icon = #imageLiteral(resourceName: "plusMarker")
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
                self.infoView.frame = CGRect(x: 0, y: self.mapView.frame.maxY-110, width: self.mapView.frame.width, height: 105)
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
        infoView.subviews.forEach { $0.removeFromSuperview() }
        guard let shops = marker.userData as? [BaeminInfo] else { return false }
        
        infoViewAnimate(isTap: true)
        
        if let selectedMarker = mapView.selectedMarker,
            let selectedShop = selectedMarker.userData as? [BaeminInfo] {
            selectedMarker.zIndex = 0
            selectedMarker.icon = selectedShop.count == 1 ? UIImage(named: selectedShop[0].categoryEnglishName) : #imageLiteral(resourceName: "plusMarker")
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: mapView.camera.zoom > 17 ? mapView.camera.zoom : 17)
        
        infoView.delegate = self
        infoView.isScrollEnabled = true
        
        var cellminX = CGFloat(30)
        var cellWidth = self.view.frame.width-60
        if shops.count == 1 {
            infoView.isScrollEnabled = false
            cellminX = CGFloat(5)
            cellWidth = self.view.frame.width-10
        }
        for shop in shops {
            let cell = makePageCell(shop: shop)
            cell.frame = CGRect(x: cellminX, y: 0, width: cellWidth, height: 100)
            infoView.addSubview(cell)
            cellminX += cellWidth+10
            infoView.contentSize.width = cellminX
        }
        pageControl.numberOfPages = shops.count
        infoView.contentSize.width += 10
        
        mapView.selectedMarker = marker
        marker.map = mapView
        marker.zIndex = 1
        marker.icon = UIImage(named: shops[0].categoryEnglishName+"Fill")
        mapView.animate(to: camera)
        
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

extension MapViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidth = (scrollView.frame.size.width - 60)
        let itemSpacing = CGFloat(10)
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(infoView.contentSize.width)
        var newPage = Float(self.pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
        
        if let shop = mapView.selectedMarker?.userData as? [BaeminInfo] {
            mapView.selectedMarker?.icon = UIImage(named: shop[pageControl.currentPage].categoryEnglishName+"Fill")
        }
    }
    
    func makePageCell(shop: BaeminInfo) -> ListTableViewCell {
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
        cell.backgroundColor = UIColor.white
        cell.moveButton.isEnabled = true
        cell.moveButton.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
        
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
        return cell
    }
}
