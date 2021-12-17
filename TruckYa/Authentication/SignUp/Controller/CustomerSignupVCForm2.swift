//
//  CustomerSignupVCForm2.swift
//  TruckYa
//
//  Created by Digit Bazar on 07/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import Photos
import JSSAlertView

class CustomerSignupVCForm2: UIViewController {
    var userId:String!
    var fullName:String!
    var mobileNumber:String!
    var userType:UserType!
    internal var profileImageURL:String? {
        didSet {
            if let urlStr = profileImageURL {
                let completeURL:String = Config.EndpointConfig.baseURL + "/" + urlStr
                self.profileImageView.loadImageUsingCacheWithURLString(completeURL, placeHolder: #imageLiteral(resourceName: "driver"))
                UserDefaults.standard.userProfileImageURL = urlStr
            } else {
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
        cardContainerView.layer.cornerRadius = 20
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
        backgroundImageView.addSubview(scrollView)
        setupScrollViewSubviews()
        
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
        //        scrollView.addSubview(pageCountLabel)
        scrollView.addSubview(customerImageView)
        cardContainerView.addSubview(profileImageView)
        cardContainerView.addSubview(uploadImageLabel)
        cardContainerView.addSubview(addressTextField)
        cardContainerView.addSubview(cityTextField)
        cardContainerView.addSubview(stateTextField)
        cardContainerView.addSubview(countryTextField)
        cardContainerView.addSubview(zipTextField)
        scrollView.addSubview(cardContainerView)
        scrollView.addSubview(skipButton)
        nextButton.addSubview(spinner)
        scrollView.addSubview(nextButton)
        
    }
    func setupScrollViewSubviewsConstraints() {
        backButton.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, topConstant: 44, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        
        customerImageView.anchor(top: headingLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width / 7, heightConstant: view.frame.width / 7)
        customerImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).activate()
        
        //        pageCountLabel.anchor(top: nil, left: nil, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        //        pageCountLabel.centerYAnchor.constraint(equalTo: driverImageView.centerYAnchor).activate()
        
        let padding = view.frame.width / 16
        let width = view.frame.width - (padding * 2)
        let height:CGFloat = 50
        
        let profileImageHeight:CGFloat = self.view.frame.width / 4
        cardContainerView.anchor(top: customerImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 30, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: width)
        profileImageView.anchor(top: cardContainerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: profileImageHeight, heightConstant: profileImageHeight)
        profileImageView.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor).activate()
        uploadImageLabel.anchor(top: profileImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        addressTextField.anchor(top: uploadImageLabel.bottomAnchor, left: cardContainerView.leftAnchor, bottom: nil, right: cardContainerView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: height)
//        addressTextField.anchor(top: uploadImageLabel.bottomAnchor, left: cardContainerView.leftAnchor, bottom: nil, right: cardContainerView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: height)
        cityTextField.anchor(top: addressTextField.bottomAnchor, left: addressTextField.leftAnchor, bottom: nil, right: cardContainerView.centerXAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 20, rightConstant: 10, widthConstant: 0, heightConstant: height)
        stateTextField.anchor(top: nil, left: cardContainerView.centerXAnchor, bottom: nil, right: addressTextField.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        stateTextField.centerYAnchor.constraint(equalTo: cityTextField.centerYAnchor).activate()
        countryTextField.anchor(top: cityTextField.bottomAnchor, left: addressTextField.leftAnchor, bottom: cardContainerView.bottomAnchor, right: cardContainerView.centerXAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 20, rightConstant: 10, widthConstant: 0, heightConstant: height)
        zipTextField.anchor(top: nil, left: cardContainerView.centerXAnchor, bottom: nil, right: addressTextField.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        zipTextField.centerYAnchor.constraint(equalTo: countryTextField.centerYAnchor).activate()
        nextButton.anchor(top: cardContainerView.bottomAnchor, left: nil, bottom: scrollView.bottomAnchor, right: cardContainerView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 72, heightConstant: 72)
        spinner.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).activate()
        skipButton.anchor(top: nil, left: cardContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        skipButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).activate()
        scrollView.contentSize.width = self.view.frame.width
    }
    let skipButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: CustomFonts.rajdhaniLight.rawValue, size: 20.0)!,
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
        //.double.rawValue, .thick.rawValue
        let attributeString = NSMutableAttributedString(string: "SKIP",
                                                        attributes: attributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func didTapSkipButton() {
        print("Skip Button Tapped")
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let vc = CustomerDashboardVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    let cardContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    let backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "customer_bg")
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
    let backButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), for: .normal)
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
    let customerImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "customer")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var profileImageView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "user").withRenderingMode(.alwaysTemplate)
        view.tintColor = .lightText
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
        label.text = "Upload Profile Image"
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15.0)
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
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
                !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zipCode.isEmpty {
                self.view.endEditing(true)
                initiateNextButtonTappedAnimation()
                self.spinner.startAnimating()
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                self.callUpdateProfileSequence(userId: userId, fullName: fullName, mobileNo: mobileNumber, city: city, address: address, state: state, country: country, postalCode: zipCode, about: "nil")
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
                self.callUpdateProfileSequence(userId: userId, fullName: fullName, mobileNo: mobileNumber, city: city, address: address, state: state, country: country, postalCode: zipCode, about: "nil")
            }
        case .none: break
        }
        
    }
    internal func handleSuccess() {
        print("Handling Success")
        AssertionModalController(title: "Updated").show(on: self) {
            let vc = CustomerDashboardVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    internal func handleProfileUploadSuccess() {
        print("Handling Success")
        AssertionModalController(title: "Updated").show(on: self)
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
        
        
        let isProfileSet = userDetails.isprofileset ?? false
        AppData.userDetails = userDetails
        UserDefaults.saveCustomerScope(isProfileSet: isProfileSet)
        UserDefaults.standard.userProfileImageURL = self.profileImageURL
        UserDefaults.saveUserDetails(details: userDetails)
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
                !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zipCode.isEmpty else { return false }
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
}

//extension CustomerSignupVCForm2: ProfilePictureAPIDelegate {
//    func getUploadProgress(progress: Float) {
//        self.uploadProgress = progress
//        print("Delegated Upload Progress => \((uploadProgress ?? 0) * 100) %")
//    }
//}
extension CustomerSignupVCForm2: UIScrollViewDelegate {
    
}
extension CustomerSignupVCForm2: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension CustomerSignupVCForm2: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeField = nil
        
    }
}
