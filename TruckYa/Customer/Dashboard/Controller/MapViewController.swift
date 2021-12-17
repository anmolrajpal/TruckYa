//
//  MapViewController.swift
//  TruckYa
//
//  Created by Digit Bazar on 28/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import JSSAlertView


extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
protocol MapDelegate {
    func didCompletePayment()
}
class MapViewController:UIViewController, UIGestureRecognizerDelegate {
    var delegate:MapDelegate?
    func processDriverReachedToSourceNotification() {
        print("Processing Dirver Reached to Source Notification at customer side")
        subView.sliderView.isHidden = true
        subView.bookingCodeLabel.isHidden = false
        DispatchQueue.main.async {
            let alertView = JSSAlertView().show(self,
                                                title: "Driver has Reached to Source",
                                                text: "Please share the booking code with your truck driver" ,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
            alertView.setTextTheme(.light)
            alertView.addAction {
                if self.currentState == .closed {
                    self.animateTransitionIfNeeded(to: .open, duration: 0.6)
                }
            }
        }
    }
    func processDriverStartedJourneyNotification() {
        print("Processing Dirver Started Journey Notification at customer side")
        subView.sliderView.isHidden = true
        subView.bookingCodeLabel.isHidden = false
        DispatchQueue.main.async {
            let alertView = JSSAlertView().show(self,
                                                title: "Journey Started",
                                                text: "Your truck driver has begin the journey" ,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
            alertView.setTextTheme(.light)
            alertView.addAction {
                if self.currentState == .open {
                    self.animateTransitionIfNeeded(to: .closed, duration: 0.6)
                }
                self.handleDriverStartedJourneyEvent()
            }
        }
    }
    func processDriverCompletedJourneyNotification() {
        print("Processing Dirver Completed Journey Notification at customer side")
        subView.sliderView.isHidden = true
        subView.bookingCodeLabel.isHidden = true
        DispatchQueue.main.async {
            let alertView = JSSAlertView().show(self,
                                                title: "Journey Completed",
                                                text: "Your truck driver has reached the destination. Please make the payment" ,
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
            alertView.setTextTheme(.light)
            alertView.addAction {
                if self.currentState == .closed {
                    self.animateTransitionIfNeeded(to: .open, duration: 0.6)
                }
                self.handleDriverReachedDestinationEvent()
            }
        }
    }
    var driverReachedNotificationRecieved:Bool = false
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let sliderViewBounds = subView.popupView.bounds.contains(touch.location(in: subView.sliderView))
        let callButtonBounds = subView.popupView.bounds.contains(touch.location(in: subView.callButton))
        let chatButtonBounds = subView.popupView.bounds.contains(touch.location(in: subView.chatButton))
        if sliderViewBounds || callButtonBounds || chatButtonBounds { return false }
        return true
    }
    var subView = MapSubview()
    
    var isLocationSet = false
    var sourceMarker: GMSMarker?
    var destinationMarker: GMSMarker?
    var truckMarker = GMSMarker()
    var camera = GMSCameraPosition()
    var selectedRoute: NSDictionary!
    var distanceInMiles:Double = 0
    var latLongs = [CLLocationCoordinate2D]()
    var bookingCode:String! {
        didSet {
            subView.bookingCodeLabel.appendString(text: bookingCode, font: UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 22)!, textColor: .black)
        }
    }
    
    var userId:String! {
        UserDefaults.standard.userID
    }
    var initialLoad = false
    var bookingId:String!
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
    var initialDriverCoordinates: CLLocationCoordinate2D? {
        didSet {
            if let location = initialDriverCoordinates {
                self.truckMarker.position = location
            }
        }
    }
    internal var driverPhoneNumber:String? {
        didSet {
            subView.callButton.isEnabled = true
        }
    }
    var bookingDetails:CurrentBookings.Datum.Booking! {
        didSet {
            guard let details = bookingDetails else {
                print("Oh No! < CurrentBookings.Datum.Booking >  booking details are not available")
                return
            }
            
            setupInitialViews(with: details)
            self.fetchInitialDriverLocation(bookingId: bookingId)
        }
    }
    private func call(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    @objc func handleCallDriverEvent() {
        guard let number = driverPhoneNumber, !number.isEmpty else { return }
        call(phoneNumber: number)
    }
    @objc func handleChatWithDriverEvent() {
        let vc = ChatViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    func setupTargetActions() {
        subView.callButton.addTarget(self, action: #selector(handleCallDriverEvent), for: .touchUpInside)
        subView.chatButton.addTarget(self, action: #selector(handleChatWithDriverEvent), for: .touchUpInside)
    }
    //    var bookingDetails:AcceptBookingPayload! {
    //        didSet {
    //            guard let details = bookingDetails else {
    //                print("Oh No! booking details are not available")
    //                return
    //            }
    //            setupInitialViews(with: details)
    //            self.fetchInitialDriverLocation(bookingId: bookingId)
    //        }
    //    }
    //
    func setupInitialViews(with details: CurrentBookings.Datum.Booking) {
        self.initialLoad = true
        
        
        
        
        
        
        
        self.bookingId = details.id
        
        
        
        
        guard let status = details.status, !status.isEmpty else {
            print("Booking Status not found- Decodable\n Aborting Now")
            return
        }
        let bookingStatus = BookingStatus.getBookingStatus(from: status)
        print("\n----------------------- Booking Status ---------------------------\n\n\t•••••••••••••••••• \(bookingStatus) •••••••••••••••••\n\n----------------------------------------------------\n")
        
        
        
        
        
        if let latitude = details.driver?.lat, let longitude = details.driver?.longField {
            let driverLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.initialDriverCoordinates = driverLocation
        } else {
            print("Failed to unwrap Driver Coordinates")
        }
        
        if let latitude = details.sourcelat, let longitude = details.sourcelong {
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.sourceCoordinates = coordinates
        } else {
            print("Failed to unwrap source coordinates")
        }
        
        if let latitude = details.destlat, let longitude = details.destlong {
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.destinationCoordinates = coordinates
        } else {
            print("Failed to unwrap Destination Coordinates")
        }
        
        subView.truckTypeValueLabel.text = details.driver?.vehicle?.first?.vehicletype
        
        subView.truckImageURLString = details.driver?.vehicle?.first?.vehicleimage
        subView.numberPlateLabel.text = details.driver?.vehicle?.first?.vehicleplateno?.uppercased()
        
        subView.driverImageURLString = details.driver?.profilepic
        subView.nameLabel.text = details.driver?.fullname?.capitalized
        
        subView.sourceValueLabel.text = details.source
        subView.destinationValueLabel.text = details.destination
        
        driverPhoneNumber = details.driver?.mobileno
        
        
        
        guard let code = details.bookingcode, !code.isEmpty else {
            print("Error: Booking code not available in booking details")
            return
        }
        self.bookingCode = code
        
        self.isRouteSetToSource = true
        
        
//        let driver_coordinates = driverLocation.coordinate
        if let coordinates = initialDriverCoordinates {
            didUpdateRoute(from: coordinates, to: sourceCoordinates, with: .black)
        }
        
        
    }
    
    
    func fetchInitialDriverLocation(bookingId:String) {
        subView.mapView.clear()
        UIAlertController.showModalSpinner(with: "Locating Driver", controller: UIApplication.topViewController()!)
        setupMapView()
        getDriverLocation()
        Timer.scheduledTimer(timeInterval: 10.0,
                             target: self,
                             selector: #selector(getDriverLocation),
                             userInfo: nil,
                             repeats: true)
        
    }
    var locationManager = CLLocationManager()
    //        func processNotification(booking_id:String?, customerName:String?, sourceAddress:String?, destinationAddress:String?) {
    //            print("Processing Notification")
    //            if let id = booking_id {
    //                print("Booking ID => \(id)")
    //                self.bookingId = id
    //                subView.containerImageView.isHidden = false
    //                if currentState == .closed {
    //                    self.animateTransitionIfNeeded(to: .open, duration: 0.6)
    //                }
    //                subView.openTitleLabel.text = "1 New Request"
    //                subView.sourceValueLabel.text = sourceAddress
    //                subView.destinationValueLabel.text = destinationAddress
    //                let generator = UINotificationFeedbackGenerator()
    //                generator.notificationOccurred(.warning)
    //            }
    //        }
    override func loadView() {
        super.loadView()
        view = subView
        //        setupMapView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        //            if currentState == .open {
        //                print("Closing")
        //                animateTransitionIfNeeded(to: .closed, duration: 0.6)
        //            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupMapView()
        setupLocationManager()
        //            self.processNotification(booking_id: bookingIdFromPush, customerName: customerNameFromPush, sourceAddress: sourceAddressFromPush, destinationAddress: destinationAddressFromPush)
        handleEvents()
        subView.delegate = self
        subView.popupView.addGestureRecognizer(panRecognizer)
        setupTargetActions()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    fileprivate func handleEvents() {
        
    }
    
    func didReceiveDriverLocation(coordinates:CLLocationCoordinate2D) {
        if initialLoad {
            UIAlertController.dismissModalSpinner(controller: self)
            initialLoad = false
        }
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        driverLocation = location
//        updateDriverLocationOnMap(with: location)
        if isRouteSetToSource {
            didUpdateRoute(from: coordinates, to: sourceCoordinates, with: .black)
        }
        if isRouteSetToDestination {
            didUpdateRoute(from: coordinates, to: destinationCoordinates)
        }
    }
    @objc func getDriverLocation() {
        self.callGetDriverLocationSequence(userId: userId, bookingId: bookingId)
    }
    
    fileprivate func updateMapView(coordinates: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 18.0)
        subView.mapView.camera = camera
    }
    func setupMapView() {
        subView.mapView.delegate = self
        subView.mapView.settings.compassButton = true
        subView.mapView.isMyLocationEnabled = true
        setupTruckMarker()
        setupJourneyMapView()
        
    }
    func setupLocationManager() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.allowsBackgroundLocationUpdates = true
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                
            }
        }
        
    }
    
    func getRouteFromDriverToSource(sourceCoordinates:CLLocationCoordinate2D, destinationCoordinates: CLLocationCoordinate2D) {
        //        subView.mapView.clear()
//        drawRoute(sourceCoodinates: sourceCoordinates, destinationCoordinates: destinationCoordinates)
//        truckMarker?.position = sourceCoordinates
      
    }
    
    
    
    
    
    
    var driverLocation:CLLocation!
    
    
    
    func setupTruckMarker() {
        truckMarker.icon = #imageLiteral(resourceName: "truck_marker").withRenderingMode(.alwaysTemplate).maskWithColor(color: UIColor.red)
        truckMarker.setIconSize(scaledToSize: .init(width: 50, height: 50))
        truckMarker.title = "Driver"
        truckMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        truckMarker.isFlat = true
        truckMarker.tracksViewChanges = true
        truckMarker.map = subView.mapView
    }
    internal func handleDriverStartedJourneyEvent() {
//        AssertionModalController(title: "Trip Started").show(on: self) {
            self.animateTransitionIfNeeded(to: .closed, duration: 0.6)
            
            self.subView.sliderOption = .MakePayment
            self.subView.mapView.clear()
            self.isRouteSetToSource = false
            self.isRouteSetToDestination = true
            self.setupJourneyMapView()
            self.setupTruckMarker()
            self.updateDriverLocationOnMap(with: self.driverLocation)
            self.didUpdateRoute(from: self.driverLocation.coordinate, to: self.destinationCoordinates)
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
                self.didUpdateRoute(from: self.driverLocation.coordinate, to: self.destinationCoordinates)
                timer.invalidate()
            }
//        }
    }
    internal func handleDriverReachedDestinationEvent() {
//        AssertionModalController(title: "Trip Completed").show(on: self) {
            self.animateTransitionIfNeeded(to: .open, duration: 0.6)
            self.subView.sliderView.defaultLabelText = "Make Payment"
            self.subView.sliderView.isHidden = false
            self.panRecognizer.isEnabled = false
            self.subView.mapView.clear()
            self.isRouteSetToSource = false
            self.isRouteSetToDestination = false
            self.setupJourneyMapView()
            self.setupTruckMarker()
            self.updateDriverLocationOnMap(with: self.driverLocation)
            self.didUpdateRoute(from: self.sourceCoordinates, to: self.destinationCoordinates)
//        }
    }
    internal func handleDidMakePaymentSuccess() {
        AssertionModalController(title: "Done").show(on: self) {
            self.animateTransitionIfNeeded(to: .closed, duration: 0.6)
            self.subView.mapView.clear()
            self.isRouteSetToSource = false
            self.isRouteSetToDestination = false
            
            self.panRecognizer.isEnabled = true
            
        }
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
//        print("\n•••• Start Point Coordinates => \(startPointCoordinates) ••••\n•••• End Point Coordinates => \(endPointCoordinates) ••••\n")
        //        updateDriverLocationOnMap(with: startPointCoordinates)
        drawRoute(sourceCoodinates: startPointCoordinates, destinationCoordinates: endPointCoordinates, strokeColor: pathColor)
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func updateDriverLocationOnMap(with coordinates:CLLocationCoordinate2D){
//        let angle = bearing(to: truckMarker.position, from: coordinates)
//        print(angle)
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(1.0)
//        truckMarker.rotation = angle
//        truckMarker.position = coordinates
//        CATransaction.commit()
//    }
    
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
    
    func drawRoute(sourceCoodinates:CLLocationCoordinate2D, destinationCoordinates:CLLocationCoordinate2D, strokeColor:UIColor = .blue){
        let origin = "\(sourceCoodinates.latitude),\(sourceCoodinates.longitude)"
        let destination = "\(destinationCoordinates.latitude),\(destinationCoordinates.longitude)"
//        print("\n\n---- Drawing Route from Origin Coordinates =>\n\t•••••• \(origin) •••••• \nto Destination Coordinates => \n\n\t••••••• \(destination) ••••••••")
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Config.MapsConfig.GMS_API_KEY)"
        DispatchQueue.main.async {
            guard let url = URL(string: urlString) else {
                print("Failed to create url with urlString: \(urlString)")
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    do{
                        guard let data = data else {
                            print("Unable to decode data")
                            return
                        }
//                        let jsonString = String(data: data, encoding: .utf8)!
//                        print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                        guard let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String : AnyObject] else {
                            print("Failed to decode data as [String:Any]")
                            return
                        }
                        guard let routes = json["routes"] as? NSArray else {
                            print("Unable to get routes from JSON Response or Unable to map response into NSArray")
                            return
                        }
                        guard let firstRoute = routes.firstObject as? NSDictionary else {
                            print("Unable to get first route object or unable to map into NSDictionary")
                            return
                        }
                        self.selectedRoute = firstRoute
                        
                        guard let routeOverviewPolyline:NSDictionary = firstRoute.value(forKey: "overview_polyline") as? NSDictionary else {
                            print("Unable to get First Route overview polyline or map into NSDictionary")
                            return
                        }
                        guard let points = routeOverviewPolyline.object(forKey: "points") as? String else {
                            print("Unable to get Points from Route Overview Polyline or Map it into String")
                            return
                        }
                        
                        self.calculateTotalDistanceAndDuration()
                        DispatchQueue.main.async {
                            guard let path = GMSPath.init(fromEncodedPath: points) else {
                                print("Unable to initializer GMSPath or Failed to map into GMSPath")
                                return
                            }
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 5
                            polyline.strokeColor = .blue
                            polyline.map = self.subView.mapView
                            let bounds = GMSCoordinateBounds(path: path)
                            let update = GMSCameraUpdate.fit(bounds, withPadding: 30.0)
                            self.subView.mapView.animate(with: update)
                            //                            self.subView.mapView.moveCamera(update)
                        }
                    }catch let error as NSError{
                        print("error:\(error)")
                    }
                }
            }).resume()
        }
    }
    func calculateTotalDistanceAndDuration() {
        guard let legs = self.selectedRoute.value(forKey: "legs") as? Array<NSDictionary> else {
            print("Failed to unwrap key - legs from selected route")
            return
        }
        
        for leg in legs {
            var estimated = ""
            guard let distanceKey = leg.value(forKey: "distance") as? NSDictionary else {
                print("Failed to get key - distance from leg or Map into NSDictionary")
                return
            }
            guard let durationKey = leg.value(forKey: "duration") as? NSDictionary else {
                print("Failed to get key - duration from leg or Map into NSDictionary")
                return
            }
            guard let distance = distanceKey.value(forKey: "text") as? String else {
                print("Failed to unwrap key - text from distance object")
                return
            }
            guard let duration = durationKey.value(forKey: "text") as? String else {
                print("Failed to unwrap key - text from distance object")
                return
            }
            if let distanceInKilometres:Double = Double(String(distance.split(separator: " ").first ?? "0")) {
                let distanceKM = Measurement(value: distanceInKilometres, unit: UnitLength.kilometers)
                let distanceMiles = distanceKM.converted(to: UnitLength.miles)
                let miles = distanceMiles.value
                self.distanceInMiles = miles
                estimated = "Distance: \(miles.getString(withMaximumFractionDigits: 1) ?? "--") Miles"
            } else {
                print("Unable to get Distance in specific units")
            }
            estimated += "\nDuration: \(duration)"
//            print(estimated)
            DispatchQueue.main.async {
                self.sourceMarker?.snippet = estimated
                self.subView.mapView.selectedMarker = self.sourceMarker
            }
            
            
            /*
             let steps = leg.value(forKey: "steps") as! Array<NSDictionary>
             for step in steps{
             let location = step.value(forKey: "start_location") as! NSDictionary
             let lat = location.value(forKey: "lat") as! Double
             let long = location.value(forKey: "lng") as! Double
             let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
             self.latLongs.append(position)
             }
             
             let endLocation = leg.value(forKey: "end_location") as? NSDictionary
             let lat = endLocation!.value(forKey: "lat") as! Double
             let long = endLocation!.value(forKey: "lng") as! Double
             let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
             self.latLongs.append(position)
             self.latLongs.forEach { (location) in
             print(location)
             }
             */
        }
        
    }
    
    func sendCurrentLocationToServer(with coordinates:CLLocationCoordinate2D) {
        //        LocationAPI.shared.updateCurrentLocation(userId: userId, coordinates: coordinates) { (data, serviceError, error) in
        //            if let error = error {
        //                print("Oh no Error: \(error.localizedDescription)")
        //            } else if let serviceError = serviceError {
        //                print("Oh No Service Error: \(serviceError.localizedDescription)")
        //            } else if let data = data {
        //                do {
        //                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
        //                    guard let status = result["status"] as? String else {
        //                        print("MARK: Unable to get Result Status from API Call")
        //                        return
        //                    }
        //                    let message = result["message"] as? String
        //                    let resultStatus = APIResultStatus(rawValue: status)
        //                    switch resultStatus {
        //                    case .Error: print("Error: \(message ?? "Description: nil")")
        //                    case .Success: print("\(message ?? "Driver Location Updated Successfully")")
        //                    case .none: print("Unknown Case")
        //                    }
        //
        //                } catch let err {
        //                    print("Err: \(err.localizedDescription)")
        //                }
        //            }
        //        }
    }
    
    func handleSlideToCancelEvent() {
        DispatchQueue.main.async {
            let alertview = JSSAlertView().show(self,
                                                title: "Cancel Ride?",
                                                text: "Are you sure you want to cancel the ride?",
                                                buttonText: "Yes",
                                                cancelButtonText: "No",
                                                color: UIColorFromHex(0xE6131E, alpha: 1),
                                                iconImage: nil)
            alertview.setTextTheme(.light)
            alertview.addAction({
                print("Cancelling Ride")
            })
        }
        
        
    }
    
    
    
    
    
    
    
    
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    internal var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        recognizer.delegate = self
        return recognizer
    }()
    //    lazy var panRecognizer: UIPanGestureRecognizer = {
    //        let recognizer = UIPanGestureRecognizer()
    //        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
    //        recognizer.delegate = self
    //
    //        return recognizer
    //
    //    }()
    /// Animates the transition, if the animation is not already running.
    internal func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.subView.bottomConstraint.constant = 0
                self.subView.overlayView.alpha = 0.5
                //                    self.subView.closedTitleLabel.transform = CGAffineTransform(scaleX: 1.6, y: 1.6).concatenating(CGAffineTransform(translationX: 0, y: 15))
            //                    self.subView.openTitleLabel.transform = .identity
            case .closed:
                self.subView.bottomConstraint.constant = self.subView.popupOffset
                self.subView.overlayView.alpha = 0
                //                    self.subView.closedTitleLabel.transform = .identity
                //                    self.subView.openTitleLabel.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
            }
            self.subView.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.subView.bottomConstraint.constant = 0
            case .closed:
                self.subView.bottomConstraint.constant = self.subView.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.subView.truckTypeTitleLabel.alpha = 1
            case .closed:
                self.subView.truckTypeValueLabel.alpha = 0.8
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.subView.truckTypeTitleLabel.alpha = 1
            case .closed:
                self.subView.truckTypeValueLabel.alpha = 0.8
            }
        })
        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
        
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 0.6)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: subView.popupView)
            var fraction = -translation.y / subView.popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: subView.popupView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
    }
    
    func handleSlideActions(with option: CustomerSliderOption)  {
        switch option {
        case .CancelRide:
            print("Customer Cancels Ride")
            handleSlideToCancelEvent()
        case .MakePayment:
            print("Customer should Make Payment")
            handleSlideToMakePaymentEvent()
        }
    }
    
    func handleSlideToMakePaymentEvent() {
//        DispatchQueue.main.async {
//            UIAlertController.showModalSpinner(controller: self)
//        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        if let amount = bookingDetails.fare {
            vc.amount = amount
            vc.bookingId = bookingId
        }
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.sender = "MapViewController"
        self.present(vc, animated: true, completion: nil)
    }
}
extension MapViewController: PaymentDelegate {
    func didCompletePayment() {
        print("Going back to Dashboard")
        self.delegate?.didCompletePayment()
//        navigationController?.dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
}
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Customer Location Updated => \(String(describing: locations.last))")
//        if let coordinates = locations.last?.coordinate {
//            self.updateMapView(coordinates: coordinates)
//            self.sendCurrentLocationToServer(with: coordinates)
//            self.locationManager.stopUpdatingLocation()
//        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
extension MapViewController: GMSMapViewDelegate {
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
        print(position)
//        if(!isLocationSet){
//            if(AppDelegate.shared.lat != "" && AppDelegate.shared.long != ""){
//                isLocationSet = true
//                let camera = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: Double(AppDelegate.shared.lat)!, longitude: Double(AppDelegate.shared.long)!))
//                mapView.animate(with: camera)
//            }
//        }else{
//            AppDelegate.shared.lat = "\(position.target.latitude)"
//            AppDelegate.shared.long = "\(position.target.longitude)"
//            let camera = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: Double(AppDelegate.shared.lat)!, longitude: Double(AppDelegate.shared.long)!))
//            mapView.animate(with: camera)
//        }
    }
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
extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
extension MapViewController: CustomerSliderViewDelegate {
    func didSlide(with option: CustomerSliderOption) {
        handleSlideActions(with: option)
    }
}
