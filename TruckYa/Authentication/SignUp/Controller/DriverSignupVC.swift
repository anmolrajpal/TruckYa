//
//  DriverSignupVC.swift
//  TruckYa
//
//  Created by Anshul on 17/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
class DriverSignupVC: UIViewController {
    internal var signUpResult:SignUpCodable? {
        didSet {
            print(signUpResult as Any)
        }
    }
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTextFields()
        setupTextFieldsDelegates()
        scrollView.delegate = self
        scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y), animated: true)
        
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
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        phoneTextField.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
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
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(phoneTextField)
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
        nameTextField.anchor(top: driverImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: view.frame.height / 11, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: width, heightConstant: height)
        emailTextField.anchor(top: nameTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: nil, right: nameTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: nil, right: nameTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        phoneTextField.anchor(top: passwordTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: nil, right: nameTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        nextButton.anchor(top: phoneTextField.bottomAnchor, left: nil, bottom: scrollView.bottomAnchor, right: phoneTextField.rightAnchor, topConstant: 80, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 72, heightConstant: 72)
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
        label.text = "1/5"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    let spinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        aiView.backgroundColor = .white
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.red
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    lazy var nameTextField = createTextField(placeholder: "Name")
    lazy var emailTextField = createTextField(placeholder: "Email")
    lazy var passwordTextField = createTextField(placeholder: "Password")
    lazy var phoneTextField = createTextField(placeholder: "Tel Number")
    
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
        button.alpha = 0.5
        button.isEnabled = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    @objc func nextButtonTapped() {
        print("Next Button Tapped")
        //        let vc = DriverSignupVCForm2()
        //        navigationController?.pushViewController(vc, animated: true)
        initiateSignUpSeuquence()
    }
    func initiateSignUpSeuquence() {
        if let name = self.nameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let phoneNumber = self.phoneTextField.text,
            !name.isEmpty, !email.isEmpty, !password.isEmpty, !phoneNumber.isEmpty {
            self.view.endEditing(true)
            initiateNextButtonTappedAnimation()
            self.spinner.startAnimating()
            self.initiateSignUpSequence(name: name, email: email, password: password, phoneNumber: phoneNumber)
        }
    }
    func fallBackToIdentity() {
        self.nextButton.isEnabled = true
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.spinner.stopAnimating()
            self.nextButton.alpha = 1.0
            self.nextButton.imageView?.layer.transform = CATransform3DIdentity
            self.nextButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func initiateNextButtonTappedAnimation() {
        self.nextButton.isEnabled = false
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.nextButton.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            self.nextButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
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
        guard let name = self.nameTextField.text,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let phone = self.phoneTextField.text,
            !name.isEmpty, !email.isEmpty, email.isValidEmailAddress(), password.count >= 6, !phone.isEmpty else { return false }
        return true
    }
    fileprivate func validateFields() {
        if isDataValid() {
            enableNextButton()
        } else {
            disableNextButton()
        }
    }
    internal func enableNextButton() {
        nextButton.isEnabled = true
        UIView.animate(withDuration: 0.4) {
            self.nextButton.alpha = 1.0
        }
    }
    internal func disableNextButton() {
        nextButton.isEnabled = false
        UIView.animate(withDuration: 0.4) {
            self.nextButton.alpha = 0.5
        }
    }
    func setupTextFieldsBottomLayer() {
        let spaceY:CGFloat = -4
        nameTextField.blendBottomLine(spaceY: spaceY)
        emailTextField.blendBottomLine(spaceY: spaceY)
        passwordTextField.blendBottomLine(spaceY: spaceY)
        phoneTextField.blendBottomLine(spaceY: spaceY)
    }
    func setupTextFields() {
        
        nameTextField.textContentType = .name
        nameTextField.keyboardType = .namePhonePad
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
        
        phoneTextField.textContentType = .telephoneNumber
        phoneTextField.keyboardType = .phonePad
        
        nameTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        
        
    }
    
    
    
    internal func handleUserState(with userDetails:SignUpCodable.Datum.User) {
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
        print("UserType String Driver=> \(userType)")
        guard let userTYPE = UserType(rawValue: userType) else {
            print("API Internal Error: Invalid Data => Unknown UserType")
            let alertview = JSSAlertView().show(self,
                                                title: "Error",
                                                text: "User type mismatched. Please contact Truc-Ya! to resolve your issue",
                                                buttonText: "OK",
                                                color: UIColorFromHex(0xE6131E, alpha: 1),
                                                iconImage: UIImage(named: "oho"))
            alertview.setTextTheme(.light)
            alertview.addAction({
                self.fallBackToIdentity()
            })
            return
        }
        print("Driver Signup VC USerType Response => \(userTYPE)")
        let vc:UIViewController
        let isProfileSet = userDetails.isprofileset ?? false,
        isVehicleInfoSet = userDetails.isvehicleinfoset ?? false,
        isLicenseInfoSet = userDetails.islisenseinfoset ?? false,
        isInsuranceInfoSet = userDetails.isinsuranceinfoset ?? false
        UserDefaults.saveDriverScope(isProfileSet: isProfileSet, isVehicleInfoSet: isVehicleInfoSet, isLicenseInfoSet: isLicenseInfoSet, isInsuranceInfoSet: isInsuranceInfoSet)
        let driverScope = DriverScope.getDriverScope(isProfileSet: isProfileSet, isVehicleInfoSet: isVehicleInfoSet, isLicenseInfoSet: isLicenseInfoSet, isInsuranceInfoSet: isInsuranceInfoSet)
        switch driverScope {
        case .Dashboard :
            print("Redirect to Driver Dashboard")
            vc = DriverDashboardVC()
        case .Profile:
            print("Redirect to Driver Profile setup")
            let VC = DriverSignupVCForm2()
            VC.shouldHideBackButton = true
            vc = VC
        case .Vehicle:
            print("Redirect to Vehicle Info Setup")
            let VC = DriverSignupVCForm3()
            VC.shouldHideBackButton = true
            vc = VC
        case .License:
            print("Redirect to License Info Setup")
            let VC = DriverSignupVCForm4()
            VC.shouldHideBackButton = true
            vc = VC
        case .Insurance:
            print("Redirect to Insurance Info Setup")
            let VC = DriverSignupVCForm5()
            VC.shouldHideBackButton = true
            vc = VC
        }
        UserDefaults.standard.userType = userTYPE
        UserDefaults.saveUserDetails(details: userDetails)
        UserDefaults.standard.isLoggedIn = true
        self.fallBackToIdentity()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
}
extension DriverSignupVC: UIScrollViewDelegate {
    
}
extension DriverSignupVC: UITextFieldDelegate {
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
