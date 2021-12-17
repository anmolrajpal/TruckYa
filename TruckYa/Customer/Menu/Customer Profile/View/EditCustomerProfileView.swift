//
//  EditCustomerProfileView.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class EditCustomerProfileView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupTextFields()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        saveButton.layoutIfNeeded()
        saveButton.layer.cornerRadius = saveButton.frame.width / 2
    }
    internal func configureView(withCustomerDetails details:CustomerProfile) {
        nameTextField.text = details.name
        emailTextField.text = details.email
        phoneNumberTextField.text = details.phone
        addressTextField.text = details.address
        cityTextField.text = details.city
        stateTextField.text = details.state
        countryTextField.text = details.country
        zipCodeTextField.text = details.zipCode
    }
    fileprivate func setupViews() {
        backgroundImageView.addSubview(scrollView)
        addSubview(backgroundImageView)
        setupScrollViewSubviews()
    }
    fileprivate func setupConstraints() {
        backgroundImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        scrollView.anchor(top: backgroundImageView.safeAreaLayoutGuide.topAnchor, left: backgroundImageView.leftAnchor, bottom: backgroundImageView.bottomAnchor, right: backgroundImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //        scrollView.contentSize.width = frame.width
        setupScrollViewSubviewsConstraints()
    }
    fileprivate func setupScrollViewSubviews() {
        scrollView.addSubview(backButton)
        scrollView.addSubview(headingLabel)
        scrollView.addSubview(nameTextFieldContainerView)
        scrollView.addSubview(emailTextFieldContainerView)
        scrollView.addSubview(phoneNumberTextFieldContainerView)
        scrollView.addSubview(addressTextFieldContainerView)
        scrollView.addSubview(cityTextFieldContainerView)
        scrollView.addSubview(stateTextFieldContainerView)
        scrollView.addSubview(countryTextFieldContainerView)
        scrollView.addSubview(zipCodeTextFieldContainerView)
        saveButton.addSubview(spinner)
        scrollView.addSubview(saveButton)
        //        scrollView.addSubview(updateButton)
    }
    lazy var saveButtonSize:CGFloat = {
        let expectedTextSize = (saveButton.titleLabel!.text! as NSString).size(withAttributes: [.font: saveButton.titleLabel!.font!])
        let leftInset = saveButton.contentEdgeInsets.left
        let rightInset = saveButton.contentEdgeInsets.right
        let buttonSize = expectedTextSize.width + leftInset + rightInset + 10
        return buttonSize
    }()
    fileprivate func setupScrollViewSubviewsConstraints() {
        //        let padding:CGFloat = frame.width / 11
        //        let calculatedWidth:CGFloat = frame.width - (padding * 2)
        
        
        backButton.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 58, bottomConstant: 0, rightConstant: 58, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        
        let width:CGFloat = frame.width
        let height:CGFloat = 50
        
        nameTextFieldContainerView.anchor(top: headingLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        emailTextFieldContainerView.anchor(top: nameTextFieldContainerView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        phoneNumberTextFieldContainerView.anchor(top: emailTextFieldContainerView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        addressTextFieldContainerView.anchor(top: phoneNumberTextFieldContainerView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        cityTextFieldContainerView.anchor(top: addressTextFieldContainerView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        stateTextFieldContainerView.anchor(top: cityTextFieldContainerView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        countryTextFieldContainerView.anchor(top: stateTextFieldContainerView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        zipCodeTextFieldContainerView.anchor(top: countryTextFieldContainerView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        saveButton.anchor(top: zipCodeTextFieldContainerView.bottomAnchor, left: nil, bottom: scrollView.bottomAnchor, right: nil, topConstant: 40, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: saveButtonSize, heightConstant: saveButtonSize)
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        spinner.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor).activate()
        //        updateButton.anchor(top: zipCodeTextFieldContainerView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 50, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 80, heightConstant: 40)
    }
    let backgroundImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "pro_bg")
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    let scrollView:UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.isDirectionalLockEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    let backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    let headingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "EDIT PROFILE"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
        return label
    }()
    let saveButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("SAVE", for: UIControl.State.normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.contentMode = .scaleAspectFit
        let inset:CGFloat = 20
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 24)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        button.clipsToBounds = true
        button.isEnabled = false
        button.alpha = 0.4
        //        button.titleLabel?.adjustsFontSizeToFitWidth = true
        //        button.titleLabel?.sizeToFit()
        //        button.sizeToFit()
        return button
    }()
    let spinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        aiView.backgroundColor = .red
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.white
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    fileprivate func setupTextFields() {
        nameTextField.textContentType = .name
        emailTextField.keyboardType = .emailAddress
        emailTextField.textContentType = .emailAddress
        emailTextField.isEnabled = false
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.textContentType = .telephoneNumber
        addressTextField.setIcon(#imageLiteral(resourceName: "location-1").withRenderingMode(.alwaysTemplate), position: .Right, tintColor: .black)
        addressTextField.rightView!.layer.cornerRadius = addressTextField.rightView!.frame.height / 2
//        addressTextField.rightView!.backgroundColor = .white
//        addressTextField.rightView!.layer.shadowColor = UIColor.black.cgColor
//        addressTextField.rightView!.layer.shadowOpacity = 0.8
//        addressTextField.rightView!.layer.shadowRadius = 4
//        addressTextField.rightView!.layer.shadowOffset = CGSize.zero
//        addressTextField.rightView!.layer.masksToBounds = false
        addressTextField.rightView?.isUserInteractionEnabled = true
        
        addressTextField.textContentType = .fullStreetAddress
        cityTextField.textContentType = .addressCity
        stateTextField.textContentType = .addressState
        countryTextField.textContentType = .countryName
        zipCodeTextField.keyboardType = .numberPad
        zipCodeTextField.textContentType = .postalCode
        
        nameTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        stateTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        zipCodeTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
    }
    @objc fileprivate func didChangeTextField(textField:UITextField) {
        if let text = textField.text {
            if text.isEmpty {
                self.disableSaveButton()
            } else {
                self.validateFields()
            }
        } else { self.disableSaveButton() }
    }
    fileprivate func isDataValid() -> Bool {
        guard let name = self.nameTextField.text,
            let email = self.emailTextField.text,
            let phone_number = self.phoneNumberTextField.text,
            let address = self.addressTextField.text,
            let city = self.cityTextField.text,
            let state = self.stateTextField.text,
            let country = self.countryTextField.text,
            let zip_code = self.zipCodeTextField.text,
            !name.isEmpty, !email.isEmpty, !phone_number.isEmpty, !address.isEmpty, !city.isEmpty, !state.isEmpty, !country.isEmpty, !zip_code.isEmpty else {
                return false
        }
        return true
    }
    internal func validateFields() {
        isDataValid() ? enableSaveButton() : disableSaveButton()
    }
    func fallBackToIdentity(with result: APIResultStatus = .Error) {
        let generator = UINotificationFeedbackGenerator()
        switch result {
        case .Error: generator.notificationOccurred(.error)
        case .Success: generator.notificationOccurred(.success)
        }
        DispatchQueue.main.async {
            self.saveButton.isEnabled = true
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.spinner.stopAnimating()
                self.saveButton.alpha = 1.0
                self.saveButton.setTitle("SAVE", for: .normal)
                self.saveButton.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func initiateSaveButtonTappedAnimation() {
        DispatchQueue.main.async {
            self.saveButton.isEnabled = false
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.saveButton.setTitle("", for: .normal)
                self.saveButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        }
    }
    
    internal func enableSaveButton() {
        DispatchQueue.main.async {
            self.saveButton.isEnabled = true
            UIView.animate(withDuration: 0.4) {
                self.saveButton.alpha = 1.0
            }
        }
    }
    internal func disableSaveButton() {
        DispatchQueue.main.async {
            self.saveButton.isEnabled = false
            UIView.animate(withDuration: 0.4) {
                self.saveButton.alpha = 0.5
            }
        }
    }
    
    
    
    let nameTextField = createTextField(placeholder: "Name")
    let emailTextField = createTextField(placeholder: "Email")
    let phoneNumberTextField = createTextField(placeholder: "Tel. No.")
    let addressTextField = createTextField(placeholder: "Address")
    let cityTextField = createTextField(placeholder: "City")
    let stateTextField = createTextField(placeholder: "State")
    let countryTextField = createTextField(placeholder: "Country")
    let zipCodeTextField = createTextField(placeholder: "Zip Code")
    
    lazy var nameTextFieldContainerView = createTextFieldContainerView(labelTitle: "Name", nameTextField)
    lazy var emailTextFieldContainerView = createTextFieldContainerView(labelTitle: "Email", emailTextField)
    lazy var phoneNumberTextFieldContainerView = createTextFieldContainerView(labelTitle: "Tel. No.", phoneNumberTextField)
    lazy var addressTextFieldContainerView = createTextFieldContainerView(labelTitle: "Address", addressTextField)
    lazy var cityTextFieldContainerView = createTextFieldContainerView(labelTitle: "City", cityTextField)
    lazy var stateTextFieldContainerView = createTextFieldContainerView(labelTitle: "State", stateTextField)
    lazy var countryTextFieldContainerView = createTextFieldContainerView(labelTitle: "Country", countryTextField)
    lazy var zipCodeTextFieldContainerView = createTextFieldContainerView(labelTitle: "Zip Code", zipCodeTextField)
    
    
    
    
    
    
    
    let profileHeaderView = createHeaderView(title: "Profile")
    
    static func createTextField(placeholder:String? = nil) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 16)
        if let placeholderText = placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.gray])
        }
        textField.textColor = UIColor.black
        textField.textAlignment = .left
        textField.keyboardAppearance = .dark
        textField.borderStyle = .none
        return textField
    }
    
    
    func createTextFieldContainerView(labelTitle:String, _ textField:UITextField) -> UIView {
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelTitle
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: CustomFonts.gilroyRegular.rawValue, size: 15.0)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        let expectedTextSize = ("Zip Code" as NSString).size(withAttributes: [.font: label.font!])
        let width = expectedTextSize.width + 10
        
        let separator = Line()
        
        container.addSubview(label)
        container.addSubview(textField)
        container.addSubview(separator)
        
        label.anchor(top: nil, left: container.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: 0)
        label.centerYAnchor.constraint(equalTo: textField.centerYAnchor).activate()
        textField.anchor(top: container.topAnchor, left: label.rightAnchor, bottom: separator.topAnchor, right: container.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        separator.anchor(top: nil, left: textField.leftAnchor, bottom: container.bottomAnchor, right: textField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        return container
    }
    static func createHeaderView(title:String) -> UIView {
        let headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(1.0)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.darkText
        label.font = UIFont(name: CustomFonts.gilroyBlack.rawValue, size: 10.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        label.anchor(top: nil, left: headerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        return headerView
    }
    
}
