//
//  CustomerDashboardView.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import GoogleMaps
class CustomerDashboardView: UIView {
    internal let popupOffset: CGFloat = -68
    internal var topConstraint = NSLayoutConstraint()
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
        menuButton.layoutIfNeeded()
        menuButton.layer.cornerRadius = menuButton.frame.width / 2
//        menuButton.layer.shadowColor = UIColor.black.cgColor
//        menuButton.layer.shadowOpacity = 0.9
//        menuButton.layer.shadowRadius = 50
    }
    internal func setupViews() {
        addSubview(spinner)
        addSubview(mapView)
        mapView.addSubview(overlayView)
        addSubview(popupView)
        popupView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.height - safeAreaInsets.top)
        topConstraint = popupView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: bottomAnchor, constant: popupOffset)
        topConstraint.isActive = true
        popupView.addSubview(popupViewTitleLabel)
        
        popupView.addSubview(collectionView)
        
        addSubview(menuButton)
        addSubview(overlay)
        addSubview(menuTableView)
        addSubview(placeholderLabel)
        addSubview(tryAgainButton)
//        collectionView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    internal func setupConstraints() {
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        placeholderLabel.anchor(top: spinner.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        tryAgainButton.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor, constant: 20).activate()
        tryAgainButton.centerXAnchor.constraint(equalTo: placeholderLabel.centerXAnchor).activate()
        menuButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 35, heightConstant: 35)
        mapView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        overlayView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        popupViewTitleLabel.anchor(top: popupView.topAnchor, left: popupView.leftAnchor, bottom: nil, right: popupView.rightAnchor, topConstant: 22, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
        collectionView.anchor(top: popupViewTitleLabel.bottomAnchor, left: popupView.leftAnchor, bottom: popupView.bottomAnchor, right: popupView.rightAnchor, topConstant: 22, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: frame.height - safeAreaInsets.top - 68)
//        collectionView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).withPriority(999).activate()
        
        overlay.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        let menuTableViewWidth:CGFloat = frame.width / 1.4
        menuTableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: menuTableViewWidth)
        menuTableView.layoutIfNeeded()
        menuTableView.transform = CGAffineTransform(translationX: -menuTableViewWidth, y: 0)
    }
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
        view.backgroundColor = UIColor.red
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 20
        return view
    }()
    let popupViewTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "Nearby Drivers"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 24)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        label.isHidden = false
        return label
    }()
    let spinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        aiView.backgroundColor = .white
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.darkGray
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    let placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "Turn on Mobile Data or Wifi to Access Telabook"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 16)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.isHidden = true
        return label
    }()
    let tryAgainButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("TRY AGAIN", for: UIControl.State.normal)
        button.setTitleColor(UIColor.darkText, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroyBold.rawValue, size: 14)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkText.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
        return button
    }()
    let settingsButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Settings", for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        return button
    }()
    
    let backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "services")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let menuButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .red
        button.imageView?.contentMode = .scaleAspectFit
        let inset:CGFloat = 6
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize.zero
        button.layer.masksToBounds = false
        return button
    }()
    let mapView:GMSMapView  = {
        let view = GMSMapView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isMyLocationEnabled = true
        return view
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .always
        view.bounces = false
        view.isPagingEnabled = true
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        view.isHidden = false
        return view
    }()
    lazy var overlay:UIView = {
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
    let privacyPolicyButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 11.0)
        button.addTarget(self, action: #selector(didTapPrivacyPolicyButton), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func didTapPrivacyPolicyButton() {
        print("Privacy Policy Tapped")
    }
    let tncButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Terms & Conditions", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 11.0)
        button.addTarget(self, action: #selector(didTapTnCButton), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func didTapTnCButton() {
        print("Terms & Conditions Tapped")
    }
}

