//
//  CustomerDashboardVC.swift
//  TruckYa
//
//  Created by Digit Bazar on 07/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import CoreLocation
import JSSAlertView
import GoogleMaps
public enum BookingStatus {
    case Requested, Accepted, DriverReached, JourneyStarted, Cancel
    static func getBookingStatus(from status:String) -> BookingStatus {
        switch status {
        case "request": return .Requested
        case "accepted": return .Accepted
        case "driverreached": return .DriverReached
        case "start": return .JourneyStarted
        case "cancel": return .Cancel
        default: fatalError("Unknown case => \(status)")
        }
    }
}
class CustomerDashboardVC: UIViewController {
    
    var driverMarkerDictionary:[String:GMSMarker] = [:]
    
    func setupDriversOnMapView() {
        guard let drivers = self.nearbyDrivers else {
            return
        }
        drivers.forEach { (driver) in
            guard let driverId = driver.driverdetails?.id, let latitude = driver.driverdetails?.lat, let longitude = driver.driverdetails?.longField else {
                return
            }
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let marker = GMSMarker()
            marker.position = coordinates
            marker.icon = #imageLiteral(resourceName: "truck_marker").withRenderingMode(.alwaysTemplate).maskWithColor(color: UIColor.red)
            marker.setIconSize(scaledToSize: .init(width: 50, height: 50))
            marker.title = "\(driver.driverdetails?.fullname?.capitalized ?? "Driver")"
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.isFlat = true
            marker.tracksViewChanges = true
            
            marker.map = subView.mapView
            marker.userData = driverId
//            driverMarkerDictionary[(driver.driverdetails?.id)!] = marker
        }
    }
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    internal var currentState: State = .closed
    
    /// All of the currently running animators.
    internal var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    internal var animationProgress = [CGFloat]()
    
