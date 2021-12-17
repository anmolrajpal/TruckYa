//
//  DriverDashboardVC.swift
//  TruckYa
//
//  Created by Anmol Rajpal on 13/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import GoogleMaps
import JSSAlertView
extension DriverDashboardVC: RequestPopupDelegate {
    func declineRequestButtonTapped() {
        print("Decline Button Tapped")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        DispatchQueue.main.async {
            UIAlertController.showModalSpinner(controller: self)
        }
        initiateDeclineBookingSequence()
    }
    
    func acceptRequestButtonTapped() {
        print("Accept Button Tapped")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        DispatchQueue.main.async {
            UIAlertController.showModalSpinner(with: "Accepting...", controller: self)
        }
        initiateAcceptBookingSequence()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
//                self.fallBackToIdentity(with: .Success)
//                self.handleSuccess()
//            }
//        }
//        self.initiateRequestBookingSequence()
    }
}

class DriverDashboardVC: UIViewController, UIGestureRecognizerDelegate {
    var isLoaded:Bool = false
    var initialLoad = false
    
    var driverCoordinates:CLLocationCoordinate2D? {
        didSet {
            guard let coordinates = driverCoordinates else { return }
            truckMarker.position = coordinates
        }
    }
    var bookingDetails:AcceptBookingResponseCodable.Datum.Booking! {
        didSet {
            guard let details = bookingDetails else {
                return
            }
            print(details)
            let source_coordinates = CLLocationCoordinate2D(latitude: details.sourcelat ?? 50, longitude: details.sourcelong ?? 60)
            let destination_coordinates = CLLocationCoordinate2D(latitude: details.destlat ?? 60, longitude: details.destlong ?? 70)
            self.sourceCoordinates = source_coordinates
            self.destinationCoordinates = destination_coordinates
            self.setupJourneyMapView()
            self.isRouteSetToSource = true
            if let driver_coordinates = driverCoordinates {
                didUpdateRoute(from: driver_coordinates, to: sourceCoordinates, with: .black)
            }
            self.animateTransitionIfNeeded(to: .closed, duration: 0.3)
            self.subView.metaPopupOffset = 300
            self.subView.sliderView.isHidden = false
            //            self.subView.popupView.isHidden = true
            //            self.subView.metaPopupView.isHidden = false
            
            self.metaAnimateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.panRecognizer.isEnabled = false
            
            self.initialLoad = true
            self.subView.customerNameLabel.text = self.customerNameFromPush
            self.subView.addressSourceValueLabel.text = details.source
            self.subView.addressDestinationValueLabel.text = details.destination
            //            self.fetchInitialDriverLocation(bookingId: bookingId)
        }
    }
    
    
    func handleAcceptBooking() {
        
    }
    
    
    
