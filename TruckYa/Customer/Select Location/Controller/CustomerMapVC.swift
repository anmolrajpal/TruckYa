//
//  RiderDashboardVC.swift
//  TruckYa
//
//  Created by Anshul on 04/10/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
import SwiftyJSON
import GoogleMaps
import GooglePlaces

protocol RideRequestedProtocol {
    func rideRequested(with bookingDetails: BookingRequestResponseCodable.Datum.Booking)
}


extension Bool {
    func toString() -> String {
        return self ? "y" : "n"
    }
}
class CustomerMapVC: UIViewController {
    var delegate: RideRequestedProtocol?
    
    var requestResponse:BookingRequestResponseCodable.Datum.Booking! {
        didSet {
            
        }
    }
    
    
    
    
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoOverlay: UIView!
    @IBOutlet weak var infoViewBottom: NSLayoutConstraint!

    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pickUpTF: UITextField!
    @IBOutlet weak var dropUpTF: UITextField!
    
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var getPriceButton: UIButton!
    @IBOutlet weak var truckTypeButton: UIButton!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var backButtonImageView: UIImageView!
    var isInfoShowing = false
    
    
    var isStopAndDropServiceSelected:Bool!
    var isOneDriverServiceSelected:Bool!
    var isTwoDriversServiceSelected:Bool!
    var isTrailerHitchServiceSelected:Bool!
    var isDirtyJobsServiceSelected:Bool!
    var customerNotes:String!
    
    var stopAndDropServicePrice:Float!
    var oneDriverServicePrice:Float!
    var twoDriversServicePrice:Float!
    var trailerHitchServicePrice:Float!
    var dirtyJobsServicePrice:Float!
    
    
    var userId:String!
    var driverId:String!
    
