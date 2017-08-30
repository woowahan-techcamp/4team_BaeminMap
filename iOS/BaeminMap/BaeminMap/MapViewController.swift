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
    @IBOutlet weak var currentLocationConstraint: NSLayoutConstraint!

    var location = Location.sharedInstance
    var baeminInfo = BaeminInfoData.shared.mapBaeminInfo
    var isZoom = true
    var isViewType = false
    var pageControl = UIPageControl()
    var infoView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY, width: UIScreen.main.bounds.width, height: 105)
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addSubview(infoView)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name.location, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieve), name: NSNotification.Name.mapBaeminInfo, object: nil)
        currentLocationButton.addTarget(self, action: #selector(moveToCurrentLocation), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        drawMap()
        if !isViewType {
            infoViewAnimate(isTap: false)
            mapView.selectedMarker = nil
        } else {
            isViewType = false
        }
        redrawMap()
        showNoshop()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if !isViewType {
            infoViewAnimate(isTap: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func recieve(notification: Notification) {
        if notification.name == NSNotification.Name.location {
            mapView.clear()
            drawMap()
            drawCurrentLocation()
        } else {
            self.baeminInfo = BaeminInfoData.shared.mapBaeminInfo
            self.mapView.selectedMarker = nil
            self.redrawMap()
            showNoshop()
        }
    }

    func showDetailView() {
        let detailViewController = UIStoryboard.detailViewStoryboard.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        if let shops = mapView.selectedMarker?.userData as? [BaeminInfo] {
            detailViewController.baeminInfo = shops[pageControl.currentPage]
            navigationController?.pushViewController(detailViewController, animated: true)
            isViewType = true
        }
    }

    func moveToCurrentLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        mapView.animate(to: camera)
    }

    func drawMap() {
        location = Location.sharedInstance
        var camera = GMSCameraPosition()
        if isViewType {
            if let shop = mapView.selectedMarker?.userData as? [BaeminInfo] {
                camera = GMSCameraPosition.camera(withLatitude: shop[0].location["latitude"]!, longitude: shop[0].location["longitude"]!, zoom: 17.0)
            }
        } else {
            camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 17.0)
        }
        mapView.camera = camera
    }

    func drawCurrentLocation() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude-0.00001, longitude: location.longitude)
        marker.icon = #imageLiteral(resourceName: "currentLocation")
        marker.map = mapView
        marker.zIndex = 1
    }

    func drawMarker(selectedMarker: GMSMarker?) {
        guard let baeminInfo = baeminInfo else { return }
        for(count, shop) in baeminInfo.enumerated() {
            let marker = GMSMarker()
            marker.map = mapView
            marker.position = CLLocationCoordinate2D(latitude: shop.key.location["latitude"]!, longitude: shop.key.location["longitude"]!)
            let index = pageControl.currentPage
            if let selectedShop = selectedMarker?.userData as? [BaeminInfo],
                shop.key == selectedShop[index] || shop.value.contains(selectedShop[index]) {
                marker.icon = UIImage(named: selectedShop[index].categoryEnglishName+"Fill")
                marker.userData = selectedShop
                marker.zIndex = 1
                mapView.selectedMarker = marker
            } else {
                if shop.value.count == 1 {
                    marker.userData = [shop.value[0]]
                    marker.icon = count < 30 || isZoom ? UIImage(named: shop.value[0].categoryEnglishName) : #imageLiteral(resourceName: "smallMarker")
                } else {
                    marker.userData = shop.value
                    marker.icon = "+\(shop.value.count)".drawPlusMarker()
                }
                marker.zIndex = 0
            }
        }
        drawCurrentLocation()
    }

    func redrawMap() {
        let selectedMarker = mapView.selectedMarker
        mapView.clear()
        drawMarker(selectedMarker: selectedMarker)
    }

    func showNoshop() {
        guard let baeminInfo = baeminInfo else { return }
        if baeminInfo.isEmpty {
            mapView.addSubview(AnimationView.noshopView)
            currentLocationConstraint.constant = 30
            mapView.layoutIfNeeded()
        } else {
            AnimationView.noshopView.removeFromSuperview()
            currentLocationConstraint.constant = 15
        }
    }

    func infoViewAnimate(isTap: Bool) {
        if isTap {
            UIView.animate(withDuration: 0.4) {
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
                self.infoView.frame = CGRect(x: 0, y: self.mapView.frame.maxY-110, width: self.mapView.frame.width, height: 105)
                NotificationCenter.default.post(name: NSNotification.Name.filterFrame, object: self, userInfo: ["filterFrameY": self.infoView.frame.height+20])
                self.mapView.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.infoView.frame = CGRect(x: 5, y: UIScreen.main.bounds.maxY, width: UIScreen.main.bounds.width-10, height: 105)
                NotificationCenter.default.post(name: NSNotification.Name.filterFrame, object: self)
                self.mapView.layoutIfNeeded()
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        infoView.subviews.forEach { $0.removeFromSuperview() }
        if marker.position.latitude+0.00001 == location.latitude && marker.position.longitude == location.longitude {
            DispatchQueue.main.async {
                self.infoViewAnimate(isTap: false)
            }
        } else {
            DispatchQueue.main.async {
                self.infoViewAnimate(isTap: true)
            }
        }
        if let selectedMarker = mapView.selectedMarker,
            let selectedShop = selectedMarker.userData as? [BaeminInfo] {
            selectedMarker.zIndex = 0
            selectedMarker.icon = selectedShop.count == 1 ? UIImage(named: selectedShop[0].categoryEnglishName) :
                "+\(selectedShop.count)".drawPlusMarker()
        }

        guard let shops = marker.userData as? [BaeminInfo] else { return false }

        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: mapView.camera.zoom > 17 ? mapView.camera.zoom : 17)
        mapView.animate(to: camera)

        infoView.delegate = self
        infoView.isScrollEnabled = true
        infoView.decelerationRate = UIScrollViewDecelerationRateFast

        var cellminX = CGFloat(40)
        var cellWidth = UIScreen.main.bounds.width-80
        if shops.count == 1 {
            infoView.isScrollEnabled = false
            cellminX = CGFloat(10)
            cellWidth = UIScreen.main.bounds.width-20
        }

        infoView.contentOffset.x = 0
        for shop in shops {
            let cell = makePageCell(shop: shop)
            cell.frame = CGRect(x: cellminX, y: 0, width: cellWidth, height: 100)
            infoView.addSubview(cell)
            cellminX += cellWidth+10
            infoView.contentSize.width = cellminX
        }
        infoView.contentSize.width += 30
        pageControl.currentPage = 0
        pageControl.numberOfPages = shops.count

        mapView.selectedMarker = marker
        marker.map = mapView
        marker.zIndex = 1
        marker.icon = UIImage(named: shops[0].categoryEnglishName+"Fill")

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
        let itemWidth = (scrollView.frame.size.width - 80)
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
            if newPage > contentWidth / pageWidth {
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
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = UIColor.white
        cell.moveButton.isEnabled = true
        cell.rightArrowImage.isHidden = true
        cell.moveButton.addTarget(self, action: #selector(showDetailView), for: .touchUpInside)

        let distance = shop.distance.convertDistance()
        if let url = shop.shopLogoImageUrl {
            cell.shopImageView.af_setImage(withURL: URL(string: url)!, completion: { (_) in
                cell.shopImageView.isHidden = false
            })
        } else {
            cell.shopImageView.isHidden = false
        }
        cell.titleLabel.text = shop.shopName
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.titleLabel.trailingAnchor.constraint(equalTo: cell.infoView.trailingAnchor, constant: 0).isActive = true
        cell.reviewLabel.text = "리뷰 \(String(shop.reviewCount))"
        cell.ownerReviewLabel.text = "사장님댓글 \(String(shop.reviewCountCeo))"
        cell.ratingView.rating = shop.starPointAverage
        cell.distanceLabel.text = "\(shop.distance > 1 ? "\(distance)km" : "\(Int(distance))m")"
        cell.isPay(baro: shop.useBaropay, meet: shop.useMeetPay)
        return cell
    }
}
