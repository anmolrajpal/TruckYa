//
//  DriverSignupVCForm5.swift
//  TruckYa
//
//  Created by Digit Bazar on 06/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import Photos
import JSSAlertView
class DriverSignupVCForm5: UIViewController {
    var userId:String!
    
    var shouldPop:Bool = false
    var insuranceInfo:UserResponseCodable.Datum.User.Insurance? {
        didSet {
            guard let details = insuranceInfo else {
                print("Insurance Info not available.")
                return
            }
            setupData(with: details)
        }
    }
    func setupData(with details: UserResponseCodable.Datum.User.Insurance) {
        insuranceImageURL = details.insuraceimage
        insuranceNumber = details.insuraceno
        companyName = details.companyname
        insuranceAmount = details.insuranceamount
        startDate = details.issuedate
        endDate = details.tilldate
    }
    var insuranceNumber:String? {
        didSet {
            self.insuranceNumberTextField.text = insuranceNumber
        }
    }
    var companyName:String? {
        didSet {
            self.companyNameTextField.text = companyName
        }
    }
    var insuranceAmount:String? {
        didSet {
            self.insuranceAmountTextField.text = insuranceAmount
        }
    }
    var startDate:String? {
        didSet {
            self.startDateTextField.text = startDate
        }
    }
    var endDate:String? {
        didSet {
            self.endDateTextField.text = endDate
        }
    }
    var shouldHideBackButton:Bool! = false {
        didSet {
            backButton.isHidden = shouldHideBackButton
        }
    }
    var shouldHidePageCountLabel:Bool! = false {
        didSet {
            pageCountLabel.isHidden = shouldHidePageCountLabel
        }
    }
    
    
    
