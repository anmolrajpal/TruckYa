//
//  DriverProfileView.swift
//  TruckYa
//
//  Created by Digit Bazar on 21/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class DriverProfileView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageContainerView.layoutIfNeeded()
        profileImageContainerView.layer.cornerRadius = profileImageContainerView.frame.width / 2
        truckDetailsButton.layer.cornerRadius = 10
        licenseDetailsButton.layer.cornerRadius = 10
        insuranceDetailsButton.layer.cornerRadius = 10
    }
    var profileImageURL:String? {
        didSet {
            if let urlStr = profileImageURL {
                let completeURL:String = Config.EndpointConfig.baseURL + "/" + urlStr
                self.profileImageView.loadImageUsingCacheWithURLString(completeURL, placeHolder: #imageLiteral(resourceName: "driver"))
//                UserDefaults.standard.userProfilePicURL = urlStr
            } else {
                self.profileImageView.loadImageUsingCacheWithURLString(nil, placeHolder: #imageLiteral(resourceName: "driver"))
            }
        }
    }
    var name:String? {
        didSet {
            nameLabel.text = name
        }
    }
    var email:String? {
        didSet {
            emailLabel.text = email
        }
    }
    var phoneNumber:String? {
        didSet {
            phoneLabel.text = phoneNumber
        }
    }
    var address:String? {
        didSet {
            addressLabel.text = address
        }
    }
    var city:String? {
        didSet {
            cityLabel.text = city
        }
    }
    var state:String? {
        didSet {
            stateLabel.text = state
        }
    }
    var country:String? {
        didSet {
            countryLabel.text = country
        }
    }
    var postalCode:String? {
        didSet {
            postalCodeLabel.text = postalCode
        }
    }
    var driverDescription:String? {
        didSet {
            descriptionLabel.text = driverDescription
        }
    }
    
    
    
    
    
    
    
    fileprivate func setupViews() {
        backgroundImageView.addSubview(scrollView)
        addSubview(backgroundImageView)
        setupScrollViewSubviews()
    }
    fileprivate func setupConstraints() {
        backgroundImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        scrollView.anchor(top: backgroundImageView.safeAreaLayoutGuide.topAnchor, left: backgroundImageView.leftAnchor, bottom: backgroundImageView.bottomAnchor, right: backgroundImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        setupScrollViewSubviewsConstraints()
    }
    let scrollView:UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.indicatorStyle = UIScrollView.IndicatorStyle.white
        view.isDirectionalLockEnabled = true
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    func setupScrollViewSubviews() {
        scrollView.addSubview(backButton)
        scrollView.addSubview(headingLabel)
        scrollView.addSubview(editButton)
        scrollView.addSubview(profileImageContainerView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(nameLabel)
//        scrollView.addSubview(horizontalLine)
        scrollView.addSubview(emailLabelContainerView)
        scrollView.addSubview(phoneLabelContainerView)
        scrollView.addSubview(addressLabelContainerView)
        scrollView.addSubview(cityLabelContainerView)
        scrollView.addSubview(stateLabelContainerView)
        scrollView.addSubview(countryLabelContainerView)
        scrollView.addSubview(postalCodeLabelContainerView)
        scrollView.addSubview(descriptionLabelContainerView)
        scrollView.addSubview(truckDetailsButton)
        scrollView.addSubview(licenseDetailsButton)
        scrollView.addSubview(insuranceDetailsButton)
    }
    func setupScrollViewSubviewsConstraints() {
        
        backButton.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 58, bottomConstant: 0, rightConstant: 58, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        editButton.anchor(top: nil, left: nil, bottom: nil, right: scrollView.rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 32, heightConstant: 24)
        editButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor).activate()
        
        let imageSize:CGFloat = frame.width / 2.8
        profileImageContainerView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 30).activate()
        profileImageContainerView.widthAnchor.constraint(equalToConstant: imageSize - 4).activate()
        profileImageContainerView.heightAnchor.constraint(equalToConstant: imageSize - 4).activate()
        profileImageContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).activate()
        
        profileImageView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 30).activate()
        profileImageView.widthAnchor.constraint(equalToConstant: imageSize - 3).activate()
        profileImageView.heightAnchor.constraint(equalToConstant: imageSize - 3).activate()
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).activate()
        
        profileImageContainerView.transform = CGAffineTransform(translationX: 3, y: 6)
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        
//        let padding = frame.width / 11
//        let width = frame.width - (padding * 2)
        let width = frame.width
        let height:CGFloat = 0