    internal lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.minimumNumberOfTouches = 1
        recognizer.maximumNumberOfTouches = 1
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    
    var lastBookingDetails: CurrentBookings.Datum.Booking! {
        didSet {
            guard let details = lastBookingDetails else { return }
            guard let status = details.status, !status.isEmpty else {
                print("Booking Status not found- Decodable\n Aborting Now")
                return
            }
            let bookingStatus = BookingStatus.getBookingStatus(from: status)
            print("\n----------------------- Booking Status ---------------------------\n\n\t•••••••••••••••••• \(bookingStatus) •••••••••••••••••\n\n----------------------------------------------------\n")
            
        }
    }
    var bookingDetails:AcceptBookingPayload! {
        didSet {
            guard let details = bookingDetails else {
                print("Holy Moly")
                return
            }
            print("Accept Boooking Payload Set =>")
            print(details)
            processNotification(with: details)
        }
    }
    var sourceCoordinates:CLLocationCoordinate2D!
    var destinationCoordinates:CLLocationCoordinate2D!
    var currentBookingId:String?
    func processNotification(with details: AcceptBookingPayload) {
        guard let booking_id = details.bookingid else {
            print("Failed to unwrap booking ID")
            let alertview = JSSAlertView().show(self,
                                                title: "Error",
                                                text: "Booking ID not available in notification",
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
            alertview.setTextTheme(.light)
            return
        }
        currentBookingId = booking_id
        let alertview = JSSAlertView().show(self,
                                            title: "Booking Accepted",
                                            text: "Your truck driver is on the way to the source location",
                                            buttonText: "OK",
                                            color: UIColorFromHex(0xE6131E, alpha: 1))
        alertview.setTextTheme(.light)
        alertview.addAction {
            self.handleBookingDetails(bookingId: booking_id, userId: self.userId)
        }

    }
    func callHandleBookingDetails() {
        if let id = currentBookingId {
            handleBookingDetails(bookingId: id, userId: userId)
        }
    }
    func handleBookingDetails(bookingId:String, userId:String) {
        DispatchQueue.main.async {
            UIAlertController.showModalSpinner(controller: self)
        }
        getBookingDetails(forUserWith: userId, withBookingId: bookingId) { (details) in
            guard let details = details else {
                print("Failed to unwrap booking details")
                let alertview = JSSAlertView().show(self,
                                                    title: "Error",
                                                    text: "Unable to get Booking Details. Please try again",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
                alertview.setTextTheme(.light)
                alertview.addAction {
                    self.callHandleBookingDetails()
                }
                return
            }
            let mapVC = MapViewController()
            mapVC.delegate = self
            //        mapVC.sourceCoordinates = self.sourceCoordinates
            //        mapVC.destinationCoordinates = self.destinationCoordinates
            //        mapVC.bookingDetails = details
            mapVC.modalPresentationStyle = .fullScreen
            self.currentBookingId = nil
            self.navigationController?.present(mapVC, animated: true, completion: {
                mapVC.bookingDetails = details
            })
        }
    }
    var isLoaded:Bool = false
    
    
    var menuItems:[MenuItem] = [
        MenuItem(image: #imageLiteral(resourceName: "home"), title: "HOME"),
        MenuItem(image: #imageLiteral(resourceName: "user_icon"), title: "PROFILE"),
        MenuItem(image: #imageLiteral(resourceName: "ride_history"), title: "RIDE HISTORY"),
//        MenuItem(image: #imageLiteral(resourceName: "payment"), title: "PAYMENT HISTORY"),
        MenuItem(image: #imageLiteral(resourceName: "payment"), title: "PAYMENT METHOD"),
        MenuItem(image: #imageLiteral(resourceName: "help"), title: "HELP & SUPPORT"),
        MenuItem(image: #imageLiteral(resourceName: "logout"), title: "LOG OUT")
    ]
    
    let locationManager = CLLocationManager()
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
                
                currentCoordinates = locationManager.location?.coordinate
                
            }
        }
        
    }
    var nearbyDrivers: [NearbyDriversCodable.Datum.Driver]? {
        didSet {
//            self.subView.collectionView.reloadData()
            self.setupDriversOnMapView()
            self.fallBackToIdentity(with: .Success)
        }
    }
    var userId:String {
        UserDefaults.standard.userID ?? ""
    }
    var currentCoordinates: CLLocationCoordinate2D? {
        didSet {
            
        }
    }
    var name:String?
    var profileImageURL:String?
    var isMenuShowing:Bool = false
    var items:[String] = ["Andreas Dress", "Some One", "No One", "Every One"]
    var subView = CustomerDashboardView()
    override func loadView() {
        super.loadView()
        view = subView
        view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromUserDefaults()
        subView.menuTableView.reloadData()
    }
    func loadDataFromUserDefaults() {
        name = UserDefaults.standard.userName ?? ""
        profileImageURL = Config.EndpointConfig.baseURL + "/" + (UserDefaults.standard.userProfileImageURL ?? "")
    }
    func centerMapOnLocation()
    {
        let target = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        subView.mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 17)
    }
    func setupMapView() {
        subView.mapView.delegate = self
        subView.mapView.settings.compassButton = true
        centerMapOnLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        subView.popupView.addGestureRecognizer(panRecognizer)
        setupCollectionView()
        setupMenuTableView()
        setupButtonActions()
        setupLocationManager()
        startSpinner()
        fetchNearbyDrivers()
        getCurrentBookings()
        UserDefaults.standard.isLoggedIn ? PushNotificationManager.shared.registerForPushNotifications() : ()
//        let button = UIButton(type: UIButton.ButtonType.system)
//        button.setTitle("Chat", for: UIControl.State.normal)
//        button.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(button)
//        button.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 24)
    }
    @objc func didTapChatButton() {
        let vc = ChatViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    
    func getCurrentBookings() {
        print("Getting customer userid => \(userId)")
        self.callGetCurrentBookingsSequence(userId: userId)
    }
    func getBookingDetails(forUserWith userId:String, withBookingId bookingId:String, completion: @escaping (_ details: CurrentBookings.Datum.Booking?) -> Void) {
        print("Getting customer userid => \(userId)")
        BookingsAPI.shared.getCurrentBookings(userId: userId) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                        self.fallBackToIdentity()
                        let alertView = JSSAlertView().show(self,
                                            title: "Error",
                                            text: error.localizedDescription,
                                            buttonText: "OK",
                                            color: UIColorFromHex(0xE6131E, alpha: 1))
                        alertView.setTextTheme(.light)
                        alertView.addAction {
                            completion(nil)
                        }
                        
                    }
                    
                }
                
            } else if let serviceError = serviceError {
                print("Oh No Service Error: \(serviceError.localizedDescription)")
                DispatchQueue.main.async {
                    UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                        self.fallBackToIdentity()
                        let alertView = JSSAlertView().show(self,
                                            title: "Error",
                                            text: serviceError.localizedDescription,
                                            buttonText: "OK",
                                            color: UIColorFromHex(0xE6131E, alpha: 1))
                        alertView.setTextTheme(.light)
                        alertView.addAction {
                            completion(nil)
                        }
                    }
                }
                
            } else if let data = data {
                
                let jsonString = String(data: data, encoding: .utf8)!
                print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CurrentBookings.self, from: data)
                    guard let status = result.status else {
                        print("MARK: Unable to get Result Status from API Call")
                        DispatchQueue.main.async {
                            self.fallBackToIdentity(with: .Error)
                            let alertView = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertView.setTextTheme(.light)
                            alertView.addAction {
                                completion(nil)
                            }
                        }
                        return
                    }
                    let message = result.message
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error:
                        print("Error: \(message ?? "Description: nil")")
                        
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity()
                                let alertView = JSSAlertView().show(self,
                                                    title: "Error",
                                                    text: message ?? "Unable to verify email. Please try again",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
                                alertView.setTextTheme(.light)
                                alertView.addAction {
                                    completion(nil)
                                }
                            }
                        }
                        
                        
                    case .Success:
                        print("Success")
                        print("\(message ?? "Success")")
                        
                        guard let bookings = result.data?.first?.bookings, !bookings.isEmpty else {
                            print("\n----------------------\n\n\t••••••••••••••• No bookings •••••••••••••••••••\n\n-----------------------")
                            return
                        }
//                        self.lastBookingDetails = lastBooking
                        
                        let details = bookings.filter({ $0.id == bookingId }).first
                        
                        DispatchQueue.main.async {
                            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                                self.fallBackToIdentity(with: .Success)
                                completion(details)
                            }
                        }
                        