    var isInsuranceImageSet:Bool = false {
        didSet {
            self.validateFields()
        }
    }
    internal var insuranceImageURL:String? {
        didSet {
            if let urlStr = insuranceImageURL {
                self.isInsuranceImageSet = true
                let completeURL:String = Config.EndpointConfig.baseURL + "/" + urlStr
                self.insuranceImageView.loadImageUsingCacheWithURLString(completeURL, placeHolder: #imageLiteral(resourceName: "truck_icon"))
            } else {
                print("Failed to unwrap Insurance Image URL =>")
                self.insuranceImageView.loadImageUsingCacheWithURLString(nil, placeHolder: #imageLiteral(resourceName: "truck_icon"))
            }
        }
    }
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTextFieldsDelegates()
        loadUserDefaults()
        setupButtonActions()
        scrollView.delegate = self
        scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y), animated: true)
    }
    func loadUserDefaults() {
        if let user_id = UserDefaults.standard.userID {
            self.userId = user_id
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
        insuranceNumberTextField.delegate = self
        companyNameTextField.delegate = self
        insuranceAmountTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
        insuranceImageView.layoutIfNeeded()
        insuranceImageView.layer.cornerRadius = 22
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
        scrollView.addSubview(insuranceImageView)
        scrollView.addSubview(uploadImageLabel)
        scrollView.addSubview(insuranceNumberTextField)
        scrollView.addSubview(companyNameTextField)
        scrollView.addSubview(insuranceAmountTextField)
        scrollView.addSubview(startDateTextField)
        scrollView.addSubview(endDateTextField)
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
        let width = view.frame.width - (padding * 2)
        let height:CGFloat = 50
        let dateTFWidth:CGFloat = ((view.frame.width - (padding * 2)) / 2) - 10
        let insuranceImageWidth:CGFloat = self.view.frame.width / 2
        let insuranceImageHeight:CGFloat = insuranceImageWidth * 0.7
        insuranceImageView.anchor(top: driverImageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: view.frame.height / 18, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: insuranceImageWidth, heightConstant: insuranceImageHeight)
        insuranceImageView.centerXAnchor.constraint(equalTo: driverImageView.centerXAnchor).activate()
        uploadImageLabel.anchor(top: insuranceImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        insuranceNumberTextField.anchor(top: uploadImageLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 30, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: width, heightConstant: height)
        companyNameTextField.anchor(top: insuranceNumberTextField.bottomAnchor, left: insuranceNumberTextField.leftAnchor, bottom: nil, right: insuranceNumberTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        insuranceAmountTextField.anchor(top: companyNameTextField.bottomAnchor, left: insuranceNumberTextField.leftAnchor, bottom: nil, right: insuranceNumberTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        startDateTextField.anchor(top: insuranceAmountTextField.bottomAnchor, left: insuranceNumberTextField.leftAnchor, bottom: nil, right: insuranceImageView.centerXAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: dateTFWidth, heightConstant: height)
        endDateTextField.anchor(top: nil, left: insuranceImageView.centerXAnchor, bottom: nil, right: insuranceNumberTextField.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: dateTFWidth, heightConstant: height)
        endDateTextField.centerYAnchor.constraint(equalTo: startDateTextField.centerYAnchor).activate()
        nextButton.anchor(top: endDateTextField.bottomAnchor, left: nil, bottom: scrollView.bottomAnchor, right: endDateTextField.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 72, heightConstant: 72)
        spinner.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).activate()
    }
    
    
    
    
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
    let pageCountLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5/5"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    lazy var insuranceImageView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "car_insurance")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
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
        label.text = "Upload Insurance Image"
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 17.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    lazy var insuranceNumberTextField = createTextField(placeholder: "Insurance Number")
    lazy var companyNameTextField = createTextField(placeholder: "Company Name")
    lazy var insuranceAmountTextField = createTextField(placeholder: "Insurance Amount")
    lazy var startDateTextField = createTextField(placeholder: "Issue Date")
    lazy var endDateTextField = createTextField(placeholder: "Validy")
    
    
    
    
    
    //Start Date Picker
    let startDatePicker:UIDatePicker = UIDatePicker()
    fileprivate func setupStartDatePickerTextField() {
        startDateTextField.keyboardAppearance = .default
        startDatePicker.datePickerMode = UIDatePicker.Mode.date
        startDatePicker.setValue(UIColor.white, forKey: "textColor")
        startDatePicker.backgroundColor = UIColor.clear
        
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(startDatePickerDidTapCancel));
        
        cancelButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        cancelButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 13)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDatePickerDidTapDone));
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 13)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        startDateTextField.inputAccessoryView = toolbar
        startDateTextField.inputView = startDatePicker
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged(sender:)), for: .valueChanged)
    }
    @objc func startDatePickerDidTapDone(){
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = CustomDateFormat.dateType1.rawValue
        let dateStr = formatter.string(from: startDatePicker.date)
        print(dateStr)
        startDateTextField.text = dateStr
        endDateTextField.becomeFirstResponder()
        validateFields()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: startDatePicker.date)
        if let day = components.day, let month = components.month, let year = components.year {
            let date = "\(day).\(month).\(year)"
            print("Start Date: \(date)")
        }
    }
    @objc func startDatePickerDidTapCancel(){
        self.view.endEditing(true)
    }
    fileprivate func setupDatePickerRange() {
        let currentDate = Date()
        startDatePicker.minimumDate = currentDate.add(minutes: 1)
        startDatePicker.maximumDate = currentDate.add(days: 7)
    }
    @objc func startDatePickerValueChanged(sender:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = CustomDateFormat.dateType1.rawValue
        startDateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func validateDatePicker(){
        if !isDatePickerDateValid() {
            print("Date Picker Invalid")
        }
    }
    func isDatePickerDateValid() -> Bool {
        let currentTime = Date()
        return startDatePicker.date < currentTime ? false : true
    }
    //    fileprivate func isDataValid() -> Bool {
    //        guard isDatePickerDateValid() else { return false }
    //        return true
    //    }
    
    
    
    
    
    //End Date Picker
    let endDatePicker:UIDatePicker = UIDatePicker()
    fileprivate func setupEndDatePickerTextField() {
        endDateTextField.keyboardAppearance = .default
        endDatePicker.datePickerMode = UIDatePicker.Mode.date
        endDatePicker.setValue(UIColor.white, forKey: "textColor")
        endDatePicker.backgroundColor = UIColor.clear
        
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(endDatePickerDidTapCancel));
        
        cancelButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        cancelButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 13)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endDatePickerDidTapDone));
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 13)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = endDatePicker
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged(sender:)), for: .valueChanged)
    }
    @objc func endDatePickerDidTapDone(){
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = CustomDateFormat.dateType1.rawValue
        let dateStr = formatter.string(from: endDatePicker.date)
        print(dateStr)
        endDateTextField.text = dateStr
        validateFields()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: endDatePicker.date)
        if let day = components.day, let month = components.month, let year = components.year {
            let date = "\(day).\(month).\(year)"
            print("End Date: \(date)")
        }
    }
    @objc func endDatePickerDidTapCancel(){
        self.view.endEditing(true)
    }
    @objc func endDatePickerValueChanged(sender:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = CustomDateFormat.dateType1.rawValue
        endDateTextField.text = formatter.string(from: sender.date)
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
        button.clipsToBounds = true
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    @objc func nextButtonTapped() {
        print("Next Button Tapped")
        initiateUpdateInsuranceInfoSequence()
    }
    fileprivate func setupButtonActions() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    func setupTextFieldsBottomLayer() {
        let spaceY:CGFloat = -4
        insuranceNumberTextField.blendBottomLine(spaceY: spaceY)
        companyNameTextField.blendBottomLine(spaceY: spaceY)
        insuranceAmountTextField.blendBottomLine(spaceY: spaceY)
        startDateTextField.blendBottomLine(spaceY: spaceY)
        endDateTextField.blendBottomLine(spaceY: spaceY)
    }
    func setupTextFields() {
        
        companyNameTextField.textContentType = .organizationName
        insuranceAmountTextField.keyboardType = .decimalPad
        setupStartDatePickerTextField()
        setupEndDatePickerTextField()
        
        
        insuranceNumberTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        companyNameTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        insuranceAmountTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
    }
    
    
    
    fileprivate func initiateUpdateInsuranceInfoSequence() {
        if let insurance_number = self.insuranceNumberTextField.text,
            let company_name = self.companyNameTextField.text,
            let insurance_amount = self.insuranceAmountTextField.text,
            let start_date = self.startDateTextField.text,
            let end_date = self.endDateTextField.text,
            let insurance_image = self.insuranceImageView.image,
            !insurance_number.isEmpty, !company_name.isEmpty, !insurance_amount.isEmpty, !start_date.isEmpty, !end_date.isEmpty {
            guard let scaledImage = insurance_image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                print("Unable to get scaled compressed image")
                return
            }
            self.view.endEditing(true)
            initiateNextButtonTappedAnimation()
            self.spinner.startAnimating()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            let imageName = [UUID().uuidString, String(Int(Date().timeIntervalSince1970)*1000)].joined(separator: "-") + ".jpg"
            print("Insurance Image Name => \(imageName)")
            callUpdateInsuranceInfoSequence(imageURL: imageName, imageData: data, userId: userId, insuranceNumber: insurance_number, companyName: company_name, insuranceAmount: insurance_amount, issueDate: start_date, voidDate: end_date)
        }
    }
    internal func handleSuccess() {
        print("Handling Success")
        AssertionModalController(title: "Updated").show(on: self) {
            if !self.shouldPop {
                let vc = DriverDashboardVC()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
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
        AppData.userDetails = userDetails
        UserDefaults.saveDriverScope(isProfileSet: isProfileSet, isVehicleInfoSet: isVehicleInfoSet, isLicenseInfoSet: isLicenseInfoSet, isInsuranceInfoSet: isInsuranceInfoSet)
    }
    
    
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
        DispatchQueue.main.async {
            self.nextButton.isEnabled = true
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.spinner.stopAnimating()
                self.nextButton.alpha = 1.0
                self.nextButton.imageView?.layer.transform = CATransform3DIdentity
                self.nextButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    func initiateNextButtonTappedAnimation() {
        DispatchQueue.main.async {
            self.nextButton.isEnabled = false
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.nextButton.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                self.nextButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        }
    }
    
    internal func enableNextButton() {
        DispatchQueue.main.async {
            self.nextButton.isEnabled = true
            UIView.animate(withDuration: 0.4) {
                self.nextButton.alpha = 1.0
            }
        }
    }
    internal func disableNextButton() {
        DispatchQueue.main.async {
            self.nextButton.isEnabled = false
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
        guard let insurance_number = self.insuranceNumberTextField.text,
            let company_name = self.companyNameTextField.text,
            let insurance_amount = self.insuranceAmountTextField.text,
            let start_date = self.startDateTextField.text,
            let end_date = self.endDateTextField.text,
            !insurance_number.isEmpty, !company_name.isEmpty, !insurance_amount.isEmpty, !start_date.isEmpty, !end_date.isEmpty, isInsuranceImageSet else {
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
    
    private func uploadImage(_ image: UIImage) {
        
        guard let scaledImage = image.scaledToSafeUploadSize, let _ = scaledImage.jpegData(compressionQuality: 0.4) else {
            print("Unable to get scaled compressed image")
            return
        }
        
        
        let imageName = [UUID().uuidString, String(Int(Date().timeIntervalSince1970)*1000)].joined(separator: "-") + ".jpg"
        print("Image Name => \(imageName)")
        
        let alertVC = UIAlertController.customAlertController(title: "Uploading...")
        let margin:CGFloat = 8.0
        let alertVCWidth:CGFloat = 270.0
        print("Alert VC width => \(alertVCWidth)")
        
        
        
        let progress = Progress(totalUnitCount: 3)
        progress.completedUnitCount = 0
        let frame = CGRect(x: margin, y: 72.0, width: alertVCWidth - margin * 2.0 , height: 2.0)
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.frame = frame
        progressBar.progress = 0.0
        progressBar.progressTintColor = UIColor.blue
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print("Cancelling Upload")
            progress.cancel()
        }
        alertVC.addAction(cancelAction)
        alertVC.view.addSubview(progressBar)
        DispatchQueue.main.async {
            UIAlertController.presentAlert(alertVC, on: self)
        }
        progressBar.setProgress(0.0, animated: true)
        
        
        
        
        
        // 2
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            guard progress.isFinished == false else {
                timer.invalidate()
                self.insuranceImageView.image = scaledImage
                DispatchQueue.main.async {
                    alertVC.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            // 3
            progress.completedUnitCount += 1
            
            progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
            
            print("\(Int(progress.fractionCompleted * 100)) %")
        }
    }
}

extension DriverSignupVCForm5: UITextFieldDelegate {
    
}
extension DriverSignupVCForm5: UIScrollViewDelegate {
    
}
extension DriverSignupVCForm5: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.insuranceImageView.image = image
            self.isInsuranceImageSet = true
            
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.insuranceImageView.image = image
            self.isInsuranceImageSet = true
        } else {
            print("Unknown stuff")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
