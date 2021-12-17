//
//  DriverDashboardView.swift
//  TruckYa
//
//  Created by Anmol Rajpal on 13/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import GoogleMaps
import UIKit.UIGestureRecognizerSubclass
import MTSlideToOpen
enum SliderOption { case ReachedSource, StartJourney, ReachedDestination }
protocol SliderViewDelegate {
    func didSlide(with option: SliderOption)
}
class DriverDashboardView: UIView, MTSlideToOpenDelegate {
    
    var delegate:SliderViewDelegate?
    var sliderOption:SliderOption = .ReachedSource
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        sender.resetStateWithAnimation(true)
        delegate?.didSlide(with: sliderOption)
    }
    
    internal var popupOffset: CGFloat = 400
    internal var bottomConstraint = NSLayoutConstraint()
    internal var metaPopupOffset: CGFloat = 400
    internal var metaBottomConstraint = NSLayoutConstraint()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        sliderView.delegate = self
        popupView.isHidden = true
        
//        metaPopupView.isHidden = true
        
        //        setupConstraints()
//        popupView.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        sliderView.layoutIfNeeded()
        sliderView.sliderCornerRadius = sliderView.frame.height / 2
        let menuTableViewWidth:CGFloat = frame.width / 1.4
        menuTableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: menuTableViewWidth)
        menuTableView.layoutIfNeeded()
        menuTableView.transform = CGAffineTransform(translationX: -menuTableViewWidth, y: 0)
        sourceMarkView.layoutIfNeeded()
        destinationMarkView.layoutIfNeeded()
        sourceMarkView.layer.cornerRadius = sourceMarkView.frame.width / 2
        destinationMarkView.layer.cornerRadius = destinationMarkView.frame.width / 2
        
        addressSourceMarkView.layoutIfNeeded()
        addressDestinationMarkView.layoutIfNeeded()
        addressSourceMarkView.layer.cornerRadius = addressSourceMarkView.frame.width / 2
        addressDestinationMarkView.layer.cornerRadius = addressDestinationMarkView.frame.width / 2
