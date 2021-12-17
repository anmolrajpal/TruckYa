//
//  RideHistoryCell.swift
//  TruckYa
//
//  Created by Anshul on 18/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import GoogleMaps
import Cosmos
class RideHistoryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
        contentView.backgroundColor = .white
        mapView.isUserInteractionEnabled = false
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var driverImageURL:String? {
        didSet {
                if let urlStr = driverImageURL {
                    let completeURL:String = Config.EndpointConfig.baseURL + "/" + urlStr
                    self.driverImageView.loadImageUsingCacheWithURLString(completeURL, placeHolder: #imageLiteral(resourceName: "driver"))
    //                UserDefaults.standard.userProfilePicURL = urlStr
                } else {
                    self.driverImageView.loadImageUsingCacheWithURLString(nil, placeHolder: #imageLiteral(resourceName: "driver"))
                }
            }
        }
    override func prepareForReuse() {
        super.prepareForReuse()
        driverImageView.image = nil
    }
    func configureCell(withDetails details:AllBookings.Datum.Booking) {
//        driverImageURL = nil
//        driverImageView.image = nil
//        driverImageURL = details.driver?.profilepic
        
        nameLabel.text = details.driver?.fullname?.capitalized
        if UserDefaults.standard.userType! == .Customer {
            priceLabel.text = "$ \(String(details.fare ?? 0)) (\(details.paymentdata?.paymentMethodDetails?.card?.brand ?? "")....\(details.paymentdata?.paymentMethodDetails?.card?.last4 ?? "****"))"
        } else {
            priceLabel.text = "$ \(String(details.fare ?? 0))"
        }
        
        sourceLabel.text = details.source
        destinationLabel.text = details.destination
        
        
        if let sourceLatitude = details.sourcelat, let sourceLongitude = details.sourcelong, let destinationLatitude = details.destlat, let destinationLongitude = details.destlong {
            let sourceCoordinates = CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourceLongitude)
            let destinationCoordinates = CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
            setupMarkers(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates)
            drawRoute(details:details, sourceCoodinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, strokeColor: .black)
        }
    }
    func setupMarkers(sourceCoordinates:CLLocationCoordinate2D, destinationCoordinates:CLLocationCoordinate2D) {
        let sourceMarker = GMSMarker(position: sourceCoordinates)
        sourceMarker.icon = GMSMarker.markerImage(with: UIColor.green)//UIImage(named: "tuk-tuk-1")
        sourceMarker.map = mapView
        
        let destinationMarker = GMSMarker(position: destinationCoordinates)
        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
        destinationMarker.map = mapView
    }
    func drawRoute(details:AllBookings.Datum.Booking, sourceCoodinates:CLLocationCoordinate2D, destinationCoordinates:CLLocationCoordinate2D, strokeColor:UIColor = .blue){
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
//                            self.selectedRoute = firstRoute
                            
                            guard let routeOverviewPolyline:NSDictionary = firstRoute.value(forKey: "overview_polyline") as? NSDictionary else {
                                print("Unable to get First Route overview polyline or map into NSDictionary")
                                return
                            }
                            guard let points = routeOverviewPolyline.object(forKey: "points") as? String else {
                                print("Unable to get Points from Route Overview Polyline or Map it into String")
                                return
                            }
                            
                            self.calculateTotalDistanceAndDuration(details: details, selectedRoute: firstRoute)
                            DispatchQueue.main.async {
                                guard let path = GMSPath.init(fromEncodedPath: points) else {
                                    print("Unable to initializer GMSPath or Failed to map into GMSPath")
                                    return
                                }
                                let polyline = GMSPolyline.init(path: path)
                                polyline.strokeWidth = 5
                                polyline.strokeColor = .blue
                                polyline.map = self.mapView
                                let bounds = GMSCoordinateBounds(path: path)
                                let update = GMSCameraUpdate.fit(bounds, withPadding: 30.0)
                                self.mapView.animate(with: update)
                                //                            self.subView.mapView.moveCamera(update)
                            }
                        }catch let error as NSError{
                            print("error:\(error)")
                        }
                    }
                }).resume()
            }
        }
    func calculateTotalDistanceAndDuration(details:AllBookings.Datum.Booking, selectedRoute: NSDictionary) {
            guard let legs = selectedRoute.value(forKey: "legs") as? Array<NSDictionary> else {
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
                var distanceInMiles = Double()
                if let distanceInKilometres:Double = Double(String(distance.split(separator: " ").first ?? "0")) {
                    let distanceKM = Measurement(value: distanceInKilometres, unit: UnitLength.kilometers)
                    let distanceMiles = distanceKM.converted(to: UnitLength.miles)
                    let miles = distanceMiles.value
                    distanceInMiles = miles
                    estimated = "Distance: \(miles.getString(withMaximumFractionDigits: 1) ?? "--") Miles"
                } else {
                    print("Unable to get Distance in specific units")
                }
                if let dateString = details.updatedTs, let date = Date.getDateFromString(dateString: dateString, dateFormat: .timestamp) {
                    let newDateString = Date.getStringFromDate(date: date, dateFormat: "dd MMM yyyy")
                    let newTimeString = Date.getStringFromDate(date: date, dateFormat: "HH:mm")
                    DispatchQueue.main.async {
                        self.bottomLabel.text = "\(newDateString) | \(distanceInMiles.getString(withMaximumFractionDigits: 1) ?? "--") Miles | \(newTimeString) hours"
                    }
                }
                estimated += "\nDuration: \(duration)"
    //            print(estimated)
                
                
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

}
