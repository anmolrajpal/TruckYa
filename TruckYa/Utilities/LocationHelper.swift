//
//  LocationHelper.swift
//  Tempo
//
//  Created by Anshul on 29/08/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    var lat = ""
    var long = ""
    var locationManager:CLLocationManager!
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last
        lat = String(format: "%.4f", latestLocation!.coordinate.latitude)
        long = String(format: "%.4f", latestLocation!.coordinate.longitude)
        print(lat)
        print(long)
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location fgdfgdError")
    }
    
}

//extension UIViewController{
//
//    func getCurrentCity(completion :@escaping (_ city : String)-> Void) {
//        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
//        appDelegate.setupLocationManager()
//
//        let geoCoder = CLGeocoder()
//        let lat = Double(AppDelegate.shared.lat)
//        let long = Double(AppDelegate.shared.long)
//        if lat != nil && long != nil{
//            let location = CLLocation(latitude: lat!, longitude: long!)
//            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
//                placemarks?.forEach { (placemark) in
//                    if let city = placemark.locality {
//                        completion(city)
//
//                    }
//                }
//            })
//        }else {
//            openSettingForLocation()
//        }
//    }
//
//    func getAddressFromLatLon(completion :@escaping (_ city : String)-> Void) {
//
//        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
//        appDelegate.setupLocationManager()
//        if((AppDelegate.shared.lat != nil && AppDelegate.shared.lat != "") &&
//            (AppDelegate.shared.long != nil && AppDelegate.shared.long != "")){
//            var address = ""
//            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//            let lat = Double(AppDelegate.shared.lat)
//            let long = Double(AppDelegate.shared.long)
//            let ceo: CLGeocoder = CLGeocoder()
//            center.latitude = lat!
//            center.longitude = long!
//
//            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//            ceo.reverseGeocodeLocation(loc, completionHandler:{ (placemarks, error) in
//                if (error != nil){
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                let pm = placemarks! as [CLPlacemark]
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//                    var addressString : String = ""
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//                    address = addressString
//                    completion(address)
//                }
//            })
//        }else{
//            return completion("Not found")
//        }
//    }
//
//    func openSettingForLocation(){
//        let constant = LocationHelper()
//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedAlways:
//            constant.setupLocationManager()
//        case .notDetermined:
//            constant.locationManager.requestAlwaysAuthorization()
//        case .authorizedWhenInUse, .restricted, .denied:
//            let alertController = UIAlertController(
//                title: "Background Location Access Disabled",
//                message: "To get your current location, please open this app's settings and set location access to 'Always'.",
//                preferredStyle: .alert)
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertController.addAction(cancelAction)
//
//            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
//                if let url = NSURL(string:UIApplication.openSettingsURLString) {
//                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//                }
//            }
//            alertController.addAction(openAction)
//            present(alertController, animated: true, completion: nil)
//        }
//    }
//}

