//
//  MapSubview.swift
//  TruckYa
//
//  Created by Digit Bazar on 28/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import GoogleMaps
import MTSlideToOpen

enum CustomerSliderOption { case CancelRide, MakePayment }

protocol CustomerSliderViewDelegate {
    func didSlide(with option: CustomerSliderOption)
}

class MapSubview: UIView, MTSlideToOpenDelegate {
    var delegate:CustomerSliderViewDelegate?
    internal let popupOffset: CGFloat = 250
    internal var bottomConstraint = NSLayoutConstraint()
    internal var truckImageURLString: String? {
        didSet {
            if let urlStr = truckImageURLString {
                let completeURL:String = Config.EndpointConfig.baseURL + "/" + urlStr
                self.truckImageView.loadImageUsingCacheWithURLString(completeURL, placeHolder: #imageLiteral(resourceName: "truck_icon"))
            } else {
                print("Failed to unwrap Vehicle Image URL =>")
                self.truckImageView.loadImageUsingCacheWithURLString(nil, placeHolder: #imageLiteral(resourceName: "truck_icon"))
            }
        }
    }
    internal var driverImageURLString: String? {
        didSet {
            if let urlStr = driverImageURLString {
                let completeURL:String = Config.EndpointConfig.baseURL + "/" + urlStr
                self.profileImageView.loadImageUsingCacheWithURLString(completeURL, placeHolder: #imageLiteral(resourceName: "truck_icon"))
            } else {
                print("Failed to unwrap Vehicle Image URL =>")
                self.profileImageView.loadImageUsingCacheWithURLString(nil, placeHolder: #imageLiteral(resourceName: "truck_icon"))
            }
        }
    }
    var sliderOption:CustomerSliderOption = .CancelRide
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        sender.resetStateWithAnimation(true)
        delegate?.didSlide(with: sliderOption)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        //        setupConstraints()
        sliderView.delegate = self
        chatButton.isHidden = true
        callButton.isHidden = true
        sliderView.isHidden = true
        //        cancelView.layoutIfNeeded()
        //        cancelView.sliderCornerRadius = cancelView.frame.height / 2
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var shadowLayer: CAShapeLayer!
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        sliderView.layoutIfNeeded()
        sliderView.sliderCornerRadius = sliderView.frame.height / 2
        sourceMarkView.layoutIfNeeded()
        destinationMarkView.layoutIfNeeded()
        sourceMarkView.layer.cornerRadius = sourceMarkView.frame.width / 2
        destinationMarkView.layer.cornerRadius = destinationMarkView.frame.width / 2
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0
        truckImageView.layoutIfNeeded()
        let cornerRadius:CGFloat = truckImageView.frame.size.width / 2.0
        truckImageView.layer.cornerRadius = cornerRadius

    }
    internal func setupViews() {
        addSubview(mapView)
        
        addSubview(popupView)
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: popupOffset)
        bottomConstraint.isActive = true
        mapView.addSubview(overlayView)
        
        truckTypeContainerView.addSubview(truckTypeTitleLabel)
        truckTypeContainerView.addSubview(truckTypeValueLabel)
//        truckTypeContainerView.addSubview(horizontalLine)
//
//        truckContainerView.addSubview(truckImageView)
//        truckContainerView.addSubview(numberPlateLabel)
//        truckTypeContainerView.addSubview(truckContainerView)
//
//        profileContainerView.addSubview(profileImageView)
//        profileContainerView.addSubview(nameLabel)
//        truckTypeContainerView.addSubview(profileContainerView)
        
        popupView.addSubview(truckTypeContainerView)
        
        
        
        addressContainerView.addSubview(sourceMarkView)
        addressContainerView.addSubview(sourceTitleLabel)
        addressContainerView.addSubview(sourceValueLabel)
        addressContainerView.addSubview(destinationTitleLabel)
        addressContainerView.addSubview(destinationValueLabel)
        addressContainerView.addSubview(destinationMarkView)
        addressContainerView.addSubview(verticalLine)
        
        popupView.addSubview(addressContainerView)
        popupView.addSubview(callButton)
        popupView.addSubview(chatButton)
        
        popupView.addSubview(bottomHorizontalLine)
        popupView.addSubview(bookingCodeLabel)
        popupView.addSubview(sliderView)
        
        popupView.isUserInteractionEnabled = true
        
    }
    
    internal func setupConstraints() {
        mapView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 110, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        overlayView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        popupView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 350)
        
        
        
        truckTypeContainerView.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        truckTypeTitleLabel.anchor(top: truckTypeContainerView.topAnchor, left: truckTypeContainerView.leftAnchor, bottom: truckTypeContainerView.bottomAnchor, right: nil, topConstant: 15, leftConstant: 24, bottomConstant: 15, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        truckTypeValueLabel.anchor(top: nil, left: nil, bottom: nil, right: truckTypeContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        truckTypeValueLabel.centerYAnchor.constraint(equalTo: truckTypeTitleLabel.centerYAnchor).activate()
        
        
        /*
        horizontalLine.anchor(top: truckTypeTitleLabel.bottomAnchor, left: truckTypeTitleLabel.leftAnchor, bottom: nil, right: truckTypeValueLabel.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 0, heightConstant: 0.9)
        
        
        truckContainerView.anchor(top: horizontalLine.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        //        truckContainerView.layoutIfNeeded()
        let width:CGFloat = truckContainerView.frame.width
        let imageSize:CGFloat = width / 1.3
        let markViewSize:CGFloat = 15.0
        truckImageView.anchor(top: truckContainerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: imageSize, heightConstant: imageSize)
        truckImageView.centerXAnchor.constraint(equalTo: truckContainerView.centerXAnchor).activate()
        numberPlateLabel.anchor(top: truckImageView.bottomAnchor, left: truckContainerView.leftAnchor, bottom: truckContainerView.bottomAnchor, right: truckContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        profileContainerView.anchor(top: truckContainerView.topAnchor, left: popupView.centerXAnchor, bottom: nil, right: popupView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        profileImageView.anchor(top: profileContainerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: imageSize, heightConstant: imageSize)
        profileImageView.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).activate()
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: profileContainerView.leftAnchor, bottom: profileContainerView.bottomAnchor, right: profileContainerView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        profileContainerView.bottomAnchor.constraint(equalTo: truckTypeContainerView.bottomAnchor, constant: -10).activate()
        */
        
        let markViewSize:CGFloat = 15.0
        addressContainerView.anchor(top: truckTypeContainerView.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: callButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0)
        
        sourceMarkView.anchor(top: addressContainerView.topAnchor, left: addressContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: markViewSize, heightConstant: markViewSize)
        
        sourceTitleLabel.anchor(top: sourceMarkView.topAnchor, left: sourceMarkView.rightAnchor, bottom: nil, right: addressContainerView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        sourceValueLabel.anchor(top: sourceTitleLabel.bottomAnchor, left: sourceTitleLabel.leftAnchor, bottom: nil, right: sourceTitleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        destinationTitleLabel.anchor(top: sourceValueLabel.bottomAnchor, left: sourceTitleLabel.leftAnchor, bottom: nil, right: sourceTitleLabel.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        destinationValueLabel.anchor(top: destinationTitleLabel.bottomAnchor, left: sourceTitleLabel.leftAnchor, bottom: addressContainerView.bottomAnchor, right: sourceTitleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        destinationMarkView.anchor(top: destinationTitleLabel.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: markViewSize, heightConstant: markViewSize)
        destinationMarkView.centerXAnchor.constraint(equalTo: sourceMarkView.centerXAnchor).activate()
        verticalLine.anchor(top: sourceMarkView.bottomAnchor, left: nil, bottom: destinationMarkView.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 1.0, heightConstant: 0)
        verticalLine.centerXAnchor.constraint(equalTo: sourceMarkView.centerXAnchor).activate()
        
        callButton.anchor(top: nil, left: nil, bottom: addressContainerView.centerYAnchor, right: popupView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 24, widthConstant: 40, heightConstant: 40)
        chatButton.anchor(top: addressContainerView.centerYAnchor, left: nil, bottom: nil, right: popupView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 40, heightConstant: 40)
        
        bottomHorizontalLine.anchor(top: addressContainerView.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 1.0)
        bookingCodeLabel.anchor(top: bottomHorizontalLine.bottomAnchor, left: bottomHorizontalLine.leftAnchor, bottom: nil, right: bottomHorizontalLine.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        popupView.layoutIfNeeded()
        let padding:CGFloat = popupView.frame.width / 7
        sliderView.anchor(top: bottomHorizontalLine.bottomAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, topConstant: 10, leftConstant: padding, bottomConstant: 24, rightConstant: padding, widthConstant: 0, heightConstant: 60)
        
    }
    lazy var profileContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    let bottomHorizontalLine = Line(color: UIColor.lightGray, opacity: 0.9)
    let profileImageView:UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "user")
        view.backgroundColor = .lightGray
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize.zero
//        view.layer.masksToBounds = false
        return view
    }()
    let truckImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "truck_icon").withRenderingMode(.alwaysOriginal)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
//        view.layer.masksToBounds = true
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.darkGray.cgColor
//        let inset:CGFloat = 6
//        view = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.8
//        view.layer.shadowRadius = 3
//        view.layer.shadowOffset = CGSize.zero
//        view.layoutIfNeeded()
        
        return view
    }()
    let callButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "call_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //let inset:CGFloat = 20
        //button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        //button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        //button.isEnabled = false
        //button.alpha = 0.5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize.zero
        button.layer.masksToBounds = false
        return button
    }()
    let chatButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "chat_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //let inset:CGFloat = 20
        //button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        //button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        //button.isEnabled = false
        //button.alpha = 0.5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize.zero
        button.layer.masksToBounds = false
        return button
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.text = "Driver Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 18.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    lazy var truckContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let numberPlateLabel:UILabel = {
        let label = UILabel()
        label.text = "US89WFHERO"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 18.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let bookingCodeLabel:UILabel = {
        let label = UILabel()
        label.text = "Booking Code: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 18.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    lazy var sliderView: MTSlideToOpenView = {
        let view = MTSlideToOpenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sliderViewTopDistance = 0
        view.thumbnailViewTopDistance = 0
        view.thumbnailViewStartingDistance = 0
        view.defaultThumbnailColor = UIColor.clear
        view.defaultSlidingColor = UIColor.systemRed
        view.defaultSliderBackgroundColor = UIColor.darkGray
        view.textLabel.textColor = UIColor.white
        view.defaultLabelText = "Slide to Cancel"
        view.thumnailImageView.image = #imageLiteral(resourceName: "signin _btn")
        view.thumnailImageView.contentMode = .scaleAspectFit
        view.textLabelLeadingDistance = 30
        view.textLabel.textAlignment = .center
        view.textLabel.adjustsFontSizeToFitWidth = true
        view.textLabel.sizeToFit()
        view.textLabel.layoutIfNeeded()
        view.layoutIfNeeded()
        return view
    }()
    internal lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    internal lazy var popupView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(r: 255, g: 250, b: 240)
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        return view
    }()
    
    //       lazy var closedTitleLabel: UILabel = {
    //           let label = UILabel()
    //           label.translatesAutoresizingMaskIntoConstraints = false
    //           label.text = "Ride Requests"
    //           label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
    //           label.textColor = .red
    //           label.textAlignment = .center
    //           return label
    //       }()
    
    //       lazy var openTitleLabel: UILabel = {
    //           let label = UILabel()
    //           label.translatesAutoresizingMaskIntoConstraints = false
    //           label.text = "No Requests"
    //           label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
    //           label.textColor = .black
    //           label.textAlignment = .center
    //           label.alpha = 0
    //           label.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
    //           return label
    //       }()
    
    lazy var truckTypeContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    lazy var addressContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    let truckTypeTitleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Truck Type"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 26.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let truckTypeValueLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Chhota Haathi"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 24.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
//    let horizontalLine = Line(color: UIColor.lightGray, opacity: 1)
    let sourceTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "SOURCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let sourceValueLabel:UILabel = {
        let label = UILabel()
        label.text = "sadjkfhasjk jkhasdjfkhasd hfjk hsajkdfhjkshdjf jjasdfjh j adsfdsaf fasdf"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    let destinationTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "DESTINATION"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let destinationValueLabel:UILabel = {
        let label = UILabel()
        label.text = "jjasdfjh j kjklhiei iqyuwieru  asdjbkag gayusgfhjhjsd f hgaf hasdfasfj hfasdf"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    let sourceMarkView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    let verticalLine = Line(color: .lightGray, opacity: 0.9)
    let destinationMarkView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    
    
    
    
    
    
    
    let acceptButtonSpinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        aiView.backgroundColor = .systemGreen
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.white
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    let declineButtonSpinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        aiView.backgroundColor = .red
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.white
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    let mapView:GMSMapView  = {
        let view = GMSMapView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        return view
    }()
    let menuButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .red
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    let overlay:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.isUserInteractionEnabled = true
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    let menuTableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.clear
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        tableView.clipsToBounds = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
}
