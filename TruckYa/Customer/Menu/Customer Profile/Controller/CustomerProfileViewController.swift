//
//  CustomerProfileViewController.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class CustomerProfileViewController: UIViewController {
    var subView = CustomerProfileView()
    var customerDetails:CustomerProfile!
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
    fileprivate func setupTargetActions() {
        subView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        subView.editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        subView.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProgileImageView)))
    }
    @objc func didTapProgileImageView() {
        promptPhotosPickerMenu()
    }
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc func didTapEditButton() {
        print("Edit Button Tapped")
        let vc = EditCustomerProfileVC(details: customerDetails)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
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
            subView.profileImageURL = appData.profilepic
            subView.name = name
            subView.email = email
            subView.phoneNumber = phoneNumber
            subView.address = address
            subView.city = city
            subView.state = state
            subView.country = country
            subView.postalCode = postalCode
            customerDetails = CustomerProfile(name: name, email: email, phone: phoneNumber, address: address, city: city, state: state, country: country, zipCode: postalCode)
        }
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
