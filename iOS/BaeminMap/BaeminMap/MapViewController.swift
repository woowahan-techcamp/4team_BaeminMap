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
    let pageControl = UIPageControl()
    lazy var infoView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.width, height: 105)
        scrollView.contentSize.width = self.view.frame.width
        return scrollView
    }()
    lazy var filterButtonFrameY: CGFloat = {
        return self.parentView.filterButton.frame.minY
    }()
    var isZoom = true
    var currentPage = CGFloat(0)
    
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

extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var pageNumber = round((scrollView.contentOffset.x) / (scrollView.frame.size.width - 40))
        
////            var pageNumber = round((scrollView.contentOffset.x - 20) / (scrollView.frame.size.width - 20))
//            if pageNumber != self.currentPage{
//                let diff = pageNumber - self.currentPage
//                if Swift.abs(diff) > 1 {
//                    print("1보다 커!")
//                    pageNumber += diff < 0 ? 1 : -1
//                }
//                
//                
////                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
//                let x = pageNumber == 0 ? 0 : pageNumber * (scrollView.frame.size.width - 30)
//                self.infoView.setContentOffset(CGPoint(x:x, y:0), animated: true)
//                self.currentPage = pageNumber
//                    
////                })
//                print(pageNumber)
//            }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let x = currentPage == 0 ? 0 : currentPage * (scrollView.frame.size.width - 30)
//        infoView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var pageNumber = round((scrollView.contentOffset.x) / (scrollView.frame.size.width - 60))
        let x = pageNumber == 0 ? 0 : pageNumber * (scrollView.frame.size.width - 50)
//        infoView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        targetContentOffset.pointee = CGPoint(x:x, y:0)
    }
    
    func makePageCell(shop: BaeminInfo) -> ListTableViewCell {
        let cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.first as! ListTableViewCell
        cell.backgroundColor = UIColor.white
        cell.moveButton.isEnabled = true
//        cell.moveButton.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)
        
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
        
        //TODO : 현재는 testCount 로 임의의 개수로 넣어둠 ( 나중에 실제 리스트.count 입력할 것 )
        let testCount = 1
        infoView.delegate = self
//        infoView.isPagingEnabled = true
        infoView.bounces = false
        currentPage = CGFloat(0)
        
        var cellminX = CGFloat(30)
        var cellWidth = self.view.frame.width-60
        if testCount == 1 {
            cellminX = CGFloat(5)
            cellWidth = self.view.frame.width-10
        }
        
        for index in 0..<testCount {
            let cell = self.makePageCell(shop: shop)
            cell.frame = CGRect(x: cellminX, y: 0, width: cellWidth, height: 100)
            infoView.addSubview(cell)
            cellminX += cellWidth + 10
            
            cell.titleLabel.text = cell.titleLabel.text! + String(index)
  
            infoView.contentSize.width = cellminX
        }
//        infoView.contentSize.width = testCount > 1 ? infoView.frame.width * 2 : infoView.frame.width
        infoView.contentSize.width += 10
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
