//
//  SelectServicesVC.swift
//  TruckYa
//
//  Created by Digit Bazar on 08/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
protocol RideRequestedPassingDelegate {
    func rideRequested(with bookingDetails: BookingRequestResponseCodable.Datum.Booking)
}
class SelectServicesVC:UIViewController {
    var delegate: RideRequestedPassingDelegate?
    var subView = SelectServicesView()
    var isStopAndDropServiceSelected:Bool {
        self.subView.stopAndDropCheckBox.isChecked
    }
    var isOneDriverServiceSelected:Bool {
        self.subView.oneDriverCheckBox.isChecked
    }
    var isTwoDriversServiceSelected:Bool {
        self.subView.twoDriversCheckBox.isChecked
    }
    var isTrailerHitchServiceSelected:Bool {
        self.subView.trailerCheckBox.isChecked
    }
    var isDirtyJobsServiceSelected:Bool {
        self.subView.haulingCheckBox.isChecked
    }
    var customerNotes:String {
        self.subView.commentsTextView.text
    }
    
    
    
    
    var userId:String!
    var driverId:String!
    var stopAndDropServicePrice:Float?
    var oneDriverServicePrice:Float?
    var twoDriversServicePrice:Float?
    var trailerHitchServicePrice:Float?
    var dirtyJobsServicePrice:Float?
    
    
    
    init(userId:String, driverId:String) {
        super.init(nibName: nil, bundle: nil)
        self.userId = userId
        self.driverId = driverId
        self.callFetchServicePricesSequence(userId: userId, driverId: driverId)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func loadView() {
        super.loadView()
//        view = subView
        hideSubviews(withAnimation: false)
        view = subView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subView.viewSpinner.startAnimating()
//        setupViews()
        hideKeyboardWhenTappedAround()
        setupCommentsTextView()
        setupButtonActions()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupHireButtonLayout()
    }
    
    func showSubviews(withAnimation mark:Bool) {
        mark ?
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.7, animations: { self.showSubiews() })
            }
            : showSubiews()
    }
    func hideSubviews(withAnimation mark:Bool) {
        mark ?
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.7, animations: { self.hideSubiews() })
            }
            : hideSubiews()
    }
    func showSubiews() {
        self.subView.optionOneLabel.alpha = 1.0
        self.subView.stopAndDropCheckBox.alpha = 1.0
        self.subView.optionTwoLabel.alpha = 1.0
        self.subView.oneDriverCheckBox.alpha = 1.0
        self.subView.optionThreeLabel.alpha = 1.0
        self.subView.twoDriversCheckBox.alpha = 1.0
        self.subView.optionFourLabel.alpha = 1.0
        self.subView.trailerCheckBox.alpha = 1.0
        self.subView.optionFiveLabel.alpha = 1.0
        self.subView.optionFivePriceLabel.alpha = 1.0
        self.subView.haulingCheckBox.alpha = 1.0
        self.subView.notesLabel.alpha = 1.0
        self.subView.commentsTextView.alpha = 1.0
        self.subView.hireButton.alpha = 0.4
    }
    func hideSubiews() {
        self.subView.optionOneLabel.alpha = 0
        self.subView.stopAndDropCheckBox.alpha = 0
        self.subView.optionTwoLabel.alpha = 0
        self.subView.oneDriverCheckBox.alpha = 0
        self.subView.optionThreeLabel.alpha = 0
        self.subView.twoDriversCheckBox.alpha = 0
        self.subView.optionFourLabel.alpha = 0
        self.subView.trailerCheckBox.alpha = 0
        self.subView.optionFiveLabel.alpha = 0
        self.subView.optionFivePriceLabel.alpha = 0
        self.subView.haulingCheckBox.alpha = 0
        self.subView.notesLabel.alpha = 0
        self.subView.commentsTextView.alpha = 0
        self.subView.hireButton.alpha = 0
    }
    fileprivate func fetchServicePrices() {
        
    }
    
    var services: ServicesCodable.Datum.Userservice? {
        didSet {
            guard let services = services else {
                return
            }
            setupPriceData(from: services)
        }
    }
    func setupPriceData(from serviceDetails: ServicesCodable.Datum.Userservice) {
        subView.configureView(with: serviceDetails)
        
        if let stopAndDropServicePrice = serviceDetails.stopanddrop {
            self.stopAndDropServicePrice = stopAndDropServicePrice
        }
        if let oneDriverServicePrice = serviceDetails.onedriverhelpsupload {
            self.oneDriverServicePrice = oneDriverServicePrice
        }
        if let twoDriversServicePrice = serviceDetails.twodriverhelpsupload {
            self.twoDriversServicePrice = twoDriversServicePrice
        }
        if let trailerHitchServicePrice = serviceDetails.trailerhitchmove {
            self.trailerHitchServicePrice = trailerHitchServicePrice
        }
        if let dirtyJobsServicePrice = serviceDetails.hultingtodumpsdirtyjob {
            self.dirtyJobsServicePrice = dirtyJobsServicePrice
        }
        
        
        subView.viewSpinner.stopAnimating()
        showSubviews(withAnimation: true)
    }
    
    fileprivate func setupViews() {
//        view.addSubview(backButton)
//        view.addSubview(headingLabel)
//        view.addSubview(spinner)
//        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
//        headingLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
//        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
//        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
//        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
    }
