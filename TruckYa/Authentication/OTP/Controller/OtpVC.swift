//
//  OtpVC.swift
//  TruckYa
//
//  Created by Anshul on 19/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class OtpVC: UIViewController {
    
    var email:String!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupOTPFieldsStackView()
        setupOTPTextFields()
        self.otpTextField1.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationsObservers()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
        nextButton.layoutIfNeeded()
        nextButton.layer.cornerRadius = nextButton.frame.size.width / 2.0
        setupOTPTextFieldsBorderLayer()
    }
    func setupOTPTextFieldsBorderLayer() {
        blendBottomLine(below: otpTextField1)
        blendBottomLine(below: otpTextField2)
        blendBottomLine(below: otpTextField3)
        blendBottomLine(below: otpTextField4)
    }
    func blendBottomLine(below textField:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 3, y: textField.frame.height - 2, width: textField.frame.width / 1.25, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.layer.addSublayer(bottomLine)
    }
    @IBAction func hendleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func setupViews() {
        scrollView.addSubview(otpFieldsStackView)
        scrollView.addSubview(errorLabel)
        nextButton.addSubview(spinner)
        scrollView.addSubview(nextButton)
    }
    func setupConstraints() {
        let padding:CGFloat = self.view.frame.width / 3
        otpFieldsStackView.anchor(top: descriptionLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 20, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: 0, heightConstant: 0)
        errorLabel.anchor(top: otpFieldsStackView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 15, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        nextButton.anchor(top: errorLabel.bottomAnchor, left: nil, bottom: nil, right: scrollView.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 30, rightConstant: 24, widthConstant: 72, heightConstant: 72)
        spinner.centerXAnchor.constraint(equalTo: nextButton.centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).activate()
    }
    let nextButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "red_arrow"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let inset:CGFloat = 20
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.backgroundColor = UIColor.black
        button.alpha = 0.5
        button.isEnabled = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    @objc func nextButtonTapped() {
        print("Next Button Tapped")
        verifyOTP()
    }
    fileprivate func verifyOTP() {
        let otp = otpTextField1.text! + otpTextField2.text! + otpTextField3.text! + otpTextField4.text!
        print("OTP Entered is => \(otp)")
        self.view.endEditing(true)
        initiateNextButtonTappedAnimation()
        self.spinner.startAnimating()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        self.callVerifyOTPSequence(for: email, with: otp)
    }
    let errorLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.textAlignment = .center
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 15)
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    internal func handleSuccess(forUserWithID userId:String) {
        print("Handling Success")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
        vc?.userID = userId
        navigationController?.pushViewController(vc!, animated: true)
    }
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
            case .Error: generator.notificationOccurred(.error)
            case .Success: generator.notificationOccurred(.success)
        }
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.spinner.stopAnimating()
            self.nextButton.imageView?.layer.transform = CATransform3DIdentity
            self.nextButton.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    func initiateNextButtonTappedAnimation() {
        self.nextButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.nextButton.imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
                self.nextButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
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
    internal func handleValidationSequence(isOTPLengthValid:Bool) {
        isOTPLengthValid ? enableNextButton() : disableNextButton()
    }

    
    func handleInvalidOTPState() {
        self.shakeStackView()
        self.getAllTextFields(fromView: self.scrollView).forEach({ $0.text = "" })
        self.otpTextField1.becomeFirstResponder()
        disableNextButton()
    }
    func shakeStackView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: otpFieldsStackView.center.x - 10, y: otpFieldsStackView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: otpFieldsStackView.center.x + 10, y: otpFieldsStackView.center.y))
        otpFieldsStackView.layer.add(animation, forKey: "position")
    }
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
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
    
    
    
    let otpTextField1:UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22.0)!
        textField.textAlignment = .center
        textField.widthAnchor.constraint(equalToConstant: 30.0).activate()
        textField.heightAnchor.constraint(equalToConstant: 40.0).activate()
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let otpTextField2:UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.widthAnchor.constraint(equalToConstant: 30.0).activate()
        textField.heightAnchor.constraint(equalToConstant: 40.0).activate()
        textField.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22.0)!
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let otpTextField3:UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.widthAnchor.constraint(equalToConstant: 30.0).activate()
        textField.heightAnchor.constraint(equalToConstant: 40.0).activate()
        textField.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22.0)!
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    let otpTextField4:UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.widthAnchor.constraint(equalToConstant: 30.0).activate()
        textField.heightAnchor.constraint(equalToConstant: 40.0).activate()
        textField.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22.0)!
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    @objc func otpTextFieldsDidChange(textField:UITextField) {
        let text = textField.text!
        let char = text.cString(using: String.Encoding.utf8)
        let isBackSpace = strcmp(char, "\\b")
        let isBackSpacePressed:Bool = isBackSpace == -92
        if text.count == 1 {
            switch textField {
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField4.resignFirstResponder()
//                self.verifyOTP()
            default:
                break
            }
        }
        if text.count == 0 || isBackSpacePressed {
            print("here count = \(text.count)")
            print(isBackSpacePressed)
            
            switch textField{
            case otpTextField1:
                otpTextField1.becomeFirstResponder()
            case otpTextField2:
                otpTextField1.becomeFirstResponder()
            case otpTextField3:
                otpTextField2.becomeFirstResponder()
            case otpTextField4:
                otpTextField3.becomeFirstResponder()
            default:
                break
            }
        } else {
            print("Unexpected Case to handle for textField: \(textField) with text=> \(String(describing: text))")
        }
        let check:Bool = (otpTextField1.text?.count == 1) && (otpTextField2.text?.count == 1) && (otpTextField3.text?.count == 1) && (otpTextField4.text?.count == 1)
        handleValidationSequence(isOTPLengthValid: check)
    }
    func setupOTPTextFields() {
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self
        
        otpTextField1.addTarget(self, action: #selector(otpTextFieldsDidChange), for: .editingChanged)
        otpTextField2.addTarget(self, action: #selector(otpTextFieldsDidChange), for: .editingChanged)
        otpTextField3.addTarget(self, action: #selector(otpTextFieldsDidChange), for: .editingChanged)
        otpTextField4.addTarget(self, action: #selector(otpTextFieldsDidChange), for: .editingChanged)
    }
    
    
    let otpFieldsStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    func setupOTPFieldsStackView() {
        otpFieldsStackView.addArrangedSubview(otpTextField1)
        otpFieldsStackView.addArrangedSubview(otpTextField2)
        otpFieldsStackView.addArrangedSubview(otpTextField3)
        otpFieldsStackView.addArrangedSubview(otpTextField4)
    }
    
    
    
    
    
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
extension OtpVC: UITextFieldDelegate {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        // Default
        return super.canPerformAction(action, withSender: sender)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 1
    }
}