    var bookingId:String?
    var bookingIdFromPush:String? {
        UserDefaults.standard.driverPushBoookingID
    }
    var customerNameFromPush:String? {
        UserDefaults.standard.driverPushCustomerName
    }
    var destinationAddressFromPush:String? {
        UserDefaults.standard.driverPushDestinationAddress
    }
    var sourceAddressFromPush:String? {
        UserDefaults.standard.driverPushSourceAddress
    }
    var customerName:String?
    var sourceAddress:String?
    var destinationAddress:String?
    var menuItems:[MenuItem] = [
        MenuItem(image: #imageLiteral(resourceName: "home"), title: "HOME"),
        MenuItem(image: #imageLiteral(resourceName: "user_icon"), title: "PROFILE"),
        MenuItem(image: #imageLiteral(resourceName: "setting"), title: "MANAGE SERVICES"),
        MenuItem(image: #imageLiteral(resourceName: "ride_history"), title: "RIDE HISTORY"),
//        MenuItem(image: #imageLiteral(resourceName: "payment"), title: "PAYMENT METHODS"),
        MenuItem(image: #imageLiteral(resourceName: "help"), title: "HELP / SUPPORT"),
        MenuItem(image: #imageLiteral(resourceName: "logout"), title: "LOG OUT")
    ]
    var userId:String {
        UserDefaults.standard.userID ?? ""
    }
    var name:String?
    var profileImageURL:String?
    
    var isMenuShowing:Bool = false
    var items:[String] = ["Andreas Dress", "Some One", "No One", "Every One"]
    var subView = DriverDashboardView()
    var locationManager = CLLocationManager()
    
    var isLocationSet = false
    var sourceMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    var truckMarker = GMSMarker()
    var camera = GMSCameraPosition()
    var selectedRoute: NSDictionary!
    var distanceInMiles:Double = 0
    var latLongs = [CLLocationCoordinate2D]()
    var sourceCoordinates:CLLocationCoordinate2D! {
        didSet {
            sourceMarker?.position = sourceCoordinates
        }
    }
    var destinationCoordinates:CLLocationCoordinate2D! {
        didSet {
            destinationMarker?.position = destinationCoordinates
        }
    }
    var startTime:Date?
    
    
    
    
    
    //MARK: Meta Animations
    
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    internal var metaCurrentState: State = .closed
    
    /// All of the currently running animators.
    internal var metaRunningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    internal var metaAnimationProgress = [CGFloat]()
    
    internal lazy var metaPanRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(metaPopupViewPanned(recognizer:)))
        recognizer.delegate = self
        return recognizer
    }()
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    internal var currentState: State = .closed
    
    /// All of the currently running animators.
    internal var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    internal var animationProgress = [CGFloat]()
    
    internal lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    
    
    
    func setupTruckMarker() {
        truckMarker.icon = #imageLiteral(resourceName: "truck_marker").withRenderingMode(.alwaysTemplate).maskWithColor(color: UIColor.red)
        truckMarker.setIconSize(scaledToSize: .init(width: 50, height: 50))
        truckMarker.title = "Driver"
        truckMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        truckMarker.isFlat = true
        truckMarker.tracksViewChanges = true
        truckMarker.map = subView.mapView
    }
    func centerMapOnLocation()
    {
        let target = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        subView.mapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 17)
    }
    func setupInitialMapView() {
        subView.mapView.delegate = self
        subView.mapView.settings.compassButton = true
        centerMapOnLocation()
        setupTruckMarker() 
    }
    func processPaymentDoneNotification() {
        print("Processing Payment Done Notification at driver side")
        subView.sliderView.isHidden = true
        DispatchQueue.main.async {
            let alertView = JSSAlertView().show(self,
                                                title: "Payment Done",
                                                text: "Payment has been done by the customer" ,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
            alertView.setTextTheme(.light)
            alertView.addAction {
                
            }
        }
    }
    
    func processNotification(booking_id:String?, customerName:String?, sourceAddress:String?, destinationAddress:String?) {
        print("Processing Notification")
        if let id = booking_id {
            print("Booking ID => \(id)")
            self.bookingId = id
            subView.containerImageView.isHidden = false
            let vc = RequestPopupVC()
            vc.delegate = self
            
            vc.subView.sourceValueLabel.text = sourceAddress
            vc.subView.destinationValueLabel.text = destinationAddress
//            vc.configureView(totalPricePerMile: totalPricePerMile, totalPrice: totalPrice, totalDistance: distanceInMiles, servicesCount: getSelectedServicesCount())
            vc.modalPresentationStyle = .overCurrentContext
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.present(vc, animated: false, completion: nil)
            }
            
//            if currentState == .closed {
//                self.animateTransitionIfNeeded(to: .open, duration: 0.6)
//            }
            subView.openTitleLabel.text = "1 New Request"
            subView.sourceValueLabel.text = sourceAddress
            subView.destinationValueLabel.text = destinationAddress
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
    override func loadView() {
        super.loadView()
        view = subView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromUserDefaults()
        subView.menuTableView.reloadData()
        observeViewNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeViewNotificationsObservers()
    }
    fileprivate func observeViewNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    fileprivate func removeViewNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    @objc private func handleEnterForeground() {
        if currentState == .open {
            print("Closing")
            animateTransitionIfNeeded(to: .closed, duration: 0.6)
        }
        if metaCurrentState == .open {
            print("Closing Meta")
            metaAnimateTransitionIfNeeded(to: .closed, duration: 0.6)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupMapView()
//        subView.mapView.delegate = self
//        subView.mapView.settings.compassButton = true
        setupInitialMapView()
        setupMenuTableView()
        //        setupRequestsTableView()
        setupLocationManager()
//        setupInitialMapView()
        isLoaded = true
        subView.delegate = self
        subView.containerImageView.isHidden = true
        subView.popupView.addGestureRecognizer(panRecognizer)
        subView.containerImageView.isUserInteractionEnabled = true
        //        panRecognizer.isEnabled = false
        subView.metaPopupView.addGestureRecognizer(metaPanRecognizer)
        print("Booking ID here => \(String(describing: bookingId))")
        self.processNotification(booking_id: bookingIdFromPush, customerName: customerNameFromPush, sourceAddress: sourceAddressFromPush, destinationAddress: destinationAddressFromPush)
        self.bookingId = nil
        handleEvents()
        UserDefaults.standard.isLoggedIn ? PushNotificationManager.shared.registerForPushNotifications() : ()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setupInitialMapView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setupInitialMapView()
        //        print("Booking ID here => \(String(describing: bookingId))")
        //        self.processNotification(booking_id: bookingId, customerName: customerName, sourceAddress: sourceAddress, destinationAddress: destinationAddress)
        //        self.bookingId = nil
    }
    fileprivate func handleEvents() {
        self.subView.menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        self.subView.overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOverlay)))
        self.subView.acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        self.subView.declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
    }
    @objc func acceptButtonTapped() {
        print("Accept Button Tapped")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIAlertController.showModalSpinner(controller: self)
        initiateAcceptBookingSequence()
    }
    @objc func declineButtonTapped() {
        print("Decline Button Tapped")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIAlertController.showModalSpinner(controller: self)
        initiateDeclineBookingSequence()
    }
    fileprivate func initiateAcceptBookingSequence() {
        if let bookingId = bookingIdFromPush {
            self.acceptBooking(userId: userId, bookingId: bookingId)
        }
    }
    fileprivate func initiateDeclineBookingSequence() {
        if let bookingId = bookingIdFromPush {
            self.declineBooking(userId: userId, bookingId: bookingId)
        }
    }
    internal func handleSuccess() {
        AssertionModalController(title: "Success").show(on: self) {
            //            self.animateTransitionIfNeeded(to: .closed, duration: 0.6)
        }
    }
    internal func handleDeclineSuccess() {
        AssertionModalController(title: "Cancelled").show(on: self) {
            self.animateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.fallbackRequestViewToIdentity()
            UserDefaults.standard.driverPushBoookingID = nil
            UserDefaults.standard.driverPushCustomerName = nil
            UserDefaults.standard.driverPushSourceAddress = nil
            UserDefaults.standard.driverPushDestinationAddress = nil
        }
    }
    internal func handleDriverReachedSuccess() {
        AssertionModalController(title: "Success").show(on: self) {
            self.metaAnimateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.fallbackRequestViewToIdentity()
            self.subView.sliderView.defaultLabelText = "Start the Trip"
            self.subView.sliderOption = .StartJourney
        }
    }
    internal func handleDriverStartJourneySuccess() {
        AssertionModalController(title: "Trip Started").show(on: self) {
            self.metaAnimateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.subView.sliderView.defaultLabelText = "Reached Destination"
            self.subView.sliderOption = .ReachedDestination
            self.subView.mapView.clear()
            self.isRouteSetToSource = false
            self.isRouteSetToDestination = true
            self.setupJourneyMapView()
            self.setupTruckMarker()
            self.updateDriverLocationOnMap(with: self.driverLocation)
            self.didUpdateRoute(from: self.driverLocation.coordinate, to: self.destinationCoordinates)
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
                self.updateDriverLocationOnRoute(with: self.driverLocation, to: self.destinationCoordinates)
                timer.invalidate()
            }
        }
    }
    internal func handleDriverReachedDestinationSuccess() {
        AssertionModalController(title: "Trip Completed").show(on: self) {
            self.metaAnimateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.subView.sliderView.defaultLabelText = "Reached to Source"
            self.subView.sliderOption = .ReachedSource
            self.subView.mapView.clear()
            self.isRouteSetToSource = false
            self.isRouteSetToDestination = false
//            self.setupJourneyMapView()
            self.setupTruckMarker()
            self.updateDriverLocationOnMap(with: self.driverLocation)
//            self.didUpdateRoute(from: self.sourceCoordinates, to: self.destinationCoordinates)
            self.subView.metaPopupOffset = 400
            self.metaAnimateTransitionIfNeeded(to: .closed, duration: 0.3)
            self.panRecognizer.isEnabled = true
        }
    }
    internal func handleDriverReceivedPaymentSuccess() {
//        AssertionModalController(title: "Payment Received").show(on: self) {
            self.animateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.subView.sliderView.defaultLabelText = "Reached to Source"
            self.subView.sliderOption = .ReachedSource
            self.subView.mapView.clear()
            self.isRouteSetToSource = false
            self.isRouteSetToDestination = false
            self.setupTruckMarker()
            self.updateDriverLocationOnMap(with: self.driverLocation)
            
            self.subView.metaPopupOffset = 400
            self.metaAnimateTransitionIfNeeded(to: .closed, duration: 0.3)
            self.panRecognizer.isEnabled = true
            
//            self.metaAnimateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.metaPanRecognizer.isEnabled = false
//        }
    }
    func fallbackRequestViewToIdentity() {
        subView.openTitleLabel.text = "No New Requests"
        subView.containerImageView.isHidden = true
    }
    fileprivate func updateMapView(coordinates: CLLocationCoordinate2D) {
        truckMarker.position = coordinates
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 18.0)
        subView.mapView.animate(to: camera)
    }
    func setupJourneyMapView() {
        
        sourceMarker = GMSMarker(position: sourceCoordinates)
        sourceMarker?.icon = GMSMarker.markerImage(with: UIColor.green)//UIImage(named: "tuk-tuk-1")
        sourceMarker?.title = "Source"
        sourceMarker?.map = subView.mapView
        
        destinationMarker = GMSMarker(position: destinationCoordinates)
        destinationMarker?.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker?.title = "Destination"
        destinationMarker?.map = subView.mapView
        
    }
    var isRouteSetToSource = false
    var isRouteSetToDestination = false
    func didUpdateRoute(from startPointCoordinates: CLLocationCoordinate2D, to endPointCoordinates:CLLocationCoordinate2D, with pathColor:UIColor = .blue) {
        //        getRouteFromDriverToSource(sourceCoordinates: startPointCoordinates, destinationCoordinates: endPointCoordinates)
        print("\n•••• Start Point Coordinates => \(startPointCoordinates) ••••\n•••• End Point Coordinates => \(endPointCoordinates) ••••\n")
        //        updateDriverLocationOnMap(with: startPointCoordinates)
        drawRoute(sourceCoodinates: startPointCoordinates, destinationCoordinates: endPointCoordinates, strokeColor: pathColor)
        
    }
    func getRouteFromDriverToSource(sourceCoordinates:CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D) {
        //        subView.mapView.clear()
        //            drawRoute(sourceCoodinates: sourceCoordinates, destinationCoordinates: destinationCoordinates)
        //            truckMarker.position = sourceCoordinates
    }
    func updateDriverLocationOnMap(with location:CLLocation){
        let coordinates = location.coordinate
        truckMarker.position = coordinates
        let bearing = getBearingBetweenTwoPoints(point1: coordinates, point2: coordinates)
        let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 17, bearing: bearing, viewingAngle: 0)
//        let cameraPosition = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 18.0)
        let cameraUpdate = GMSCameraUpdate.setCamera(camera)
        subView.mapView.animate(with: cameraUpdate)
//        subView.mapView.animate(to: cameraPosition)
        
        //            let angle = bearing(to: truckMarker.position, from: coordinates)
        //            print("Angle => \(angle)")
//        let rotationAngle = location.course
//        print("Rotation Angle => \(rotationAngle)")
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(0.6)
//        truckMarker.rotation = rotationAngle
//        truckMarker.position = coordinates
//        CATransaction.commit()
    }
    func updateDriverLocationOnRoute(with location:CLLocation, to endPointCoordinates:CLLocationCoordinate2D){
        let coordinates = location.coordinate
        truckMarker.position = coordinates
        let bearing = getBearingBetweenTwoPoints(point1: coordinates, point2: endPointCoordinates)
        let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 25, bearing: bearing, viewingAngle: 45)
        //            let cameraPosition = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 18.0)
        //            subView.mapView.animate(to: cameraPosition)
        let cameraUpdate = GMSCameraUpdate.setCamera(camera)
        subView.mapView.animate(with: cameraUpdate)
        //            let angle = bearing(to: truckMarker.position, from: coordinates)
        //            print("Angle => \(angle)")
        //            let rotationAngle = location.course
        //            print("Rotation Angle => \(rotationAngle)")
        //            CATransaction.begin()
        //            CATransaction.setAnimationDuration(0.6)
        //            truckMarker.rotation = rotationAngle
        //            truckMarker.position = coordinates
        //            CATransaction.commit()
    }
    func bearing(to pointOne: CLLocationCoordinate2D, from pointTwo: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
        var bearing: CLLocationDirection
        
        let fromLat = degreesToRadians(pointOne.latitude)
        let fromLon = degreesToRadians(pointOne.longitude)
        let toLat = degreesToRadians(pointTwo.latitude)
        let toLon = degreesToRadians(pointTwo.longitude)
        
        let y = sin(toLon - fromLon) * cos(toLat)
        let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLon - fromLon)
        bearing = radiansToDegrees( atan2(y, x) ) as CLLocationDirection
        
        bearing = (bearing + 360.0).truncatingRemainder(dividingBy: 360.0  )
        return bearing
    }
    
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints(point1 : CLLocationCoordinate2D, point2 : CLLocationCoordinate2D) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.latitude)
        let lon1 = degreesToRadians(degrees: point1.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.latitude)
        let lon2 = degreesToRadians(degrees: point2.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    func drawRoute(sourceCoodinates:CLLocationCoordinate2D, destinationCoordinates:CLLocationCoordinate2D, strokeColor:UIColor = .blue){
        let origin = "\(sourceCoodinates.latitude),\(sourceCoodinates.longitude)"
        let destination = "\(destinationCoordinates.latitude),\(destinationCoordinates.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Config.MapsConfig.GMS_API_KEY)"
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                        let routes = json["routes"] as! NSArray
                        self.selectedRoute = routes[0] as? NSDictionary
                        let routeOverviewPolyline:NSDictionary = (routes.firstObject as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                        let points = routeOverviewPolyline.object(forKey: "points")
                        self.calculateTotalDistanceAndDuration()
                        DispatchQueue.main.async {
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 5
                            polyline.strokeColor = strokeColor
                            polyline.map = self.subView.mapView
                            let bounds = GMSCoordinateBounds(path: path!)
                            let update = GMSCameraUpdate.fit(bounds, withPadding: 30.0)
                            self.subView.mapView.animate(with: update)
                        }
                    }catch let error as NSError{
                        print("error:\(error)")
                    }
                }
            }).resume()
        }
    }
    func calculateTotalDistanceAndDuration() {
        let legs = self.selectedRoute.value(forKey: "legs") as! Array<NSDictionary>
        
        for leg in legs {
            var estimated = ""
            if let distance:String = (leg.value(forKey: "distance") as! NSDictionary).value(forKey: "text") as? String,
                let distanceInKilometres:Double = Double(String(distance.split(separator: " ").first ?? "0")) {
                let distanceKM = Measurement(value: distanceInKilometres, unit: UnitLength.kilometers)
                let distanceMiles = distanceKM.converted(to: UnitLength.miles)
                let miles = distanceMiles.value
                self.distanceInMiles = miles
                estimated = "Distance: \(miles.getString(withMaximumFractionDigits: 1) ?? "--") Miles"
            }
            
            if let duration = (leg.value(forKey: "duration") as! NSDictionary).value(forKey: "text"){
                estimated += "\nDuration: \(duration)"
                print(estimated)
                DispatchQueue.main.async {
                    self.sourceMarker?.snippet = estimated
                    self.subView.mapView.selectedMarker = self.sourceMarker
                }
            }
        }
        
    }
    
    var driverLocation:CLLocation!
    
    func setupLocationManager() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.allowsBackgroundLocationUpdates = true
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                
            }
        }
        
    }
    
    
    
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
    }
    
    
    func sendCurrentLocationToServer(with coordinates:CLLocationCoordinate2D) {
        LocationAPI.shared.updateCurrentLocation(userId: userId, coordinates: coordinates) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
            } else if let serviceError = serviceError {
                print("Oh No Service Error: \(serviceError.localizedDescription)")
            } else if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    guard let status = result["status"] as? String else {
                        print("MARK: Unable to get Result Status from API Call")
                        return
                    }
                    let message = result["message"] as? String
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error: print("Error: \(message ?? "Description: nil")")
                    case .Success: print("\(message ?? "Driver Location Updated Successfully")")
                    case .none: print("Unknown Case")
                    }
                    
                } catch let err {
                    print("Err: \(err.localizedDescription)")
                }
            }
        }
    }
    func loadDataFromUserDefaults() {
        name = UserDefaults.standard.userName ?? ""
        profileImageURL = Config.EndpointConfig.baseURL + "/" + (UserDefaults.standard.userProfileImageURL ?? "")
    }
    
    func setupMenuTableView() {
        subView.menuTableView.delegate = self
        subView.menuTableView.dataSource = self
        subView.menuTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MenuTableViewCell.self))
        subView.menuTableView.register(MenuTableViewHeaderCell.self, forCellReuseIdentifier: NSStringFromClass(MenuTableViewHeaderCell.self))
        subView.menuTableView.register(MenuTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(MenuTableViewFooterView.self))
    }
    func setupRequestsTableView() {
        subView.requestsTableView.delegate = self
        subView.requestsTableView.dataSource = self
        subView.requestsTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MenuTableViewCell.self))
    }
    
    
    @objc fileprivate func menuButtonTapped() {
        subView.menuTableView.isHidden = false
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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == panRecognizer {
            if subView.popupView.bounds.contains(touch.location(in: subView.acceptButton)) {
                return false
            }
            return true
        } else {
            let sliderViewBounds = subView.metaPopupView.bounds.contains(touch.location(in: subView.sliderView))
            let callButtonBounds = subView.metaPopupView.bounds.contains(touch.location(in: subView.callButton))
            let chatButtonBounds = subView.metaPopupView.bounds.contains(touch.location(in: subView.chatButton))
            if sliderViewBounds || callButtonBounds || chatButtonBounds {
                return false
            }
            return true
        }
        
    }
    func handleSlideActions(with option: SliderOption)  {
        switch option {
        case .ReachedSource:
            print("Driver Reached To Source")
            handleDriverReachedToSourceEvent()
        case .StartJourney:
            print("Driver Started Journey")
            driverDidSlideToStartJourney()
        case .ReachedDestination:
            print("Driver Reached Destination")
            driverDidSlideToStopJourney()
        }
    }
    func handleDriverReachedToSourceEvent() {
        if let id = bookingIdFromPush {
            DispatchQueue.main.async {
                UIAlertController.showModalSpinner(controller: self)
            }
            self.driverReachedToSource(userId: userId, bookingId: id)
        }
    }
    func driverDidSlideToReceivePayment() {
        DispatchQueue.main.async {
            UIAlertController.showModalSpinner(controller: self)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4, execute: {
            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
                self.fallBackToIdentity(with: .Success)
                self.handleDriverReceivedPaymentSuccess()
            }
        })
    }
    func driverDidSlideToStartJourney() {
        showInputBookingCodeDialogBox()
        //        let vc = InputBookingCodeVC()
        //        vc.delegate = self
        //        vc.modalPresentationStyle = .overCurrentContext
        //        present(vc, animated: false, completion: nil)
    }
    func driverDidSlideToStopJourney() {
        if let id = bookingIdFromPush {
            DispatchQueue.main.async {
                UIAlertController.showModalSpinner(controller: self)
            }
            self.stopJourney(userId: userId, bookingId: id)
        }
    }
    func handleDriverStartedJourneyEvent(with bookingCode: String) {
        if let id = bookingIdFromPush {
            DispatchQueue.main.async {
                UIAlertController.showModalSpinner(controller: self)
            }
            self.startJourney(userId: userId, bookingId: id, bookingCode: bookingCode)
        }
    }
    
    
    
    fileprivate func showInputBookingCodeDialogBox() {
        let alertVC = UIAlertController(title: "", message: "\n", preferredStyle: UIAlertController.Style.alert)
        let attributedString = NSAttributedString(string: "ENTER BOOKING CODE", attributes: [
            NSAttributedString.Key.font : UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 16)!, //your font here
            NSAttributedString.Key.foregroundColor : UIColor.white
        ])
        alertVC.setValue(attributedString, forKey: "attributedTitle")
        alertVC.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.darkGray
        
        alertVC.view.tintColor = UIColor.systemBlue
        alertVC.view.subviews.first?.subviews.first?.backgroundColor = .clear
        alertVC.view.subviews.first?.backgroundColor = .clear
        alertVC.addTextField { (textField) in
            textField.placeholder = "Booking Code"
            textField.clearButtonMode = .whileEditing
            textField.borderStyle = .roundedRect
            //            textField.layer.borderColor = UIColor.telaGray5.cgColor
            //            textField.layer.borderWidth = 1
            //            textField.layer.cornerRadius = 5
            //            textField.clipsToBounds = true
            textField.keyboardType = UIKeyboardType.numberPad
            textField.keyboardAppearance = UIKeyboardAppearance.dark
            
            textField.returnKeyType = UIReturnKeyType.done
            
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        }
        
        
        //        alertVC.textFields?[0].tintColor = .yellow
        let cancelAction = UIAlertAction(title: "CANCEL", style: .destructive, handler: { (_) in })
        let doneAction = UIAlertAction(title: "DONE", style: UIAlertAction.Style.default) { (action) in
            let booking_code = alertVC.textFields?.first?.text
            print("Booking Code => \(booking_code ?? "nil")")
            if let code = booking_code,
                !code.isEmpty, code.count == 6 {
                alertVC.dismiss(animated: true) {
                    self.handleDriverStartedJourneyEvent(with: code)
                }
            } else { fatalError("Unable to get Booking Code from TextField ")}
        }
        doneAction.isEnabled = false
        alertVC.addAction(cancelAction)
        alertVC.addAction(doneAction)
        self.present(alertVC, animated: true, completion: nil)
        alertVC.textFields?[0].superview?.backgroundColor = .gray
    }
    @objc func alertTextFieldDidChange(textField: UITextField!) {
        let alertController = self.presentedViewController as? UIAlertController
        if let ac = alertController {
            let doneAction = ac.actions.last
            let textField = ac.textFields?.first
            if let booking_code = textField?.text, !booking_code.isEmpty, booking_code.count == 6 {
                doneAction?.isEnabled = true
            } else {
                doneAction?.isEnabled = false
            }
        }
    }
}
extension DriverDashboardVC: InputBookingCodeDelegate {
    func doneButtonTapped(with bookingCode: String) {
        handleDriverStartedJourneyEvent(with: bookingCode)
    }
}
extension DriverDashboardVC: SliderViewDelegate {
    func didSlide(with option: SliderOption) {
        handleSlideActions(with: option)
    }
}