    var isDriverViewExpanded = false
    var isLocationSet = false
    var isTripStarted = false
    let locationManger = CLLocationManager()
    var camera = GMSCameraPosition()
    var activity = ""
    var pickupLat = ""
    var pickupLong = ""
    var dropLat = ""
    var dropLong = ""
    var selectedRoute: NSDictionary!
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String!
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String!
    var sourceAddress:String!
    var destinationAddress:String!
    var sourceCoordinates:CLLocationCoordinate2D!
    var destinationCoordinates:CLLocationCoordinate2D!
    var pickMarker: GMSMarker?
    var dropMarker: GMSMarker?
    var cabMarker: GMSMarker?
    var routeFare = "0"
    var distanceInMiles:Double = 0
    var driverName = ""
    var driverLat = ""
    var driverLong = ""
    var driverBookingCode = ""
    var driverBookingId = ""{
        didSet{
            showDriverView()
//            var timer = Timer.scheduledTimer(timeInterval: 10.0,
//                                             target: self,
//                                             selector: #selector(getDriverLocation),
//                                             userInfo: nil,
//                                             repeats: true)
        }
    }
    var latLongs = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupNavData()
        getPriceButton.isEnabled = false
        initViews()
        setupMapView()
        setupLocationManager()
        showInitialPopupView()
    }
    func showInitialPopupView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let alertview = JSSAlertView().show(self,
                                                title: "Select Location",
                                                text: "Please select Source & Destination Location",
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
            alertview.setTextTheme(.light)
        }
    }
    func showDriverView(){
        if(driverLat != "" && driverLong != ""){
            cabMarker = GMSMarker()
            cabMarker?.icon = UIImage(named: "tuk-tuk-1")
            cabMarker?.position = CLLocationCoordinate2D(latitude: Double(dropLat)!, longitude: Double(dropLong)!)
            cabMarker?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            cabMarker?.map = mapView
        }
        //        let a = Measurement(value: 23.4, unit: UnitLength.miles)
        //        driverNameL.text = driverName
        //        stopRideB.isHidden = true
        //        driverViewBottomConstraint.constant = -250
        view.layoutIfNeeded()
    }
    func initViews(){
        
        backButtonImageView.image = backButtonImageView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        backButtonImageView.tintColor = .red
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        overlay.isHidden = true
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(CustomerMapVC.didTap))
//        overlay.addGestureRecognizer(recognizer)
        pickUpTF.attributedPlaceholder = NSAttributedString(string: "Enter Pickup Location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        dropUpTF.attributedPlaceholder = NSAttributedString(string: "Enter Dropoff Location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    
        //        tableView.delegate = self
        //        tableView.dataSource = self
        let bgView = UIView()
        bgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
   
    }
    
    func isDataValid() -> Bool {
        guard let source = pickUpTF.text, let destination = dropUpTF.text, !source.isEmpty, !destination.isEmpty else { return false }; return true
    }
    func validateFields() {
        if isDataValid() {
            getPriceButton.isEnabled = true
        } else {
            getPriceButton.isEnabled = false
        }
    }
    
 
    
    @IBAction func handlePickup(_ sender: Any) {
        activity = "pick"
        pickUpTF.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        acController.autocompleteFilter = filter
//        let searchBarTextAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.lightGray, NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: UIFont.systemFontSize)]
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes
        acController.tintColor = UIColor.darkGray
        acController.primaryTextColor = UIColor.systemGray
        acController.secondaryTextColor = UIColor.lightGray
        acController.tableCellSeparatorColor = UIColor.lightGray
        acController.tableCellBackgroundColor = UIColor.darkGray
        acController.primaryTextHighlightColor = UIColor.white
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func handleDropoff(_ sender: Any) {
        activity = "drop"
        dropUpTF.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        acController.autocompleteFilter = filter
        acController.tintColor = UIColor.darkGray
        acController.primaryTextColor = UIColor.systemGray
        acController.secondaryTextColor = UIColor.lightGray
        acController.tableCellSeparatorColor = UIColor.lightGray
        acController.tableCellBackgroundColor = UIColor.darkGray
        acController.primaryTextHighlightColor = UIColor.white
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    
    @IBAction func handleCurrentLocation(_ sender: Any) {
        getAddressFromLatLon { (address) in
            print(address)
            self.pickupLat = "\(AppDelegate.shared.lat)"
            self.pickupLong = "\(AppDelegate.shared.long)"
            self.pickUpTF.text = address
            self.sourceLabel.text = address
            self.sourceAddress = address
            if(self.pickupLat != "" && self.pickupLong != "" && self.dropLat != "" && self.dropLong != ""){
                self.getRoutes()
            }
        }
    }
    
    @IBAction func handleSwap(_ sender: Any) {
        let temp = pickUpTF.text
        pickUpTF.text = dropUpTF.text
        dropUpTF.text = temp
        if(self.pickupLat != "" && self.pickupLong != "" && self.dropLat != "" && self.dropLong != ""){
            let tP = pickupLat
            let tD = pickupLong
            pickupLat = dropLat
            pickupLong = dropLong
            dropLat = tP
            dropLong = tD
            getRoutes()
        }
    }
    
    
    
    
    func getRoutes() {
        if(pickupLat != "" && pickupLong != "" && dropLat != "" && dropLong != ""){
            self.mapView.clear()
            self.drawRoute(pickupLat: pickupLat, pickupLong: pickupLong, dropLat: dropLat, dropLong: dropLong)
            pickMarker = GMSMarker()
            pickMarker?.icon = GMSMarker.markerImage(with: UIColor.green)//UIImage(named: "tuk-tuk-1")
            let source_coordinates = CLLocationCoordinate2D(latitude: Double(pickupLat)!, longitude: Double(pickupLong)!)
            self.sourceCoordinates = source_coordinates
            pickMarker?.position = source_coordinates
            pickMarker?.map = mapView
            
            dropMarker = GMSMarker()
            dropMarker?.icon = GMSMarker.markerImage(with: UIColor.red)
            let destination_coordinates = CLLocationCoordinate2D(latitude: Double(dropLat)!, longitude: Double(dropLong)!)
            self.destinationCoordinates = destination_coordinates
            dropMarker?.position = destination_coordinates
            dropMarker?.map = mapView
            
        }
    }
    
    
    @objc func getDriverLocation(){
        //        let userid = UserDefaults.standard.string(forKey: "userid")
        //        if(userid != nil && userid != "" && driverBookingId != ""){
        //            let params = ["userid":userid!,
        //                          "bookingid":driverBookingId]
        //
        //            print(Endpoint.driverlocation)
        //            print(params)
        //            HTTPClient().post(urlString: Endpoint.driverlocation, params: params, token: nil) { [weak self](data, error) in
        //                if(error != nil){
        //                    print(error!.localizedDescription)
        //                    return
        //                }
        //                if(error == nil && data != nil){
        //                    let json = JSON(data!)
        //                    print(json)
        //                    let status = json["status"].stringValue
        //                    if(status == "error"){
        //                        //self?.showAlert(message: json["message"].stringValue)
        //                        return
        //                    }
        //                    json["data"].array?.forEach({ (subJson) in
        //                        self?.driverLat = subJson["lat"].stringValue
        //                        self?.driverLong = subJson["long"].stringValue
        //                    })
        //                    self?.updateDriverLocation()
        //                }
        //            }
        //        }
    }
    
    func updateDriverLocation(){
        let angle = bearing(to: cabMarker!.position, from: CLLocationCoordinate2D(latitude: Double(driverLat)!, longitude: Double(driverLong)!))
        print(angle)
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        cabMarker?.rotation = angle
        cabMarker?.position = CLLocationCoordinate2D(latitude: Double(driverLat)!, longitude: Double(driverLong)!)
        CATransaction.commit()
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
    
  
    
   
    func drawRoute(pickupLat: String, pickupLong: String, dropLat: String, dropLong: String){
        let origin = "\(pickupLat),\(pickupLong)"
        let destination = "\(dropLat),\(dropLong)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(Config.MapsConfig.GMS_API_KEY)"
        print("URL String => \(urlString)")
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
                        let routeOverviewPolyline:NSDictionary = (routes[0] as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                        let points = routeOverviewPolyline.object(forKey: "points")
                        self.calculateTotalDistanceAndDuration()
                        DispatchQueue.main.async {
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 5
                            polyline.strokeColor = .blue
                            polyline.map = self.mapView
                            let bounds = GMSCoordinateBounds(path: path!)
                            let update = GMSCameraUpdate.fit(bounds, withPadding: 30.0)
                            self.mapView.animate(with: update)
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
        
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            var estimated = ""
            if let distance:String = (leg.value(forKey: "distance") as! NSDictionary).value(forKey: "text") as? String,
                let distanceInKilometres:Double = Double(String(distance.split(separator: " ").first ?? "0")) {
                print("Distance in KM => \(distanceInKilometres)")
                let distanceKM = Measurement(value: distanceInKilometres, unit: UnitLength.kilometers)
                let distanceMiles = distanceKM.converted(to: UnitLength.miles)
                let miles = distanceKM.converted(to: UnitLength.miles).value
                print("Distance Miles => \(distanceMiles) & Miles => \(miles)")
                self.distanceInMiles = miles
                estimated = "Distance: \(miles.getString(withMaximumFractionDigits: 1) ?? "--") Miles"
            }
            
            if let duration = (leg.value(forKey: "duration") as! NSDictionary).value(forKey: "text"){
                estimated += "\nDuration: \(duration)"
                print(estimated)
                DispatchQueue.main.async {
                    self.dropMarker?.snippet = estimated
                    self.mapView.selectedMarker = self.dropMarker
                }
            }
            
            
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
        }
        
    }
    
    
    
    
    
    

    @IBAction func handleInfo(_ sender: Any) {
        validateFields()
        if !isDataValid() {
            let alertview = JSSAlertView().show(self,
                                                title: "Select Location",
                                                text: "Please select source and destination location first",
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1))
            alertview.setTextTheme(.light)
        } else {
            if(isInfoShowing){
                isInfoShowing = false
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
                    self.infoViewBottom.constant = -188
                    self.infoOverlay.isHidden = false
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }else{
                isInfoShowing = true
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
                    self.infoViewBottom.constant = 0
                    self.infoOverlay.isHidden = true
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    func getCombinedServicesPrice() -> Float {
        var totalPrice:Float = 0
        if self.isStopAndDropServiceSelected {
            totalPrice += self.stopAndDropServicePrice
        }
        if self.isOneDriverServiceSelected {
            totalPrice += self.oneDriverServicePrice
        }
        if self.isTwoDriversServiceSelected {
            totalPrice += self.twoDriversServicePrice
        }
        if self.isTrailerHitchServiceSelected {
            totalPrice += self.trailerHitchServicePrice
        }
        if self.isDirtyJobsServiceSelected {
            totalPrice += self.dirtyJobsServicePrice
        }
        return totalPrice
    }
    func getSelectedServicesCount() -> Int {
        var total:Int = 0
        if self.isStopAndDropServiceSelected {
            total += 1
        }
        if self.isOneDriverServiceSelected {
            total += 1
        }
        if self.isTwoDriversServiceSelected {
            total += 1
        }
        if self.isTrailerHitchServiceSelected {
            total += 1
        }
        if self.isDirtyJobsServiceSelected {
            total += 1
        }
        return total
    }
    @IBAction func getPriceTapped(_ sender: Any) {
        let vc = GetPriceVC()
        vc.delegate = self
        let combinedServicesPrice = getCombinedServicesPrice()
        let totalPrice = (4.5 * Float(distanceInMiles)) + combinedServicesPrice
        vc.configureView(totalPrice: totalPrice, totalDistance: distanceInMiles, servicesCount: getSelectedServicesCount(), combinedServicePrices: combinedServicesPrice)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    fileprivate func updateMapView(coordinates: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 18.0)
        mapView.camera = camera
    }
    func setupMapView() {
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        let marker = GMSMarker()
        marker.map = mapView
    }
    var locationManager = CLLocationManager()
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
    internal func handleSuccess() {
        AssertionModalController(title: "Requested").show(on: self) {
            self.delegate?.rideRequested(with: self.requestResponse)
//            self.navigationController?.popViewController(animated: false)
//            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
//            self.dismiss(animated: true) {
//            print(self.navigationController?.viewControllers as Any)
//                for vc in self.navigationController?.viewControllers ?? [] {
//                    if vc is CustomerDashboardVC {
//                        self.navigationController?.popToViewController(vc, animated: true)
//                    }
//                }
//            }
//            JSSAlertView().show(self,
//                    title: "• Waiting •",
//                    text: "Please wait for the driver to accept your request",
//                    buttonText: "OK",
//                    color: UIColorFromHex(0xE6131E, alpha: 1)).addAction {(
//
//                        self.dismiss(animated: true) {
//                            for vc in self.navigationController?.viewControllers ?? [] {
//                                if vc is CustomerDashboardVC {
//                                    self.navigationController?.popToViewController(vc, animated: true)
//                                }
//                            }
//                        }
//                )}
//            }
        }
    }
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
    }
    func initiateRequestBookingSequence() {
        self.callRequestBoookingSequence(userId: userId, driverId: driverId, sourceAddress: sourceAddress, sourceCoordinates: sourceCoordinates, destinationAddress: destinationAddress, destinationCoordinates: destinationCoordinates, stopAndDropServiceCheck: isStopAndDropServiceSelected, oneDriverServiceCheck: isOneDriverServiceSelected, twoDriversServiceCheck: isTwoDriversServiceSelected, trailerHitchServiceCheck: isTrailerHitchServiceSelected, dirtyJobsServiceCheck: isDirtyJobsServiceSelected, customerNotes: customerNotes)
    }
    
    
}
extension CustomerMapVC: RequestBookingDelegate {
    func hireButtonTapped() {
        print("Request Truck Tapped")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        DispatchQueue.main.async {
            UIAlertController.showModalSpinner(with: "Requesting...", controller: self)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            UIAlertController.dismissModalSpinner(animated: true, controller: self) {
//                self.fallBackToIdentity(with: .Success)
//                self.handleSuccess()
//            }
//        }
        self.initiateRequestBookingSequence()
    }
}
extension CustomerMapVC: GMSMapViewDelegate{
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("idleAt")
        print(position)
        if(!isLocationSet){
            if(AppDelegate.shared.lat != "" && AppDelegate.shared.long != ""){
                isLocationSet = true
                let camera = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: Double(AppDelegate.shared.lat)!, longitude: Double(AppDelegate.shared.long)!))
                mapView.animate(with: camera)
            }
        }else{
            AppDelegate.shared.lat = "\(position.target.latitude)"
            AppDelegate.shared.long = "\(position.target.longitude)"
            let camera = GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: Double(AppDelegate.shared.lat)!, longitude: Double(AppDelegate.shared.long)!))
            mapView.animate(with: camera)
        }
    }
}
extension CustomerMapVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if(activity == "pick"){
            let source:String = place.formattedAddress ?? ""
            pickUpTF.text = source
            sourceLabel.text = source
            sourceAddress = source
            pickupLat = "\(place.coordinate.latitude)"
            pickupLong = "\(place.coordinate.longitude)"
        }else if(activity == "drop"){
            let destination:String = place.formattedAddress ?? ""
            
            dropUpTF.text = place.formattedAddress
            destinationLabel.text = destination
            destinationAddress = destination
            dropLat = "\(place.coordinate.latitude)"
            dropLong = "\(place.coordinate.longitude)"
        }
        getRoutes()
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}




