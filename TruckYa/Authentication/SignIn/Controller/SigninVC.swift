//
//  SigninVC.swift
//  TruckYa
//
//  Created by Anshul on 17/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
import SkyFloatingLabelTextField
import FlagPhoneNumber
class SigninVC: UIViewController {
    internal var signInResult:UserResponseCodable? {
        didSet {
            print(signInResult as Any)
        }
    }
    var correctOTP:String = "1234"
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signinButton: RoundButton!
    @IBOutlet weak var signinCardView: CardView!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var redArrowImageView: UIImageView!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var usertype:UserType!
    override func loadView() {
        super.loadView()
        setupViews()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        checkAuthState()
    }
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn
    }
    fileprivate func checkAuthState() {
        if self.isLoggedIn() {
            guard let userType:UserType = UserDefaults.standard.userType else { return }
            print("Init Check User Type => \(userType)")
//            self.navigationController?.pushViewController(userType == .Customer ? CustomerDashboardVC() : DriverDashboardVC(), animated: false)
            self.initUserState(by: userType)
        }
    }
    internal func initUserState(by userType:UserType) {
        let vc:UIViewController
        if userType == .Driver {
            let driverScope = DriverScope.getDriverScope()
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
        } else {
            let customerScope = CustomerScope.getCustomerScope()
            switch customerScope {
            case .Dashboard:
                print("Redirect to Customer Dashboard")
                vc = CustomerDashboardVC()
                
                
            case .Profile:
                print("Redirect to Customer Profile setup")
                let VC = CustomerSignupVCForm2()
                VC.shouldHideBackButton = true
                vc = VC
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFutureSaviourViews()
        setupEmailTextField()
        setupPasswordTextField()
        checkAuthState()
        signinButton.isEnabled = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
   
    func blendBottomLine(below textField:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 3, y: textField.frame.height - 2, width: textField.frame.width / 1.25, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @IBAction func hendleBack(_ sender: Any) {
        print("Trying to pop")
        navigationController?.popViewController(animated: true)
    }

    @IBAction func handleSignUp(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverSignupVC") as? DriverSignupVC
        navigationController?.pushViewController(vc!, animated: true)
    }

    @IBAction func handleForgotPassword(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    func setupViews() {
        signinCardView.addSubview(spinner)
        scrollView.addSubview(numberTextField)
    }
    func setupConstraints() {
        numberTextField.anchor(top: welcomeLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 10, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
        spinner.centerXAnchor.constraint(equalTo: signinCardView.centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: signinCardView.centerYAnchor).activate()
    }
    
    
    let spinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        aiView.backgroundColor = .black
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.red
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    
    
    
   
    func fallBackToIdentity() {
        
        UIView.animate(withDuration: 0.3) {
            self.spinner.stopAnimating()
            self.signinCardView.alpha = 1.0
            self.redArrowImageView.alpha = 1.0
            self.signinCardView.transform = CGAffineTransform.identity
            self.redArrowImageView.transform = CGAffineTransform.identity
        }
        
    }
    func initiateLoginButtonTappedAnimation() {
        UIView.animate(withDuration: 0.4) {
            
            self.signinCardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.redArrowImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
 
    
    var isEmailValid = false
    var isPasswordValid = false
    func setupEmailTextField() {
        emailTF.returnKeyType = .next
        emailTF.addTarget(self, action: #selector(emailTextFieldDidReturn(textField:)), for: .editingDidEndOnExit)
        emailTF.addTarget(self, action: #selector(emailTextFieldDidChange(textField:)), for: .editingChanged)
    }
    func setupPasswordTextField() {
//        passwordTF.returnKeyType = .
        passwordTF.addTarget(self, action: #selector(passwordTextFieldDidReturn(textField:)), for: .editingDidEndOnExit)
        passwordTF.addTarget(self, action: #selector(passwordFieldDidChange(textField:)), for: .editingChanged)
    }
    @objc func emailTextFieldDidReturn(textField:UITextField) {
        self.passwordTF.becomeFirstResponder()
    }
    @objc func passwordTextFieldDidReturn(textField:UITextField) {
        textField.resignFirstResponder()
//        self.initiateLoginSequence()
    }
    @objc func emailTextFieldDidChange(textField:UITextField!) {
        let emailId = textField.text
        isEmailValid = emailId?.isValidEmailAddress() ?? false
        handleValidationSequence(email: isEmailValid, password: isPasswordValid)
    }
    @objc func passwordFieldDidChange(textField:UITextField!) {
        if let password = textField.text {
            isPasswordValid = password.count >= 6
            handleValidationSequence(email: isEmailValid, password: isPasswordValid)
        }
    }
    internal func handleValidationSequence(email:Bool, password:Bool) {
        signinButton.isEnabled = email && password
        signinCardView.alpha = signinButton.isEnabled ? 1.0 : 0.3
    }
    func initiateLoginSequence() {
        if let email = self.emailTF.text,
            let password = self.passwordTF.text,
            !email.isEmpty, !password.isEmpty {
            self.view.endEditing(true)
            self.signinCardView.alpha = 1.0
            redArrowImageView.alpha = 0.0
            initiateLoginButtonTappedAnimation()
            self.spinner.startAnimating()
            initiateSignInSequence(email:email, password:password)
        }
    }
    let numberTextField:FPNTextField = {
        let textField = FPNTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "201-555-0123", attributes: [NSAttributedString.Key.font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22.0)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = UIColor.black
        textField.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22.0)!
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 15
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(numberFieldDidChange(textField:)), for: .editingChanged)
        return textField
    }()
    @objc func numberFieldDidChange(textField:UITextField) {
//        let isPhoneNumberValid = textField.text?.isPhoneNumberLengthValid() ?? false
//        handleValidationSequence(isValidPhoneNumber: isPhoneNumberValid)
//        if textField.text?.count == 12 {
//            textField.resignFirstResponder()
//        }
    }
    
    func handleUserType(type:UserType) {
        switch type {
        case .Driver: setupDriverTextFields()
        case .Customer: setupRiderTextFields()
        }
    }
    func setupFutureSaviourViews() {
        emailTF.isEnabled = true
        passwordTF.isEnabled = true
        emailTF.isHidden = false
        passwordTF.isHidden = false
        numberTextField.isHidden = true
        numberTextField.isEnabled = false
        signupButton.isHidden = false
        signupButton.isEnabled = true
        forgotPasswordButton.isHidden = false
        forgotPasswordButton.isEnabled = true
    }
    func setupDriverTextFields() {
        emailTF.isEnabled = true
        passwordTF.isEnabled = true
        emailTF.isHidden = false
        passwordTF.isHidden = false
        numberTextField.isHidden = true
        numberTextField.isEnabled = false
        signupButton.isHidden = false
        signupButton.isEnabled = true
        forgotPasswordButton.isHidden = false
        forgotPasswordButton.isEnabled = true
    }
    func setupRiderTextFields() {
        emailTF.isEnabled = false
        passwordTF.isEnabled = false
        emailTF.isHidden = true
        passwordTF.isHidden = true
        numberTextField.isHidden = false
        numberTextField.isEnabled = true
        signupButton.isHidden = true
        signupButton.isEnabled = false
        forgotPasswordButton.isHidden = true
        forgotPasswordButton.isEnabled = false
    }
    @IBAction func handleSignIn(_ sender: Any) {
//        AssertionModalController(title: "Updated").show(on: self, completion: nil)
        self.initiateLoginSequence()
    }
    func signIn() {
        if let email = self.emailTF.text,
            let password = self.passwordTF.text,
            !email.isEmpty, !password.isEmpty {
            self.view.endEditing(true)
            self.signinCardView.alpha = 1.0
            redArrowImageView.alpha = 0.0
            initiateLoginButtonTappedAnimation()
            self.spinner.startAnimating()
            initiateSignInSequence(email:email, password:password)
        }
    }
    func riderSignIn() {
        if let text = self.numberTextField.text,
            !text.isEmpty {
            var mobileNumber = text
            mobileNumber.removeAll(where: {$0 == "-"})
            print("mobileNumber = \(mobileNumber)")
            self.numberTextField.resignFirstResponder()
            self.signinCardView.alpha = 1.0
            redArrowImageView.alpha = 0.0
            initiateLoginButtonTappedAnimation()
            self.spinner.startAnimating()
//            initiateRiderSignInSignUpSequence(for: mobileNumber)
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
        print("User Type v1 = > \(userTYPE)")
        let vc:UIViewController
        if userTYPE == .Driver {
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
                vc = DriverSignupVCForm2()
            case .Vehicle:
                print("Redirect to Vehicle Info Setup")
                vc = DriverSignupVCForm3()
            case .License:
                print("Redirect to License Info Setup")
                vc = DriverSignupVCForm4()
            case .Insurance:
                print("Redirect to Insurance Info Setup")
                vc = DriverSignupVCForm5()
            }
        } else {
            let isProfileSet = userDetails.isprofileset ?? false
            UserDefaults.saveCustomerScope(isProfileSet: isProfileSet)
            let customerScope = CustomerScope.getCustomerScope(isProfileSet: isProfileSet)
            switch customerScope {
            case .Dashboard:
                print("Redirect to Customer Dashboard")
                vc = CustomerDashboardVC()
                
            case .Profile:
                print("Redirect to Customer Profile setup")
                let VC = CustomerSignupVCForm2()
                VC.shouldHideBackButton = true
                vc = VC
            }
        }
        AppData.userDetails = userDetails
        UserDefaults.standard.userType = userTYPE
        UserDefaults.saveUserDetails(details: userDetails)
        UserDefaults.standard.isLoggedIn = true
        self.fallBackToIdentity()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension SigninVC:UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.text = ""
//    }
}
