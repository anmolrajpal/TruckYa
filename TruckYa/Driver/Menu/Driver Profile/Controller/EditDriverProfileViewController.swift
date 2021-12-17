//
//  EditDriverProfileViewController.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//
import UIKit
import CoreLocation

class EditDriverProfileViewController: UIViewController {
    var subView = EditDriverProfileView()
    var currentLocation: CLLocation!
    let locationManager = CLLocationManager()
    init(details:DriverProfile) {
        super.init(nibName: nil, bundle: nil)
        subView.configureView(withDriverDetails: details)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        view = subView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupLocationManager()
        setupTargetActions()
        self.subView.scrollView.setContentOffset(CGPoint(x: 0, y: self.subView.scrollView.contentOffset.y), animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationsObservers()
    }
}

