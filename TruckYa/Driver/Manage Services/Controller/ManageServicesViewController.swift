//
//  ManageServicesViewController.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
class ManageServicesViewController:UIViewController {
    var subView = ManageServicesView()
    
    var userId:String!
    
    var services: ServicesCodable.Datum.Userservice? {
        didSet {
            guard let services = services else {
                return
            }
            setupPriceData(from: services)
        }
    }
    func setupPriceData(from services: ServicesCodable.Datum.Userservice) {
        if let stopAndDropPrice = services.stopanddrop { self.subView.optionOneTextField.text = String(stopAndDropPrice) }
        if let oneDriverHelpsUploadPrice = services.onedriverhelpsupload { self.subView.optionTwoTextField.text = String(oneDriverHelpsUploadPrice) }
        if let twoDriversHelpUploadPrice = services.twodriverhelpsupload { self.subView.optionThreeTextField.text = String(twoDriversHelpUploadPrice) }
        if let trailerHitchMovesPrice = services.trailerhitchmove { self.subView.optionFourTextField.text = String(trailerHitchMovesPrice) }
        if let dirtyJobsPrice = services.hultingtodumpsdirtyjob { self.subView.optionFiveTextField.text = String(dirtyJobsPrice) }
        //        spinner.stopAnimating()
        //        viewBackButton.removeFromSuperview()
        //        viewHeadingLabel.removeFromSuperview()
        //        spinner.removeFromSuperview()
        //        view = subView
        //        subView.isHidden = false
        subView.viewSpinner.stopAnimating()
        showSubviews(withAnimation: true)
    }
    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
        //        subView.isHidden = true
        hideSubviews(withAnimation: false)
        view = subView
        
