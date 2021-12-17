//
//  EditDriverProfileHelpers.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import CoreLocation
extension EditDriverProfileViewController {
    internal func setupTargetActions() {
        subView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        subView.saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        subView.addressTextField.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationButtonTapped)))
    }
    @objc func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapSaveButton() {
        subView.initiateSaveButtonTappedAnimation()
        self.subView.spinner.startAnimating()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if let name = self.subView.nameTextField.text,
            let phoneNumber = self.subView.phoneNumberTextField.text,
            let address = self.subView.addressTextField.text,
            let city = self.subView.cityTextField.text,
            let state = self.subView.stateTextField.text,
            let country = self.subView.countryTextField.text,
            let zipCode = self.subView.zipCodeTextField.text,
            let driverDescription = self.subView.aboutTextView.text,
            !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zipCode.isEmpty, !driverDescription.isEmpty {
            self.view.endEditing(true)
            self.callUpdateProfileSequence(userId: UserDefaults.standard.userID!, fullName: name, phoneNumber: phoneNumber, address: address, city: city, state: state, country: country, postalCode: zipCode, description: driverDescription)
        } else {
            self.subView.fallBackToIdentity()
        }
    }
    
    internal func handleSuccess() {
        print("Handling Success")
        AssertionModalController(title: "Updated").show(on: self) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    internal func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    internal func removeKeyboardNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let contentInsets: UIEdgeInsets = .zero
            self.subView.scrollView.contentInset = contentInsets
            self.subView.scrollView.scrollIndicatorInsets = contentInsets
        }, completion: nil)
    }
    @objc func keyboardShow(notification:NSNotification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight:CGFloat = keyboardSize?.height ?? 280.0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + 50.0, right: 0.0)
            self.subView.scrollView.contentInset = contentInsets
            self.subView.scrollView.scrollIndicatorInsets = contentInsets
        }, completion: nil)
    }
    @objc internal func locationButtonTapped() {
        autofill()
    }
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            
            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })
        
    }
    func setupLocationManager() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                
                currentLocation = locationManager.location
                
            }
        }
        
    }
    func autofill() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                
                currentLocation = locationManager.location
                getPlacemark(forLocation: currentLocation) {
                    (originPlacemark, error) in
                    if let err = error {
                        print(err)
                    } else if let placemark = originPlacemark {
                        // Do something with the placemark
                        let address = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                        print("\(address)")
                        self.subView.addressTextField.text = address
                        self.subView.cityTextField.text = placemark.locality
                        self.subView.stateTextField.text = placemark.administrativeArea
                        self.subView.countryTextField.text = placemark.country
                        self.subView.zipCodeTextField.text = placemark.postalCode
                        self.subView.validateFields()
                    }
                }
            }
        }
    }
}
