//
//  ForgotPasswordVC.swift
//  TruckYa
//
//  Created by Anshul on 19/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class ForgotPasswordVC: UIViewController {
    
    var correctOTP:String = "1234"
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var inputTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var verifyLabel: UILabel!
    
    
    
    override func loadView() {
        super.loadView()
        
        //        setupConstraints()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEmailTextField()
        //        setupOTPFieldsStackView()
        //        setupOTPTextFieldsDelegates()
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
        nextButton.addSubview(spinner)
        scrollView.addSubview(nextButton)
    }
    func setupConstraints() {
        nextButton.anchor(top: nil, left: nil, bottom: nil, right: inputTextField.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 72, heightConstant: 72)
        nextButton.centerYAnchor.constraint(equalTo: verifyLabel.centerYAnchor).activate()
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
        initiateForgotPasswordSequence()
    }
    fileprivate func initiateForgotPasswordSequence() {
        if let email = self.inputTextField.text,
            !email.isEmpty {
            self.view.endEditing(true)
            initiateNextButtonTappedAnimation()
            self.spinner.startAnimating()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            self.callForgotPasswordSequence(for: email)
        }
    }
    internal func handleSuccess() {
        print("Handling Success")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OtpVC") as? OtpVC
        vc?.email = self.inputTextField.text!
        navigationController?.pushViewController(vc!, animated: true)
    }
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
            case .Error: generator.notificationOccurred(.error)
            case .Success: generator.notificationOccurred(.success)
        }
        self.nextButton.isEnabled = true
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
    var isEmailValid = false
    func setupEmailTextField() {
        inputTextField.addTarget(self, action: #selector(emailTextFieldDidChange(textField:)), for: .editingChanged)
    }
    
    
    @objc func emailTextFieldDidChange(textField:UITextField!) {
        let emailId = textField.text
        isEmailValid = emailId?.isValidEmailAddress() ?? false
        handleValidationSequence(email: isEmailValid)
    }
    internal func handleValidationSequence(email:Bool) {
        email ? enableNextButton() : disableNextButton()
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
extension ForgotPasswordVC: UITextFieldDelegate {
    
}
