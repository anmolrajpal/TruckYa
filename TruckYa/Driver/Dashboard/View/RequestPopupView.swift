//
//  RequestPopupView.swift
//  TruckYa
//
//  Created by Digit Bazar on 04/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class RequestPopupView:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        containerImageView.isUserInteractionEnabled = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        cancelButton.transform = CGAffineTransform(translationX: 0, y: frame.height)
        containerImageView.transform = CGAffineTransform(translationX: 0, y: frame.height)
        sourceMarkView.layoutIfNeeded()
        destinationMarkView.layoutIfNeeded()
        sourceMarkView.layer.cornerRadius = sourceMarkView.frame.width / 2
        destinationMarkView.layer.cornerRadius = destinationMarkView.frame.width / 2
    }
    func setupViews() {
        setupContainerImageView()
        addSubview(containerImageView)
        addSubview(cancelButton)
    }
    func setupConstraints() {
        containerImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
        containerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        cancelButton.anchor(top: containerImageView.topAnchor, left: containerImageView.rightAnchor, bottom: nil, right: nil, topConstant: -15, leftConstant: -15, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        setupContainerImageViewConstraints()
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