//        let dateTFWidth:CGFloat = (width / 2) - 10
        
        
//        horizontalLine.anchor(top: nameLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 45, leftConstant: 56, bottomConstant: 0, rightConstant: 56, widthConstant: 0, heightConstant: 0.9)
        emailLabelContainerView.anchor(top: nameLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 25, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: height)
        phoneLabelContainerView.anchor(top: emailLabelContainerView.bottomAnchor, left: emailLabelContainerView.leftAnchor, bottom: nil, right: emailLabelContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        addressLabelContainerView.anchor(top: phoneLabelContainerView.bottomAnchor, left: emailLabelContainerView.leftAnchor, bottom: nil, right: emailLabelContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        cityLabelContainerView.anchor(top: addressLabelContainerView.bottomAnchor, left: emailLabelContainerView.leftAnchor, bottom: nil, right: emailLabelContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        stateLabelContainerView.anchor(top: cityLabelContainerView.bottomAnchor, left: emailLabelContainerView.leftAnchor, bottom: nil, right: emailLabelContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        countryLabelContainerView.anchor(top: stateLabelContainerView.bottomAnchor, left: emailLabelContainerView.leftAnchor, bottom: nil, right: emailLabelContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        postalCodeLabelContainerView.anchor(top: countryLabelContainerView.bottomAnchor, left: emailLabelContainerView.leftAnchor, bottom: nil, right: emailLabelContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        descriptionLabelContainerView.anchor(top: postalCodeLabelContainerView.bottomAnchor, left: emailLabelContainerView.leftAnchor, bottom: nil, right: emailLabelContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        let expectedTextSize = (insuranceDetailsButton.titleLabel!.text! as NSString).size(withAttributes: [.font: insuranceDetailsButton.titleLabel!.font!])
        let topInset = insuranceDetailsButton.contentEdgeInsets.top
        let leftInset = insuranceDetailsButton.contentEdgeInsets.left
        let rightInset = insuranceDetailsButton.contentEdgeInsets.right
        let bottomInset = insuranceDetailsButton.contentEdgeInsets.bottom
        let buttonHeight = expectedTextSize.height + topInset + bottomInset
        let buttonWidth = expectedTextSize.width + leftInset + rightInset + 5
        
        
        truckDetailsButton.anchor(top: descriptionLabelContainerView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: buttonHeight)
        truckDetailsButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).activate()
        licenseDetailsButton.anchor(top: truckDetailsButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: buttonWidth, heightConstant: buttonHeight)
        licenseDetailsButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).activate()
        insuranceDetailsButton.anchor(top: licenseDetailsButton.bottomAnchor, left: nil, bottom: scrollView.bottomAnchor, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 40, rightConstant: 0, widthConstant: buttonWidth, heightConstant: buttonHeight)
        insuranceDetailsButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).activate()
        
    }
    
    /*
    fileprivate func setupContainerImageView() {
        containerImageView.addSubview(backButton)
        containerImageView.addSubview(headingLabel)
        containerImageView.addSubview(editButton)
        containerImageView.addSubview(profileImageContainerView)
        containerImageView.addSubview(profileImageView)
        containerImageView.addSubview(nameLabel)
        containerImageView.addSubview(horizontalLine)
        containerImageView.addSubview(emailLabel)
        containerImageView.addSubview(phoneLabel)
    }
    fileprivate func setupContainerImageViewConstraints() {
        backButton.anchor(top: containerImageView.topAnchor, left: containerImageView.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 0, leftConstant: 58, bottomConstant: 0, rightConstant: 58, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        editButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 32, heightConstant: 24)
        let imageSize:CGFloat = frame.width / 2.8
        profileImageContainerView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 30).activate()
        profileImageContainerView.widthAnchor.constraint(equalToConstant: imageSize - 4).activate()
        profileImageContainerView.heightAnchor.constraint(equalToConstant: imageSize - 4).activate()
        profileImageContainerView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).activate()
        
        profileImageView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 30).activate()
        profileImageView.widthAnchor.constraint(equalToConstant: imageSize - 3).activate()
        profileImageView.heightAnchor.constraint(equalToConstant: imageSize - 3).activate()
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).activate()
        
        profileImageContainerView.transform = CGAffineTransform(translationX: 3, y: 6)
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        
        horizontalLine.anchor(top: nameLabel.bottomAnchor, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 45, leftConstant: 56, bottomConstant: 0, rightConstant: 56, widthConstant: 0, heightConstant: 0.9)
        emailLabel.anchor(top: horizontalLine.bottomAnchor, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 45, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        phoneLabel.anchor(top: emailLabel.bottomAnchor, left: emailLabel.leftAnchor, bottom: nil, right: emailLabel.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
     */
    let truckDetailsButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Truck Details", for: UIControl.State.normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.contentMode = .scaleAspectFit
        let xInset:CGFloat = 20
        let yInset:CGFloat = 10
        button.contentEdgeInsets = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15)
        return button
    }()
    let licenseDetailsButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("License Details", for: UIControl.State.normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.contentMode = .scaleAspectFit
        let xInset:CGFloat = 20
        let yInset:CGFloat = 10
        button.contentEdgeInsets = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15)
        return button
    }()
    let insuranceDetailsButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Insurance Details", for: UIControl.State.normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.contentMode = .scaleAspectFit
        let xInset:CGFloat = 20
        let yInset:CGFloat = 10
        button.contentEdgeInsets = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15)
        return button
    }()
    let backgroundImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "pro_bg")
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
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
    let editButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "edit_img").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    let headingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PROFILE"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
        return label
    }()
    let profileImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "football")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    let profileImageContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Allen Cooper"
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 24.0)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    let horizontalLine = Line(color: .black, opacity: 0.9)
    let emailLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        label.textAlignment = .left
        return label
    }()
    let phoneLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        return label
    }()
    let addressLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        return label
    }()
    let cityLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        return label
    }()
    let stateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        return label
    }()
    let countryLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        return label
    }()
    let postalCodeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        return label
    }()
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        return label
    }()
    
    lazy var emailLabelContainerView = createLabelContainerView(title: "Email", valueLabel: emailLabel)
    lazy var phoneLabelContainerView = createLabelContainerView(title: "Tel. No.", valueLabel: phoneLabel)
    lazy var addressLabelContainerView = createLabelContainerView(title: "Address", valueLabel: addressLabel)
    lazy var cityLabelContainerView = createLabelContainerView(title: "City", valueLabel: cityLabel)
    lazy var stateLabelContainerView = createLabelContainerView(title: "State", valueLabel: stateLabel)
    lazy var countryLabelContainerView = createLabelContainerView(title: "Country", valueLabel: countryLabel)
    lazy var postalCodeLabelContainerView = createLabelContainerView(title: "Postal Code", valueLabel: postalCodeLabel)
    lazy var descriptionLabelContainerView = createLabelContainerView(title: "About", valueLabel: descriptionLabel)
    
    func createLabelContainerView(title:String, valueLabel:UILabel) -> UIView {
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
//        container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        container.backgroundColor = .clear
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 14.0)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        let expectedTextSize = ("Postal Code" as NSString).size(withAttributes: [.font: titleLabel.font!])
        let width = expectedTextSize.width + 10
    
        let separator = Line()
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        container.addSubview(separator)
        
        titleLabel.anchor(top: nil, left: container.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: 0)
        titleLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor).activate()
        valueLabel.anchor(top: container.topAnchor, left: titleLabel.rightAnchor, bottom: separator.topAnchor, right: container.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 15, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        separator.anchor(top: nil, left: valueLabel.leftAnchor, bottom: container.bottomAnchor, right: valueLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        return container
    }
    /*
    func createLabelContainerView(title:String, value:String) -> UIView {
        let container = UIView(frame: CGRect.zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
//        container.backgroundColor = .clear
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 17.0)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        
        let expectedTextSize = ("Zip Code" as NSString).size(withAttributes: [.font: titleLabel.font!])
        let width = expectedTextSize.width + 10
    
        let separator = Line()
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = value
        valueLabel.textColor = UIColor.black
        valueLabel.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15.0)
        valueLabel.textAlignment = .left
        valueLabel.numberOfLines = 1
        
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        container.addSubview(separator)
        
        titleLabel.anchor(top: nil, left: container.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: width, heightConstant: 0)
        titleLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor).activate()
        valueLabel.anchor(top: container.topAnchor, left: titleLabel.rightAnchor, bottom: separator.topAnchor, right: container.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        separator.anchor(top: nil, left: valueLabel.leftAnchor, bottom: container.bottomAnchor, right: valueLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        return container
    }
    func setupLabel(_ label:UILabel, title: String, value:String) {
        let titleAttributedString = NSAttributedString(string: title, attributes: [
            .font : UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 17)!,
            .foregroundColor: UIColor.black
        ])
        let valueAttributedString = NSAttributedString(string: title, attributes: [
            .font : UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15)!,
            .foregroundColor: UIColor.black
        ])
        let attributedString = NSMutableAttributedString()
        attributedString.append(titleAttributedString)
        attributedString.append(valueAttributedString)
        label.attributedText = attributedString
    }
    */
}
