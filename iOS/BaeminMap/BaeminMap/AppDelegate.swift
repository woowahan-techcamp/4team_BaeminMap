//
//  AppDelegate.swift
//  BaeminMap
//
//  Created by HannaJeon on 2017. 8. 7..
//  Copyright © 2017년 HannaJeon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Config.googleMapKey)
        GMSPlacesClient.provideAPIKey(Config.googleMapKey)

        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            getBaeminInfoByLocation()
        }
        UINavigationBar.setNavigation()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        let location = manager.location?.coordinate
        if let currentLocation = location {
            Location.sharedInstance = Location(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        }
        getBaeminInfoByLocation()
    }

    func getBaeminInfoByLocation() {
        Networking().getBaeminInfo(latitude: Location.sharedInstance.latitude, longitude: Location.sharedInstance.longitude)
        NotificationCenter.default.post(name: Notification.Name.location, object: self)
    }
}