        //        setupViews()
        
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
        self.subView.optionOneTextField.alpha = 1.0
        self.subView.optionTwoLabel.alpha = 1.0
        self.subView.optionTwoTextField.alpha = 1.0
        self.subView.optionThreeLabel.alpha = 1.0
        self.subView.optionThreeTextField.alpha = 1.0
        self.subView.optionFourLabel.alpha = 1.0
        self.subView.optionFourTextField.alpha = 1.0
        self.subView.optionFiveLabel.alpha = 1.0
        self.subView.optionFiveTextField.alpha = 1.0
        self.subView.saveButton.alpha = 1.0
    }
    func hideSubiews() {
        self.subView.optionOneLabel.alpha = 0
        self.subView.optionOneTextField.alpha = 0
        self.subView.optionTwoLabel.alpha = 0
        self.subView.optionTwoTextField.alpha = 0
        self.subView.optionThreeLabel.alpha = 0
        self.subView.optionThreeTextField.alpha = 0
        self.subView.optionFourLabel.alpha = 0
        self.subView.optionFourTextField.alpha = 0
        self.subView.optionFiveLabel.alpha = 0
        self.subView.optionFiveTextField.alpha = 0
        self.subView.saveButton.alpha = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupViews()
        hideKeyboardWhenTappedAround()
        setupButtonActions()
        loadUserDefaults()
        subView.viewSpinner.startAnimating()
        fetchServicePrices(driverId: userId!)
    }
    
    //    fileprivate func setupViews() {
    //        view.addSubview(viewBackButton)
    //        view.addSubview(viewHeadingLabel)
    //        view.addSubview(spinner)
    //        viewBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
    //        viewHeadingLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    //        viewHeadingLabel.centerYAnchor.constraint(equalTo: viewBackButton.centerYAnchor).activate()
    //        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
    //        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
    //    }
    //    fileprivate func setupConstraints() {
    //        viewBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
    //        viewHeadingLabel.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
    //        viewHeadingLabel.centerYAnchor.constraint(equalTo: viewBackButton.centerYAnchor).activate()
    //        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
    //        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
    //    }
    //    let viewBackButton:UIButton = {
    //        let button = UIButton(type: UIButton.ButtonType.custom)
    //        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
    //        button.tintColor = .white
    //        button.imageView?.contentMode = .scaleAspectFit
    //        button.clipsToBounds = true
    //        return button
    //    }()
    
    //    let viewHeadingLabel:UILabel = {
    //        let label = UILabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.text = "MANAGE SERVICES"
    //        label.textColor = .white
    //        label.textAlignment = .center
    //        label.numberOfLines = 1
    //        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
    //        return label
    //    }()
    func loadUserDefaults() {
        if let user_id = UserDefaults.standard.userID {
            self.userId = user_id
        } else {
            fatalError("Unable to get data from UserDefaults")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupHireButtonLayout()
    }
    fileprivate func setupButtonActions() {
        //        viewBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        subView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        subView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    fileprivate func setupHireButtonLayout() {
//        subView.saveButton.layoutIfNeeded()
//        subView.saveButton.layer.cornerRadius = subView.saveButton.frame.width / 2
    }
    @objc fileprivate func backButtonTapped() {
        print("Back Button Tapped")
        UpdateServiceAPI.shared.dataTask.cancel()
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func saveButtonTapped() {
        print("Save Button Tapped")
        initiateUpdateServicePriceSequence()
    }
    fileprivate func initiateUpdateServicePriceSequence() {
        if let service_one_price = subView.optionOneTextField.text,
            let service_two_price = subView.optionTwoTextField.text,
            let service_three_price = subView.optionThreeTextField.text,
            let service_four_price = subView.optionFourTextField.text,
            let service_five_price = subView.optionFiveTextField.text,
            !service_one_price.isEmpty, !service_two_price.isEmpty, !service_three_price.isEmpty, !service_four_price.isEmpty, !service_five_price.isEmpty {
            self.view.endEditing(true)
            initiateNextButtonTappedAnimation()
            self.subView.spinner.startAnimating()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            print("USER ID => \(String(describing: userId))")
            print("Service 1 Price => \(service_one_price)")
            print("Service 2 Price => \(service_two_price)")
            print("Service 3 Price => \(service_three_price)")
            print("Service 4 Price => \(service_four_price)")
            print("Service 5 Price => \(service_five_price)")
            self.callUpdateServiceSequence(userId: userId, stopAndDropPrice: service_one_price, oneDriverHelpsUploadPrice: service_two_price, twoDriversHelpUploadPrice: service_three_price, trailerHitchMovesPrice: service_four_price, dirtyJobsPrice: service_five_price)
        }
    }
    internal func handleSuccess() {
        print("Handling Success")
        AssertionModalController(title: "Updated").show(on: self) {
            //            self.navigationController?.popViewController(animated: true)
        }
        
    }
    internal func handleUserState(with userDetails:UserResponseCodable.Datum.User) {
        guard let userId = userDetails.id,
            let userName = userDetails.fullname,
            let userEmail = userDetails.email,
            let userMobile = userDetails.mobileno,
            let userType = userDetails.usertype,
            !userId.isEmpty, !userName.isEmpty, !userEmail.isEmpty, !userMobile.isEmpty, !userType.isEmpty else {
                print("API Internal Error: Rider MetaData & Details are nil")
                let alertview = JSSAlertView().show(self,
                                                    title: "Error",
                                                    text: "Service Error. Please try again in a while",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1),
                                                    iconImage: UIImage(named: "oho"))
                alertview.setTextTheme(.light)
                alertview.addAction({
                    self.fallBackToIdentity()
                })
                return
        }
        let isProfileSet = userDetails.isprofileset ?? false,
        isVehicleInfoSet = userDetails.isvehicleinfoset ?? false,
        isLicenseInfoSet = userDetails.islisenseinfoset ?? false,
        isInsuranceInfoSet = userDetails.isinsuranceinfoset ?? false
        UserDefaults.saveDriverScope(isProfileSet: isProfileSet, isVehicleInfoSet: isVehicleInfoSet, isLicenseInfoSet: isLicenseInfoSet, isInsuranceInfoSet: isInsuranceInfoSet)
    }
    
    
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
        DispatchQueue.main.async {
            self.subView.saveButton.isEnabled = true
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.subView.spinner.stopAnimating()
                self.subView.saveButton.alpha = 1.0
                //                self.subView.saveButton.imageView?.layer.transform = CATransform3DIdentity
                self.subView.saveButton.setTitle("SAVE", for: .normal)
//                self.subView.saveButton.frame = CGRect(origin: self.subView.frame.origin, size: CGSize(width: self.subView.saveButtonSize, height: self.subView.saveButtonSize))
                self.subView.saveButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func initiateNextButtonTappedAnimation() {
        DispatchQueue.main.async {
            self.subView.saveButton.isEnabled = false
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                //                self.subView.saveButton.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                self.subView.saveButton.setTitle("", for: .normal)
                self.subView.saveButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//                self.subView.saveButton.frame = CGRect(origin: self.subView.frame.origin, size: CGSize(width: self.subView.frame.width * 0.8, height: self.subView.frame.height * 0.8))
//                self.subView.saveButton.frame = CGRect(x: self.subView.frame.origin.x, y: self.subView.frame.origin.y, width: self.subView.frame.width * 0.8, height: self.subView.frame.height * 0.8)
            }, completion: nil)
        }
    }
    
    internal func enableNextButton() {
        DispatchQueue.main.async {
            self.subView.saveButton.isEnabled = true
            UIView.animate(withDuration: 0.4) {
                self.subView.saveButton.alpha = 1.0
            }
        }
    }
    internal func disableNextButton() {
        DispatchQueue.main.async {
            self.subView.saveButton.isEnabled = false
            UIView.animate(withDuration: 0.4) {
                self.subView.saveButton.alpha = 0.5
            }
        }
    }
    @objc fileprivate func didChangeTextField(textField:UITextField) {
        if let text = textField.text {
            if text.isEmpty {
                self.disableNextButton()
            } else {
                self.validateFields()
            }
        } else { self.disableNextButton() }
    }
    fileprivate func isDataValid() -> Bool {
        guard let service_one_price = subView.optionOneTextField.text,
            let service_two_price = subView.optionTwoTextField.text,
            let service_three_price = subView.optionThreeTextField.text,
            let service_four_price = subView.optionFourTextField.text,
            let service_five_price = subView.optionFiveTextField.text,
            !service_one_price.isEmpty, !service_two_price.isEmpty, !service_three_price.isEmpty, !service_four_price.isEmpty, !service_five_price.isEmpty else {
                return false
        }
        return true
    }
    fileprivate func validateFields() {
        isDataValid() ? enableNextButton() : disableNextButton()
    }
    
    internal func handleValidationSequence(check:Bool) {
        check ? enableNextButton() : disableNextButton()
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
    
}