extension UIViewController{
    
    func getCurrentCity(completion :@escaping (_ city : String)-> Void) {
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.setupLocationManager()
        
        let geoCoder = CLGeocoder()
        let lat = Double(AppDelegate.shared.lat)
        let long = Double(AppDelegate.shared.long)
        if lat != nil && long != nil{
            let location = CLLocation(latitude: lat!, longitude: long!)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                placemarks?.forEach { (placemark) in
                    if let city = placemark.locality {
                        completion(city)
                        
                    }
                }
            })
        }else {
            openSettingForLocation()
        }
    }
    func getAddress(from coordinates:CLLocationCoordinate2D, completion :@escaping (_ address: String?) -> ()) {
        let location:CLLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil else {
                print("Error Reverse Geocoding")
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            if let placemarks = placemarks,
                !placemarks.isEmpty {
                var addressString = ""
                if let subLocality = placemarks.first?.subLocality {
                    addressString.append(subLocality + ", ")
                }
                if let throughFare = placemarks.first?.thoroughfare {
                    addressString.append(throughFare + ", ")
                }
                if let locality = placemarks.first?.locality {
                    addressString.append(locality + ", ")
                }
                if let country = placemarks.first?.country {
                    addressString.append(country + ", ")
                }
                if let postalCode = placemarks.first?.postalCode {
                    addressString.append(postalCode)
                }
                completion(addressString)
            }
            completion(nil)
        }
        if((AppDelegate.shared.lat != nil && AppDelegate.shared.lat != "") &&
            (AppDelegate.shared.long != nil && AppDelegate.shared.long != "")){
            var address = ""
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat = Double(AppDelegate.shared.lat)
            let long = Double(AppDelegate.shared.long)
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat!
            center.longitude = long!
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:{ (placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    address = addressString
                    completion(address)
                }
            })
        }else{
            return completion("Not found")
        }
    }
    func getAddressFromLatLon(completion :@escaping (_ city : String)-> Void) {
        
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.setupLocationManager()
        if((AppDelegate.shared.lat != nil && AppDelegate.shared.lat != "") &&
            (AppDelegate.shared.long != nil && AppDelegate.shared.long != "")){
            var address = ""
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat = Double(AppDelegate.shared.lat)
            let long = Double(AppDelegate.shared.long)
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat!
            center.longitude = long!
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:{ (placemarks, error) in
                if (error != nil){
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    address = addressString
                    completion(address)
                }
            })
        }else{
            return completion("Not found")
        }
    }
    
    func openSettingForLocation(){
        let constant = LocationHelper()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            constant.setupLocationManager()
        case .notDetermined:
            constant.locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .restricted, .denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "To get your current location, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}
extension CustomerMapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Driver Location Updated => \(String(describing: locations.last))")
        if let coordinates = locations.last?.coordinate {
            self.updateMapView(coordinates: coordinates)
            self.sendCurrentLocationToServer(with: coordinates)
            self.locationManager.stopUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
