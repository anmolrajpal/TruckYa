//
//  DriverProfileViewController.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class DriverProfileViewController: UIViewController {
    var subView = DriverProfileView()
    var driverDetails:DriverProfile!
    override func loadView() {
        super.loadView()
        view = subView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromUserDefaults()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargetActions()
        setupProgressAlertController()
        ProfilePictureAPI.shared.delegate = self
    }
    func loadDataFromUserDefaults() {
        if let appData = AppData.userDetails {
            let name = appData.fullname ?? ""
            let email = appData.email ?? ""
            let phoneNumber = appData.mobileno ?? ""
            let address = appData.address ?? ""
            let city = appData.city ?? ""
            let state = appData.state ?? ""
            let country = appData.country ?? ""
            let postalCode = appData.zipcode ?? ""
            let driverDescription = appData.about ?? ""
            subView.profileImageURL = appData.profilepic
            subView.name = name
            subView.email = email
            subView.phoneNumber = phoneNumber
            subView.address = address
            subView.city = city
            subView.state = state
            subView.country = country
            subView.postalCode = postalCode
            subView.driverDescription = driverDescription
            driverDetails = DriverProfile(name: name, email: email, phone: phoneNumber, address: address, city: city, state: state, country: country, zipCode: postalCode, description: driverDescription)
        }
    }
    fileprivate func setupTargetActions() {
        subView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        subView.editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        subView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProgileImageView)))
        subView.truckDetailsButton.addTarget(self, action: #selector(didTapTruckDetailsButton), for: .touchUpInside)
        subView.licenseDetailsButton.addTarget(self, action: #selector(didTapLicenseDetailsButton), for: .touchUpInside)
        subView.insuranceDetailsButton.addTarget(self, action: #selector(didTapInsuranceDetailsButton), for: .touchUpInside)
    }
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc func didTapProgileImageView() {
        promptPhotosPickerMenu()
    }
    @objc func didTapEditButton() {
        print("Edit Button Tapped")
        let vc = EditDriverProfileViewController(details: driverDetails)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    @objc func didTapTruckDetailsButton() {
        print("Truck Button Tapped")
        let vc = DriverSignupVCForm3()
        vc.shouldHideBackButton = false
        vc.shouldHidePageCountLabel = true
        vc.shouldPop = true
        if let details = AppData.userDetails?.vehicle?.first {
            vc.truckInfo = details
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapLicenseDetailsButton() {
        print("License Button Tapped")
        let vc = DriverSignupVCForm4()
        vc.shouldHideBackButton = false
        vc.shouldHidePageCountLabel = true
        vc.shouldPop = true
        if let details = AppData.userDetails?.license?.first {
            vc.licenseInfo = details
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapInsuranceDetailsButton() {
        print("Insurance Button Tapped")
        let vc = DriverSignupVCForm5()
        vc.shouldHideBackButton = false
        vc.shouldHidePageCountLabel = true
        vc.shouldPop = true
        if let details = AppData.userDetails?.insurance?.first {
            vc.insuranceInfo = details
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    var scaledProfileImage:UIImage!
    let alertVC = UIAlertController.customAlertController(title: "Uploading...")
    let progressTitleLabel:UILabel = {
        let label = UILabel()
        let margin:CGFloat = 8.0
        let alertVCWidth:CGFloat = 270.0
        let frame = CGRect(x: margin, y: 50.0, width: alertVCWidth - margin * 2.0 , height: 20)
        label.frame = frame
        label.textAlignment = .center
        label.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 14)
        label.text = "0 %"
        return label
    }()
    let progressBar:UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        let margin:CGFloat = 8.0
        let alertVCWidth:CGFloat = 270.0
        let frame = CGRect(x: margin, y: 80.0, width: alertVCWidth - margin * 2.0 , height: 2.0)
        view.frame = frame
        view.progressTintColor = UIColor.rgb(r: 92, g: 189, b: 236)
        view.setProgress(0, animated: false)
        return view
    }()
}