//        layoutIfNeeded()
    }
    internal func setupViews() {
        addSubview(mapView)
        addSubview(menuButton)
        addSubview(popupView)
        bottomConstraint = popupView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: popupOffset)
        bottomConstraint.isActive = true
        
        addSubview(metaPopupView)
        metaBottomConstraint = metaPopupView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: metaPopupOffset)
        metaBottomConstraint.isActive = true
        metaPopupView.isUserInteractionEnabled = true
        
        addSubview(overlay)
        addSubview(menuTableView)
        mapView.addSubview(overlayView)
        popupView.addSubview(closedTitleLabel)
        popupView.addSubview(openTitleLabel)
        popupView.addSubview(containerImageView)
        setupContainerImageView()
        
        nameContainerView.addSubview(customerNameLabel)
        metaPopupView.addSubview(nameContainerView)
        
        addressContainerView.addSubview(addressSourceMarkView)
        addressContainerView.addSubview(addressSourceTitleLabel)
        addressContainerView.addSubview(addressSourceValueLabel)
        addressContainerView.addSubview(addressDestinationTitleLabel)
        addressContainerView.addSubview(addressDestinationValueLabel)
        addressContainerView.addSubview(addressDestinationMarkView)
        addressContainerView.addSubview(addressVerticalLine)
        
        metaPopupView.addSubview(addressContainerView)
        metaPopupView.addSubview(callButton)
        metaPopupView.addSubview(chatButton)
        
        metaPopupView.addSubview(bottomHorizontalLine)
        metaPopupView.addSubview(sliderView)
        
        
        
    }
    
    internal func setupConstraints() {
        mapView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        menuButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        overlay.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        
        
        overlayView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        popupView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor).isActive = true
        
        popupView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        metaPopupView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 400)
        
        
        
        
        closedTitleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        closedTitleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        closedTitleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20).isActive = true
        
        openTitleLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        openTitleLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        openTitleLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 30).isActive = true
        
        containerImageView.topAnchor.constraint(equalTo: openTitleLabel.bottomAnchor, constant: 80).isActive = true
        containerImageView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 24).isActive = true
        containerImageView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -24).isActive = true
        
        setupContainerImageViewConstraints()
        
        
        
        
        
        nameContainerView.anchor(top: metaPopupView.topAnchor, left: metaPopupView.leftAnchor, bottom: nil, right: metaPopupView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        customerNameLabel.anchor(top: nameContainerView.topAnchor, left: nameContainerView.leftAnchor, bottom: nameContainerView.bottomAnchor, right: nil, topConstant: 15, leftConstant: 24, bottomConstant: 15, rightConstant: 24)
        
        let markViewSize:CGFloat = 15.0
        addressContainerView.anchor(top: nameContainerView.bottomAnchor, left: nameContainerView.leftAnchor, bottom: nil, right: callButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 15)
        
        addressSourceMarkView.anchor(top: addressContainerView.topAnchor, left: addressContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: markViewSize, heightConstant: markViewSize)
        
        addressSourceTitleLabel.anchor(top: addressSourceMarkView.topAnchor, left: addressSourceMarkView.rightAnchor, bottom: nil, right: addressContainerView.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addressSourceValueLabel.anchor(top: addressSourceTitleLabel.bottomAnchor, left: addressSourceTitleLabel.leftAnchor, bottom: nil, right: addressSourceTitleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addressDestinationTitleLabel.anchor(top: addressSourceValueLabel.bottomAnchor, left: addressSourceTitleLabel.leftAnchor, bottom: nil, right: addressSourceTitleLabel.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addressDestinationValueLabel.anchor(top: addressDestinationTitleLabel.bottomAnchor, left: addressSourceTitleLabel.leftAnchor, bottom: addressContainerView.bottomAnchor, right: addressSourceTitleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        addressDestinationMarkView.anchor(top: addressDestinationTitleLabel.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: markViewSize, heightConstant: markViewSize)
        addressDestinationMarkView.centerXAnchor.constraint(equalTo: addressSourceMarkView.centerXAnchor).activate()
        addressVerticalLine.anchor(top: addressSourceMarkView.bottomAnchor, left: nil, bottom: addressDestinationMarkView.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 1.0, heightConstant: 0)
        addressVerticalLine.centerXAnchor.constraint(equalTo: addressSourceMarkView.centerXAnchor).activate()
        
        callButton.anchor(top: nil, left: nil, bottom: addressContainerView.centerYAnchor, right: metaPopupView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 24, widthConstant: 40, heightConstant: 40)
        chatButton.anchor(top: addressContainerView.centerYAnchor, left: nil, bottom: nil, right: metaPopupView.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 40, heightConstant: 40)
        
        bottomHorizontalLine.anchor(top: addressContainerView.bottomAnchor, left: nameContainerView.leftAnchor, bottom: nil, right: nameContainerView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1.0)
        
      
        metaPopupView.layoutIfNeeded()
//        let padding:CGFloat = metaPopupView.frame.width / 5
        let padding:CGFloat = 60

        sliderView.anchor(top: bottomHorizontalLine.bottomAnchor, left: bottomHorizontalLine.leftAnchor, bottom: nil, right: bottomHorizontalLine.rightAnchor, topConstant: 10, leftConstant: padding, bottomConstant: 24, rightConstant: padding, widthConstant: 0, heightConstant: 60)

        
        
        
        //        sourceMarkView.layer.cornerRadius = sourceMarkView.frame.width / 2
        //        destinationMarkView.layer.cornerRadius = destinationMarkView.frame.width / 2
    }
    
    
    let bottomHorizontalLine = Line(color: UIColor.lightGray, opacity: 0.9)
    
    
    let callButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "call_icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //let inset:CGFloat = 20
        //button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        //button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.isEnabled = false
        //button.alpha = 0.5
        button.isHidden = true
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
        button.isEnabled = false
        //button.alpha = 0.5
        button.isHidden = true
        
        return button
    }()
    //    let nameLabel:UILabel = {
    //        let label = UILabel()
    //        label.text = "Driver Name"
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.textColor = .white
    //        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 18.0)
    //        label.numberOfLines = 0
    //        label.textAlignment = .center
    //        label.lineBreakMode = .byWordWrapping
    //        return label
    //    }()
    //
    
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
        view.defaultLabelText = "Reached to Source"
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
    internal lazy var metaPopupView: UIView = {
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
    lazy var nameContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.cornerRadius = 20
        return view
    }()
    let customerNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Customer Name"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 26.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    lazy var addressContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    let addressSourceTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "SOURCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let addressSourceValueLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    let addressDestinationTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "DESTINATION"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let addressDestinationValueLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    let addressSourceMarkView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    let addressVerticalLine = Line(color: .lightGray, opacity: 0.9)
    let addressDestinationMarkView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    
    
    
    lazy var mapView:GMSMapView  = {
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
        tableView.isHidden = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
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
    
    lazy var closedTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ride Requests"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    let requestsTableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tableView.separatorColor = UIColor.darkGray
        tableView.bounces = false
        tableView.alwaysBounceVertical = true
        tableView.alwaysBounceHorizontal = false
        tableView.clipsToBounds = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return tableView
    }()
    lazy var openTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Requests"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0
        label.transform = CGAffineTransform(scaleX: 0.65, y: 0.65).concatenating(CGAffineTransform(translationX: 0, y: -15))
        return label
    }()
    
    lazy var containerImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "description_container")
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "NEW RIDE REQUEST"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 26.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let sourceTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "SOURCE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let sourceValueLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
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
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let destinationValueLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    let sourceMarkView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGreen
        return view
    }()
    let verticalLine = Line(color: .lightGray, opacity: 0.9)
    let destinationMarkView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        return view
    }()
    lazy var declineButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("DECLINE", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 25.0)
        button.backgroundColor = .red
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 5, right: 10)
        button.clipsToBounds = true
        return button
    }()
    let acceptButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ACCEPT", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 25.0)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 5, right: 10)
        button.clipsToBounds = true
        return button
    }()
    
    
    
    fileprivate func setupContainerImageView() {
        containerImageView.addSubview(titleLabel)
        containerImageView.addSubview(sourceMarkView)
        containerImageView.addSubview(sourceTitleLabel)
        containerImageView.addSubview(sourceValueLabel)
        containerImageView.addSubview(destinationTitleLabel)
        containerImageView.addSubview(destinationValueLabel)
        containerImageView.addSubview(destinationMarkView)
        containerImageView.addSubview(verticalLine)
        containerImageView.addSubview(acceptButton)
        containerImageView.addSubview(declineButton)
    }
    fileprivate func setupContainerImageViewConstraints() {
        titleLabel.anchor(top: containerImageView.topAnchor, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 15, leftConstant: 25, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        sourceMarkView.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        
        sourceTitleLabel.anchor(top: sourceMarkView.topAnchor, left: sourceMarkView.rightAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        sourceValueLabel.anchor(top: sourceTitleLabel.bottomAnchor, left: sourceTitleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        destinationTitleLabel.anchor(top: sourceValueLabel.bottomAnchor, left: sourceTitleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        destinationValueLabel.anchor(top: destinationTitleLabel.bottomAnchor, left: sourceTitleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        destinationMarkView.anchor(top: destinationTitleLabel.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        destinationMarkView.centerXAnchor.constraint(equalTo: sourceMarkView.centerXAnchor).activate()
        verticalLine.anchor(top: sourceMarkView.bottomAnchor, left: nil, bottom: destinationMarkView.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 1.0, heightConstant: 0)
        verticalLine.centerXAnchor.constraint(equalTo: sourceMarkView.centerXAnchor).activate()
        acceptButton.anchor(top: nil, left: containerImageView.leftAnchor, bottom: containerImageView.bottomAnchor, right: containerImageView.centerXAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        declineButton.anchor(top: nil, left: containerImageView.centerXAnchor, bottom: containerImageView.bottomAnchor, right: containerImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    
}
// MARK: - State

internal enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}
// MARK: - InstantPanGestureRecognizer

/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}