                    case .none: print("Unknown Case")
                    DispatchQueue.main.async {
                        UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                            self.fallBackToIdentity()
                            let alertView = JSSAlertView().show(self,
                                                title: "Error",
                                                text: "Service Internal Error. Please contact support" ,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertView.setTextTheme(.light)
                            alertView.addAction {
                                completion(nil)
                            }
                        }
                        }
                    }
                } catch let err {
                    print("Unable to decode data")
                    print(err.localizedDescription)
                    DispatchQueue.main.async {
                        UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                            self.fallBackToIdentity()
                            let alertView = JSSAlertView().show(self,
                                                title: "Error",
                                                text: err.localizedDescription,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertView.setTextTheme(.light)
                            alertView.addAction {
                                completion(nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    func setupButtonActions() {
        self.subView.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        self.subView.overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOverlay)))
        self.subView.tryAgainButton.addTarget(self, action: #selector(handleTryAgainAction), for: UIControl.Event.touchUpInside)
        self.subView.settingsButton.addTarget(self, action: #selector(launchSettings), for: UIControl.Event.touchUpInside)
    }
    fileprivate func fetchNearbyDrivers() {
        if let coordinates = currentCoordinates {
            self.callFetchNearbyDriversSequence(userId: userId, coordinates: coordinates)
        }
    }
    
    @objc func launchSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                
            })
        }
    }
    fileprivate func startSpinner() {
        self.subView.spinner.startAnimating()
    }
    fileprivate func stopSpinner() {
        self.subView.spinner.stopAnimating()
    }
    @objc func handleTryAgainAction() {
        self.setPlaceholdersViewsState(isHidden: true)
        self.setViewsState(isHidden: true)
        self.startSpinner()
        self.fetchNearbyDrivers()
    }
    fileprivate func setPlaceholdersViewsState(isHidden:Bool) {
        self.subView.placeholderLabel.isHidden = isHidden
        self.subView.tryAgainButton.isHidden = isHidden
    }
    fileprivate func setViewsState(isHidden: Bool) {
        self.subView.collectionView.isHidden = isHidden
    }
    
    fileprivate func setupCollectionView() {
        subView.collectionView.delegate = self
        subView.collectionView.dataSource = self
//        if #available(iOS 13.0, *) {
//            subView.collectionView.automaticallyAdjustsScrollIndicatorInsets = false
//        } else {
//            // Fallback on earlier versions
//        }
//        subView.collectionView.contentInsetAdjustmentBehavior = .never
        subView.collectionView.register(DriverProfileCell.self, forCellWithReuseIdentifier: NSStringFromClass(DriverProfileCell.self))
    }
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
        self.setPlaceholdersViewsState(isHidden: true)
        self.setViewsState(isHidden: false)
//        subView.collectionView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.stopSpinner()
                self.subView.collectionView.reloadData()
                self.subView.collectionView.transform = CGAffineTransform.identity
//                self.subView.collectionView.reloadData()
                self.subView.collectionView.setNeedsLayout()
                self.subView.collectionView.layoutIfNeeded()