//    let spinner: UIActivityIndicatorView = {
//        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
//        aiView.backgroundColor = .black
//        aiView.hidesWhenStopped = true
//        aiView.color = UIColor.white
//        aiView.clipsToBounds = true
//        aiView.translatesAutoresizingMaskIntoConstraints = false
//        return aiView
//    }()
//    let backButton:UIButton = {
//        let button = UIButton(type: UIButton.ButtonType.custom)
//        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
//        button.tintColor = .white
//        button.imageView?.contentMode = .scaleAspectFit
//        button.clipsToBounds = true
//        return button
//    }()
//
//    let headingLabel:UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "SELECT SERVICES"
//        label.textColor = .white
//        label.textAlignment = .center
//        label.numberOfLines = 1
//        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
//        return label
//    }()
//    func loadUserDefaults() {
//        if let user_id = UserDefaults.standard.userID {
//            self.userId = user_id
//        } else {
//            fatalError("Unable to get data from UserDefaults")
//        }
//    }
    
    
    fileprivate func setupButtonActions() {
        subView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        subView.hireButton.addTarget(self, action: #selector(hireButtonTapped), for: .touchUpInside)
    }
    fileprivate func setupCommentsTextView() {
        subView.commentsTextView.delegate = self
        subView.placeholderLabel.font = UIFont.italicSystemFont(ofSize: (subView.commentsTextView.font?.pointSize)!)
        subView.placeholderLabel.sizeToFit()
        subView.placeholderLabel.frame.origin = CGPoint(x: 12, y: (subView.commentsTextView.font?.pointSize)!)
        subView.placeholderLabel.isHidden = !subView.commentsTextView.text.isEmpty
    }
    fileprivate func setupHireButtonLayout() {
        subView.hireButton.layoutIfNeeded()
        subView.hireButton.layer.cornerRadius = subView.hireButton.frame.width / 2
    }
    @objc fileprivate func backButtonTapped() {
        print("Back Button Tapped")
        navigationController?.popViewController(animated: true)
    }
    @objc func hireButtonTapped() {
        print("Hire Button Tapped")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerMapVC") as! CustomerMapVC
        vc.userId = self.userId
        vc.driverId = self.driverId
        vc.isStopAndDropServiceSelected = self.isStopAndDropServiceSelected
        vc.isOneDriverServiceSelected = self.isOneDriverServiceSelected
        vc.isTwoDriversServiceSelected = self.isTwoDriversServiceSelected
        vc.isTrailerHitchServiceSelected = self.isTrailerHitchServiceSelected
        vc.isDirtyJobsServiceSelected = self.isDirtyJobsServiceSelected
        vc.customerNotes = self.customerNotes
        vc.stopAndDropServicePrice = self.stopAndDropServicePrice
        vc.oneDriverServicePrice = self.oneDriverServicePrice
        vc.twoDriversServicePrice = self.twoDriversServicePrice
        vc.trailerHitchServicePrice = self.trailerHitchServicePrice
        vc.dirtyJobsServicePrice = self.dirtyJobsServicePrice
        vc.delegate = self
//        for vc in (self.navigationController?.viewControllers ?? []) {
//            if vc is CustomerDashboardVC {
//                _ = self.navigationController?.popToViewController(vc, animated: true)
//                break
//            }
//        }
//        vc.modalPresentationStyle = .fullScreen
//        navigationController?.present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension SelectServicesVC: RideRequestedProtocol {
    func rideRequested(with bookingDetails: BookingRequestResponseCodable.Datum.Booking) {
        delegate?.rideRequested(with: bookingDetails)
//        navigationController?.popViewController(animated: false)
    }
}


extension SelectServicesVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        subView.placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