extension DriverDashboardVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.trueHeading
        truckMarker.rotation = heading
        //        if isRouteSetToSource {8
        //            updateDriverLocationOnRoute(with: driverLocation, to: sourceCoordinates)
        //        }
        //        if isRouteSetToDestination {
        //            updateDriverLocationOnRoute(with: driverLocation, to: destinationCoordinates)
        //        }
        //        subView.mapView.animate(toBearing: newHeading.trueHeading)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let lastLocation = locations.last else { return }
        let coordinates = lastLocation.coordinate
        driverLocation = lastLocation
        driverCoordinates = coordinates
//        updateDriverLocationOnMap(with: lastLocation)
        //        self.didUpdateCurrentLocation(with: coordinates)
        //        self.updateMapView(coordinates: coordinates)
        updateDriverLocationOnMap(with: lastLocation)
        if isRouteSetToSource {
            didUpdateRoute(from: coordinates, to: sourceCoordinates, with: .black)
            updateDriverLocationOnRoute(with: lastLocation, to: sourceCoordinates)
        }
        if isRouteSetToDestination {
            didUpdateRoute(from: coordinates, to: destinationCoordinates)
            updateDriverLocationOnRoute(with: lastLocation, to: destinationCoordinates)
        }
        self.sendCurrentLocationToServer(with: coordinates)
        self.locationManager.stopUpdatingLocation()
        
        /*
         let time = lastLocation.timestamp
         //print(time)
         guard let startTime = startTime else {
         self.startTime = time // Saving time of first location, so we could use it to compare later with second location time.
         return //Returning from this function, as at this moment we don't have second location.
         }
         let elapsed = time.timeIntervalSince(startTime) // Calculating time interval between first and second (previously saved) locations timestamps.
         //print(elapsed)
         if elapsed > 15 { //If time interval is more than 30 seconds
         sendCurrentLocationToServer(with: coordinates) //user function which uploads user location or coordinate to server.
         
         self.startTime = time //Changing our timestamp of previous location to timestamp of location we already uploaded.
         }
         */
        
        
        //        print("Driver Location Updated => \(String(describing: locations.last))")
        //        if let coordinates = locations.last?.coordinate {
//                            self.updateMapView(coordinates: coordinates)
        //            self.sendCurrentLocationToServer(with: coordinates)
        //            self.locationManager.stopUpdatingLocation()
        //        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
extension DriverDashboardVC: GMSMapViewDelegate {
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("My Location Button Tapped")
        return true
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("I should zoom")
        let update = GMSCameraUpdate.zoom(by: 2)
        subView.mapView.animate(with: update)
        return false
    }
}
