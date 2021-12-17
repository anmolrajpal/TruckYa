//
//  GetPriceView.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class GetPriceView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        cancelButton.transform = CGAffineTransform(translationX: 0, y: frame.height)
        containerImageView.transform = CGAffineTransform(translationX: 0, y: frame.height)
    }
    fileprivate func setupViews() {
        setupContainerImageView()
        addSubview(containerImageView)
        addSubview(cancelButton)
    }
    fileprivate func setupConstraints() {
        containerImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
        containerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        cancelButton.anchor(top: containerImageView.topAnchor, left: containerImageView.rightAnchor, bottom: nil, right: nil, topConstant: -15, leftConstant: -15, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        setupContainerImageViewConstraints()
    }
    fileprivate func setupContainerImageView() {
        containerImageView.addSubview(cancelButton)
        containerImageView.addSubview(titleLabel)
        containerImageView.addSubview(flatRateTitleLabel)
        containerImageView.addSubview(flatRateValueLabel)
        containerImageView.addSubview(longerHaulsTitleLabel)
        containerImageView.addSubview(longerHaulsValueLabel)
        containerImageView.addSubview(bottomLine)
        containerImageView.addSubview(distanceAndPriceLabel)
        containerImageView.addSubview(hireNowButton)
    }
    fileprivate func setupContainerImageViewConstraints() {
        titleLabel.anchor(top: containerImageView.topAnchor, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 15, leftConstant: 25, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        flatRateTitleLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        flatRateValueLabel.anchor(top: flatRateTitleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        longerHaulsTitleLabel.anchor(top: flatRateValueLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        longerHaulsValueLabel.anchor(top: longerHaulsTitleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomLine.anchor(top: hireNowButton.topAnchor, left: titleLabel.leftAnchor, bottom: nil, right: hireNowButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0.5)
        distanceAndPriceLabel.anchor(top: nil, left: bottomLine.leftAnchor, bottom: containerImageView.bottomAnchor, right: bottomLine.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        distanceAndPriceLabel.centerYAnchor.constraint(equalTo: hireNowButton.centerYAnchor).activate()
        hireNowButton.layoutIfNeeded()
        let width:CGFloat = hireNowButton.frame.width + hireNowButton.contentEdgeInsets.left + hireNowButton.contentEdgeInsets.right
        let height:CGFloat = hireNowButton.frame.height + hireNowButton.contentEdgeInsets.top + hireNowButton.contentEdgeInsets.bottom
        hireNowButton.anchor(top: nil, left: nil, bottom: containerImageView.bottomAnchor, right: containerImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        hireNowButton.widthAnchor.constraint(equalToConstant: width).withPriority(999).activate()
        hireNowButton.heightAnchor.constraint(equalToConstant: height).withPriority(999).activate()
    }
    let cancelButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "cancel-icon").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.red
        button.backgroundColor = .white
        let inset:CGFloat = -5
        button.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return button
    }()
    let containerImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "description_container")
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "PRICE APPROXIMATION"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 26.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let flatRateTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "FLAT RATE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let flatRateValueLabel:UILabel = {
        let label = UILabel()
        label.text = "$15/MILE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let longerHaulsTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "LONGER HAULS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let longerHaulsValueLabel:UILabel = {
        let label = UILabel()
        label.text = ".80 CENTS A MINUTE"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 12.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let bottomLine = Line(color: .white, opacity: 0.9)
    let distanceAndPriceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "25 MILES | $325.00"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 25.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let hireNowButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("HIRE NOW", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 25.0)
        button.backgroundColor = .red
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 3, right: 10)
        button.clipsToBounds = true
        return button
    }()
}