//                self.subView.collectionView.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    func setupMenuTableView() {
        subView.menuTableView.delegate = self
        subView.menuTableView.dataSource = self
        subView.menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MenuTableViewCell.self))
        subView.menuTableView.register(MenuTableViewHeaderCell.self, forCellReuseIdentifier: NSStringFromClass(MenuTableViewHeaderCell.self))
        subView.menuTableView.register(MenuTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(MenuTableViewFooterView.self))
    }
    @objc fileprivate func menuButtonTapped() {
        let menuTableViewWidth:CGFloat = self.subView.menuTableView.frame.width
        if isMenuShowing {
            isMenuShowing = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.subView.menuTableView.transform = CGAffineTransform(translationX: -menuTableViewWidth, y: 0)
                self.subView.overlay.alpha = 0
                self.subView.overlay.isHidden = true
            }, completion: nil)
        } else {
            isMenuShowing = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.subView.menuTableView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.subView.overlay.alpha = 1
                self.subView.overlay.isHidden = false
            }, completion: nil)
        }
    }
    @objc func didTapOverlay() {
        let menuTableViewWidth:CGFloat = self.subView.menuTableView.frame.width
        if isMenuShowing {
            isMenuShowing = false
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                self.subView.menuTableView.transform = CGAffineTransform(translationX: -menuTableViewWidth, y: 0)
                self.subView.overlay.alpha = 0
                self.subView.overlay.isHidden = true
            }, completion: nil)
        }
    }
    
}
extension CustomerDashboardVC: MapDelegate {
    func didCompletePayment() {
        print("I'm here at Dashboard")
//        navigationController?.popToViewController(self, animated: true)
        navigationController!.dismiss(animated: true, completion: nil)
//        self.view.window!.rootViewController!.dismiss(animated: true, completion: nil)
    }
}
extension CustomerDashboardVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        let heading = newHeading.trueHeading
        
        //        if isRouteSetToSource {8
        //            updateDriverLocationOnRoute(with: driverLocation, to: sourceCoordinates)
        //        }
        //        if isRouteSetToDestination {
        //            updateDriverLocationOnRoute(with: driverLocation, to: destinationCoordinates)
        //        }
        //        subView.mapView.animate(toBearing: newHeading.trueHeading)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
extension CustomerDashboardVC: GMSMapViewDelegate {
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("My Location Button Tapped")
        return true
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let driverId = marker.userData as? String else {return false}
        showDriverDetails(withDriverId: driverId)
        let update = GMSCameraUpdate.zoom(by: 2)
        subView.mapView.animate(with: update)
        return false
    }
    func showDriverDetails(withDriverId driverId:String) {
        self.animateTransitionIfNeeded(to: .open, duration: 0.6)
        guard let drivers = self.nearbyDrivers, let index = drivers.firstIndex(where: { $0.driverdetails?.id == driverId }) else {return}
        subView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
    }
}
extension CustomerDashboardVC: RideRequestedPassingDelegate {
    func rideRequested(with bookingDetails: BookingRequestResponseCodable.Datum.Booking) {
        navigationController?.popToViewController(self, animated: true)
        guard let sourceLatitude = bookingDetails.sourcelat,
            let sourceLongitude = bookingDetails.sourcelong,
            let destinationLatitude = bookingDetails.destlat,
            let destinationLongitude = bookingDetails.destlong else {
                print("Oh NO! Coordinates are not available to customer")
                return
        }
        let sourceCoordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourceLongitude)
        let destinationCoordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
        UserDefaults.saveSourceCoordinates(coordinates: sourceCoordinates)
        UserDefaults.saveDestinationCoordinates(coordinates: destinationCoordinates)
//        let alertview = JSSAlertView().show(self,
//                                            title: "Booking Requested",
//                                            text: "Waiting for the driver to respond",
//                                            buttonText: "OK",
//            color: UIColorFromHex(0xE6131E, alpha: 1))
//        alertview.setTextTheme(.light)
        
        let alert = UIAlertController.customAlertController(title: "Booking Requested", message: "Waiting for the driver to respond")
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        })
    }
}


extension CustomerDashboardVC: DriverProfileCellDelegate {
    func didTapHireButton(driverId:String) {
        print("Did Tap Hire Button")
        print("\n\n-----------\n\tDriver ID => \(driverId)\n\tCustomer Id => \(userId)\n-----------\n")
        let vc = SelectServicesVC(userId: userId, driverId: driverId)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
