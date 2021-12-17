//
//  RideHistoryVC.swift
//  TruckYa
//
//  Created by Anshul on 18/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView


class RideHistoryVC: UIViewController {
    var cachedImages = [String: UIImage]()
    var allBookings:[AllBookings.Datum.Booking] = [] {
        didSet {
            self.viewSpinner.stopAnimating()
            HapticFeedbackGenerator.generateFeedback(ofType: .Success)
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    let viewSpinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        aiView.backgroundColor = .white
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.darkGray
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initViews()
        callFetchMyBookingsSequence(userId: UserDefaults.standard.userID!)
    }
    
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = .white
        view.addSubview(viewSpinner)
        viewSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        viewSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
        viewSpinner.startAnimating()
        HapticFeedbackGenerator.generateFeedback(ofType: .Rigid)
    }
    
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func downloadImage(imageName:String, indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let urlString = Config.EndpointConfig.baseURL + "/" + imageName
            if let url = URLSession.shared.constructURL(from: urlString) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let downloadedImage = UIImage(data: data) {
                                completion(downloadedImage)
                            } else {
                                print("Failed to unwrap downloaded image data")
                                completion(nil)
                            }
                        } else {
                            print("Failed to unwrap image data")
                            completion(nil)
                        }
                        
                    }
                }).resume()
            }
        }
    }
}

extension RideHistoryVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBookings.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideHistoryCell", for: indexPath) as! RideHistoryCell
        cell.selectionStyle = .none
        let details = self.allBookings[indexPath.row]
        cell.configureCell(withDetails: details)
        if let imageName = details.driver?.profilepic {
            if let image = cachedImages[imageName] {
                cell.driverImageView.image = image
                cell.layoutIfNeeded()
            }
            else {
                downloadImage(imageName: imageName, indexPath: indexPath) { (image) in
                    if let image = image {
                        self.cachedImages[imageName] = image
                        cell.driverImageView.image = image
                        cell.layoutIfNeeded()
                    }
                }
            }
        }
        
        return cell
    }
}



extension RideHistoryVC {
    internal func callFetchMyBookingsSequence(userId:String) {
        BookingsAPI.shared.getMyBookings(userId: userId) { (data, serviceError, error) in
            if let error = error {
                print("Oh no Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.viewSpinner.stopAnimating()
                    let alertview = JSSAlertView().show(self,
                                                        title: "Error",
                                                        text: error.localizedDescription,
                                                        buttonText: "OK",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
                    alertview.setTextTheme(.light)
                }
                
            } else if let serviceError = serviceError {
                print("Oh No Service Error: \(serviceError.localizedDescription)")
                DispatchQueue.main.async {
                    self.viewSpinner.stopAnimating()
                    let alertview = JSSAlertView().show(self,
                                                        title: "Error",
                                                        text: serviceError.localizedDescription,
                                                        buttonText: "OK",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1))
                    alertview.setTextTheme(.light)
                }
                
            } else if let data = data {
                let jsonString = String(data: data, encoding: .utf8)!
                print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(AllBookings.self, from: data)
                    //                    self.signInResult = result
                    guard let status = result.status else {
                        print("MARK: Unable to get Result Status from API Call")
                        DispatchQueue.main.async {
                            self.viewSpinner.stopAnimating()
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: "Service Error. Please try again in a while",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
                        }
                        return
                    }
                    let message = result.message
                    let resultStatus = APIResultStatus(rawValue: status)
                    switch resultStatus {
                    case .Error:
                        print("Error: \(message ?? "Description: nil")")
                        DispatchQueue.main.async {
                            self.viewSpinner.stopAnimating()
                            let alertview = JSSAlertView().show(self,
                                                                title: "Error",
                                                                text: message ?? "Unable to verify email. Please try again",
                                                                buttonText: "OK",
                                                                color: UIColorFromHex(0xE6131E, alpha: 1))
                            alertview.setTextTheme(.light)
                        }
                    case .Success:
                     print("Success")
                     print("\(message ?? "Upload Success")")
//                     let jsonString = String(data: data, encoding: .utf8)!
//                     print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
                     if let bookingsData = result.data,
                         !bookingsData.isEmpty,
                        let bookings = bookingsData.first?.bookings {
                        self.allBookings = bookings
                     } else {
                         print("No Bookings Found")
                         DispatchQueue.main.async {
                            self.viewSpinner.stopAnimating()
                             let alertview = JSSAlertView().show(self,
                                                                 title: "Error",
                                                                 text: "No Bookings Found",
                                                                 buttonText: "OK",
                                                                 color: UIColorFromHex(0xE6131E, alpha: 1))
                             alertview.setTextTheme(.light)
                         }
                     }
                    case .none: print("Unknown Case")
                    DispatchQueue.main.async {
                        self.viewSpinner.stopAnimating()
                        let alertview = JSSAlertView().show(self,
                                                            title: "Error",
                                                            text: "Service Internal Error. Please contact support",
                                                            buttonText: "OK",
                                                            color: UIColorFromHex(0xE6131E, alpha: 1))
                        alertview.setTextTheme(.light)
                        }
                    }
                } catch let err {
                    print("Unable to decode data")
                    DispatchQueue.main.async {
                        self.viewSpinner.stopAnimating()
                        let alertview = JSSAlertView().show(self,
                                                            title: "Error",
                                                            text: err.localizedDescription,
                                                            buttonText: "OK",
                                                            color: UIColorFromHex(0xE6131E, alpha: 1))
                        alertview.setTextTheme(.light)
                    }
                }
            }
        }
    }
}
