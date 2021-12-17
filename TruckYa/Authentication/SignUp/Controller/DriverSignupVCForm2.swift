//
//  DriverSignupVCForm2.swift
//  TruckYa
//
//  Created by Digit Bazar on 06/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import Photos
import CoreLocation
import JSSAlertView
class DriverSignupVCForm2: UIViewController {
    var userId:String!
    var fullName:String!
    var mobileNumber:String!
    var userType:UserType!
    internal var profileImageURL:String? {
        didSet {
            if let urlStr = profileImageURL {
                print("Printing PRofile Image URL =>")
                print(urlStr)
                let completeURL:String = Config.EndpointConfig.baseURL + "/" + urlStr
                print("Complete URL => \(completeURL)")
                self.profileImageView.loadImageUsingCacheWithURLString(completeURL, placeHolder: #imageLiteral(resourceName: "driver"))
                UserDefaults.standard.userProfileImageURL = urlStr
            } else {
                print("Failed to unwrap PRofile Image URL =>")
                self.profileImageView.loadImageUsingCacheWithURLString(nil, placeHolder: #imageLiteral(resourceName: "driver"))
            }
        }
    }
    var shouldHideBackButton:Bool! = false {
        didSet {
            backButton.isHidden = shouldHideBackButton
        }
    }
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
        setupTextFields()
        setupButtonActions()
        setupAboutTextView()
        setupTextFieldsDelegates()
        setupLocationManager()
        scrollView.delegate = self
        scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y), animated: true)
//        ProfilePictureAPI.shared.delegate = self
        loadUserDefaults()
    }
    
    func loadUserDefaults() {
        if let imageURL = UserDefaults.standard.userProfileImageURL,
            !imageURL.isEmpty {
            self.profileImageURL = imageURL
        }
        //        if let userType = UserDefaults.standard.userType {
        //            switch userType {
        //            case .Customer: aboutTextView.isHidden = true
        //            case .Driver: aboutTextView.isHidden = false
        //            }
        //        }
        if let user_id = UserDefaults.standard.userID,
            let full_name = UserDefaults.standard.userName,
            let mobile_number = UserDefaults.standard.userMobile,
            let user_type = UserDefaults.standard.userType{
            self.userId = user_id
            self.fullName = full_name
            self.mobileNumber = mobile_number
            self.userType = user_type
        } else {
            fatalError("Unable to get data from UserDefaults")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationsObservers()
    }
    fileprivate func setupTextFieldsDelegates() {
        cityTextField.delegate = self
        stateTextField.delegate = self
        countryTextField.delegate = self
        zipTextField.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0
        nextButton.layoutIfNeeded()
        nextButton.layer.cornerRadius = nextButton.frame.size.width / 2.0
        setupTextFieldsBottomLayer()
    }
    func initViews(){
        setupViews()
        setupConstraints()
    }
    internal func setupViews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.isUserInteractionEnabled = true
        setupScrollViewSubviews()
        backgroundImageView.addSubview(scrollView)
    }
    internal func setupConstraints() {
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        scrollView.anchor(top: backgroundImageView.topAnchor, left: backgroundImageView.leftAnchor, bottom: backgroundImageView.bottomAnchor, right: backgroundImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        setupScrollViewSubviewsConstraints()
    }
    
    
    
    func setupScrollViewSubviews() {
        setupTextFields()
        scrollView.addSubview(backButton)
        scrollView.addSubview(headingLabel)
        scrollView.addSubview(pageCountLabel)
        scrollView.addSubview(driverImageView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(uploadImageLabel)
        scrollView.addSubview(addressTextField)
        scrollView.addSubview(cityTextField)
        scrollView.addSubview(stateTextField)
        scrollView.addSubview(countryTextField)
        scrollView.addSubview(zipTextField)
        aboutTextView.addSubview(placeholderLabel)
        scrollView.addSubview(aboutTextView)
        nextButton.addSubview(spinner)
        scrollView.addSubview(nextButton)
        
    }
    func setupScrollViewSubviewsConstraints() {
        backButton.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, topConstant: 44, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        
        driverImageView.anchor(top: headingLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width / 7, heightConstant: view.frame.width / 7)
        driverImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).activate()
        
        pageCountLabel.anchor(top: nil, left: nil, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        pageCountLabel.centerYAnchor.constraint(equalTo: driverImageView.centerYAnchor).activate()
        
        let padding = view.frame.width / 11
        let width:CGFloat = ((view.frame.width - (padding * 2)) / 2) - 10
        let height:CGFloat = 50
        
        let profileImageHeight:CGFloat = self.view.frame.width / 4
        profileImageView.anchor(top: driverImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: view.frame.height / 15, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: profileImageHeight, heightConstant: profileImageHeight)
        profileImageView.centerXAnchor.constraint(equalTo: driverImageView.centerXAnchor).activate()
        uploadImageLabel.anchor(top: profileImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        addressTextField.anchor(top: uploadImageLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 40, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: view.frame.width - (padding * 2), heightConstant: height)
        cityTextField.anchor(top: addressTextField.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: profileImageView.centerXAnchor, topConstant: 20, leftConstant: padding, bottomConstant: 0, rightConstant: 10, widthConstant: width, heightConstant: height)
        stateTextField.anchor(top: nil, left: profileImageView.centerXAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: padding, widthConstant: width, heightConstant: height)
        stateTextField.centerYAnchor.constraint(equalTo: cityTextField.centerYAnchor).activate()
        countryTextField.anchor(top: stateTextField.bottomAnchor, left: cityTextField.leftAnchor, bottom: nil, right: cityTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        zipTextField.anchor(top: nil, left: stateTextField.leftAnchor, bottom: nil, right: stateTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        zipTextField.centerYAnchor.constraint(equalTo: countryTextField.centerYAnchor).activate()
        aboutTextView.anchor(top: countryTextField.bottomAnchor, left: countryTextField.leftAnchor, bottom: nil, right: zipTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 140)
        nextButton.anchor(top: aboutTextView.bottomAnchor, left: nil, bottom: scrollView.bottomAnchor, right: zipTextField.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 72, heightConstant: 72)
        spinner.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).activate()
        scrollView.contentSize.width = self.view.frame.width
    }
    
    
    let placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "Add your description..."
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "driver_bg")
        return imageView
    }()
    let scrollView:UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.indicatorStyle = UIScrollView.IndicatorStyle.white
        view.isDirectionalLockEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    lazy var backButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    @objc fileprivate func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    var currentLocation: CLLocation!
    let locationButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-1").withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isEnabled = true
        button.clipsToBounds = true
        //        button.contentMode = .scaleAspectFit
        //        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    @objc fileprivate func locationButtonTapped() {
        autofill()
    }
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            
            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })
        
    }
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
                
                currentLocation = locationManager.location
                
            }
        }
        
    }
    func autofill() {
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
                
                currentLocation = locationManager.location
                getPlacemark(forLocation: currentLocation) {
                    (originPlacemark, error) in
                    if let err = error {
                        print(err)
                    } else if let placemark = originPlacemark {
                        // Do something with the placemark
                        let address = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                        print("\(address)")
                        self.addressTextField.text = address
                        self.cityTextField.text = placemark.locality
                        self.stateTextField.text = placemark.administrativeArea
                        self.countryTextField.text = placemark.country
                        self.zipTextField.text = placemark.postalCode
                        self.validateFields()
                    }
                }
            }
        }
    }
    let headingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DRIVER"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
        return label
    }()
    let driverImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "driver_red")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var profileImageView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "user")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        return view
    }()
    @objc func didTapImageView() {
        promptPhotosPickerMenu()
    }
    let uploadImageLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Upload Driver Image"
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 17.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let pageCountLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2/5"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    lazy var addressTextField = createTextField(placeholder: "Address")
    lazy var cityTextField = createTextField(placeholder: "City")
    lazy var stateTextField = createTextField(placeholder: "State")
    lazy var countryTextField = createTextField(placeholder: "Country")
    lazy var zipTextField = createTextField(placeholder: "Zip Code")
    fileprivate func setupAboutTextView() {
        aboutTextView.delegate = self
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (aboutTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 12, y: (aboutTextView.font?.pointSize)!)
        placeholderLabel.isHidden = !aboutTextView.text.isEmpty
    }
    func createTextField(placeholder:String? = nil) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: CustomFonts.rajdhaniRegular.rawValue, size: 18.0)
        if let placeholderText = placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.gray])
        }
        textField.textColor = UIColor.white
        textField.textAlignment = .left
        textField.keyboardAppearance = .dark
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        return textField
    }
    let nextButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "red_arrow"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let inset:CGFloat = 20
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.backgroundColor = UIColor.white
        button.isEnabled = false
        button.alpha = 0.5
        button.clipsToBounds = true
        return button
    }()
    @objc func nextButtonTapped() {
        print("Next Button Tapped")
        initiateUpdateProfileSequence()
//        let vc = DriverSignupVCForm3()
//        navigationController?.pushViewController(vc, animated: true)
        
    }
    fileprivate func setupButtonActions() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    let aboutTextView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.textAlignment = .left
        textView.isSelectable = true
        textView.tintColor = UIColor.lightGray
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 0, right: 10)
        textView.backgroundColor = UIColor.red
        textView.font = UIFont(name: CustomFonts.gilroyRegular.rawValue, size: 14)
        textView.textColor = UIColor.white
        textView.sizeToFit()
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = .all
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton));
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 14)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        textView.inputAccessoryView = toolbar
        textView.keyboardAppearance = .default
        textView.layer.cornerRadius = 15
        return textView
    }()
    @objc func didTapDoneButton() {
        view.endEditing(true)
    }
    func setupTextFieldsBottomLayer() {
        let spaceY:CGFloat = -4
        addressTextField.blendBottomLine(spaceY: spaceY)
        cityTextField.blendBottomLine(spaceY: spaceY)
        stateTextField.blendBottomLine(spaceY: spaceY)
        countryTextField.blendBottomLine(spaceY: spaceY)
        zipTextField.blendBottomLine(spaceY: spaceY)
    }
    func setupTextFields() {
        addressTextField.setIcon(#imageLiteral(resourceName: "location-1").withRenderingMode(.alwaysTemplate), position: .Right, tintColor: .white)
        addressTextField.rightView?.isUserInteractionEnabled = true
        addressTextField.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(locationButtonTapped)))
        addressTextField.textContentType = .fullStreetAddress
        cityTextField.textContentType = .addressCity
        stateTextField.textContentType = .addressState
        countryTextField.textContentType = .countryName
        zipTextField.textContentType = .postalCode
        
        
        addressTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        stateTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        zipTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
    }
    
    
    
    
    
    var activeField:UITextField?
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    fileprivate func removeKeyboardNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let contentInsets: UIEdgeInsets = .zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }, completion: nil)
    }
    @objc func keyboardShow(notification:NSNotification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight:CGFloat = keyboardSize?.height ?? 280.0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + 50.0, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }, completion: nil)
    }
    
    
    
    //Prompt
    
    
    func checkPhotoLibraryPermissions() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        @unknown default: fatalError()
        }
    }
    fileprivate func checkCameraPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: break
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for clicking photo",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Please allow camera access for clicking photo",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.async() {
                    self.checkCameraPermissions()
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }
    internal func promptPhotosPickerMenu() {
        let alert = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (action) in
            self.handleSourceTypeCamera()
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (action) in
            self.handleSourceTypeGallery()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    private func viewCurrentProfileImage() {
        
    }
    private func handleSourceTypeCamera() {
        checkCameraPermissions()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true, completion: nil)
    }
    private func handleSourceTypeGallery() {
        checkPhotoLibraryPermissions()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true, completion: nil)
    }
    var scaledProfileImage:UIImage!
    var uploadProgress:Float? {
        didSet {
//            ProgressBarController.shared.progress = uploadProgress
//            if ProgressBarController.shared.onComplpetion {
//                self.profileImageView.image = self.scaledProfileImage
//            }
        }
    }
    
    private func uploadImage(_ image: UIImage) {
        guard let userId:String = UserDefaults.standard.userID else {
            print("Error: UserID not set in UserDefaults")
            return
        }
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
            print("Unable to get scaled compressed image")
            return
        }
        self.scaledProfileImage = scaledImage
        
        let imageName = [UUID().uuidString, String(Int(Date().timeIntervalSince1970)*1000)].joined(separator: "-") + ".jpg"
        print("Image Name => \(imageName)")
        
        DispatchQueue.main.async {
            self.callUpdateProfilePictureSequence(imageURL: imageName, imageData: data, userID: userId)
//            ProgressBarController.shared.showProgressBar(on: self)
        }
    }
    
    
    fileprivate func initiateUpdateProfileSequence() {
        switch userType {
        case .Driver:
            if let address = self.addressTextField.text,
                let city = self.cityTextField.text,
                let state = self.stateTextField.text,
                let country = self.countryTextField.text,
                let zipCode = self.zipTextField.text,
                let about = self.aboutTextView.text,
                !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zipCode.isEmpty, !about.isEmpty {
                self.view.endEditing(true)
                initiateNextButtonTappedAnimation()
                self.spinner.startAnimating()
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                self.callUpdateProfileSequence(userId: userId, fullName: fullName, mobileNo: mobileNumber, city: city, address: address, state: state, country: country, postalCode: zipCode, about: about)
            }
        case .Customer:
            if let address = self.addressTextField.text,
                let city = self.cityTextField.text,
                let state = self.stateTextField.text,
                let country = self.countryTextField.text,
                let zipCode = self.zipTextField.text,
                !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zipCode.isEmpty {
                self.view.endEditing(true)
                initiateNextButtonTappedAnimation()
                self.spinner.startAnimating()
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                self.callUpdateProfileSequence(userId: userId, fullName: fullName, mobileNo: mobileNumber, city: city, address: address, state: state, country: country, postalCode: zipCode, about: "about")
            }
        case .none: break
        }
        
    }
    internal func handleProfileUploadSuccess() {
        print("Handling Success")
        AssertionModalController(title: "Updated").show(on: self)
    }
    internal func handleSuccess() {
        print("Handling Success")
        AssertionModalController(title: "Updated").show(on: self) {
            let vc = DriverSignupVCForm3()
            vc.shouldHideBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)
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
        UserDefaults.standard.userProfileImageURL = self.profileImageURL
        UserDefaults.saveUserDetails(details: userDetails)
//        let vc = DriverSignupVCForm3()
//        vc.shouldHideBackButton = true
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
        self.nextButton.isEnabled = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.spinner.stopAnimating()
                self.nextButton.alpha = 1.0
                self.nextButton.imageView?.layer.transform = CATransform3DIdentity
                self.nextButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    func initiateNextButtonTappedAnimation() {
        self.nextButton.isEnabled = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.nextButton.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                self.nextButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        }
    }
    
    internal func enableNextButton() {
        nextButton.isEnabled = true
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) {
                self.nextButton.alpha = 1.0
            }
        }
    }
    internal func disableNextButton() {
        nextButton.isEnabled = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) {
                self.nextButton.alpha = 0.5
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
        switch userType {
        case .Customer:
            guard let address = self.addressTextField.text,
                let city = self.cityTextField.text,
                let state = self.stateTextField.text,
                let country = self.countryTextField.text,
                let zipCode = self.zipTextField.text,
                !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zipCode.isEmpty else { return false }
            return true
        case .Driver:
            guard let address = self.addressTextField.text,
                let city = self.cityTextField.text,
                let state = self.stateTextField.text,
                let country = self.countryTextField.text,
                let zipCode = self.zipTextField.text,
                let about = self.aboutTextView.text,
                !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zipCode.isEmpty, !about.isEmpty else { return false }
            return true
        case .none:
            print("Unknown Case")
            return false
        }
    }
    fileprivate func validateFields() {
        isDataValid() ? enableNextButton() : disableNextButton()
    }

    internal func handleValidationSequence(check:Bool) {
        check ? enableNextButton() : disableNextButton()
    }
    
    
    let spinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        aiView.backgroundColor = .white
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.red
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    
    
    
    
    
    
    
    
}
extension DriverSignupVCForm2: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        validateFields()
    }
}
class ProgressBarController:UIViewController {
    static let shared = ProgressBarController()
    var onComplpetion:Bool = false
    var progress:Float? {
        didSet {
            if let progress = progress {
                self.progressBar.setProgress(progress, animated: true)
                if progress == 1.0 {
                    alertVC.dismiss(animated: true, completion: {
                        self.onComplpetion = true
                    })
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    let alertVC = UIAlertController.customAlertController(title: "Uploading...")
    
    let progressBar:UIProgressView = {
        
        let view = UIProgressView(progressViewStyle: .default)
        let margin:CGFloat = 8.0
        let alertVCWidth:CGFloat = 270.0
        
        let frame = CGRect(x: margin, y: 72.0, width: alertVCWidth - margin * 2.0 , height: 2.0)
        view.frame = frame
        //        view.progress = 0.0
        view.progressTintColor = UIColor.blue
        return view
    }()
    
    
    func showProgressBar(on vc:UIViewController) {
        
        progressBar.setProgress(0, animated: true)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print("Cancelling Upload")
            //            progress.cancel()
            //            completion(false)
        }
        alertVC.addAction(cancelAction)
        alertVC.view.addSubview(progressBar)
        DispatchQueue.main.async {
            UIAlertController.presentAlert(self.alertVC, on: vc)
        }
        
        //        let progressPercent = Int(progress * 100)
        //        print("Uploading => \(progressPercent) %")
        //        if progress == 1.0 {
        //            print("Upload Completed")
        ////            completion(true)
        //        }
    }
}


//extension DriverSignupVCForm2: ProfilePictureAPIDelegate {
//    func getUploadProgress(progress: Float) {
//        self.uploadProgress = progress
//        print("Delegated Upload Progress => \((uploadProgress ?? 0) * 100) %")
//    }
//}


extension DriverSignupVCForm2: UITextFieldDelegate {
    
}
extension DriverSignupVCForm2: UIScrollViewDelegate {
    
}
extension DriverSignupVCForm2: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadImage(image)
            
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage(image)
        } else {
            print("Unknown stuff")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
