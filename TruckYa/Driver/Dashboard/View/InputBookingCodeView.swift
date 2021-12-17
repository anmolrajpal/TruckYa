//
//  InputBookingCodeView.swift
//  TruckYa
//
//  Created by Digit Bazar on 02/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class InputBookingCodeView: UIView {
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
        crossButton.transform = CGAffineTransform(translationX: 0, y: frame.height)
        containerImageView.transform = CGAffineTransform(translationX: 0, y: frame.height)
    }
    fileprivate func setupViews() {
        setupContainerImageView()
        addSubview(containerImageView)
        addSubview(crossButton)
    }
    fileprivate func setupConstraints() {
        containerImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
        containerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        crossButton.anchor(top: containerImageView.topAnchor, left: containerImageView.rightAnchor, bottom: nil, right: nil, topConstant: -15, leftConstant: -15, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        setupContainerImageViewConstraints()
    }
    fileprivate func setupContainerImageView() {
        containerImageView.addSubview(crossButton)
        containerImageView.addSubview(titleLabel)
        containerImageView.addSubview(bookingCodeTextField)
//        containerImageView.addSubview(bottomLine)
        containerImageView.addSubview(cancelButton)
        containerImageView.addSubview(doneButton)
    }
    fileprivate func setupContainerImageViewConstraints() {
        titleLabel.anchor(top: containerImageView.topAnchor, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 15, leftConstant: 25, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: 0)
        bookingCodeTextField.anchor(top: titleLabel.bottomAnchor, left: containerImageView.leftAnchor, bottom: nil, right: containerImageView.rightAnchor, topConstant: 25, leftConstant: 25, bottomConstant: 3, rightConstant: 25, widthConstant: 0, heightConstant: 0)
        
//        bottomLine.anchor(top: cancelButton.topAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1.0)
        
        cancelButton.anchor(top: nil, left: containerImageView.leftAnchor, bottom: containerImageView.bottomAnchor, right: containerImageView.centerXAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        //        let width:CGFloat = hireNowButton.frame.width + hireNowButton.contentEdgeInsets.left + hireNowButton.contentEdgeInsets.right
                cancelButton.layoutIfNeeded()
                let height:CGFloat = cancelButton.frame.height + cancelButton.contentEdgeInsets.top + cancelButton.contentEdgeInsets.bottom
        //        cancelButton.widthAnchor.constraint(equalToConstant: width).withPriority(999).activate()
                cancelButton.heightAnchor.constraint(equalToConstant: height).withPriority(999).activate()
        doneButton.anchor(top: cancelButton.topAnchor, left: containerImageView.centerXAnchor, bottom: containerImageView.bottomAnchor, right: containerImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        

    }
    let crossButton:UIButton = {
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
        label.text = "ENTER BOOKING CODE"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 26.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let bookingCodeTextField:UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.placeholder = "Booking Code"
        textField.font = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 22.0)!
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.keyboardType = .default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    func blendBottomLine(below textField:UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 3, y: textField.frame.height - 2, width: textField.frame.width / 1.25, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        textField.layer.addSublayer(bottomLine)
    }
//    let bottomLine = Line(color: .white, opacity: 0.9)
    let cancelButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 25.0)
        button.backgroundColor = .red
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 3, right: 10)
        button.clipsToBounds = true
        return button
    }()
    let doneButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("DONE", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 25.0)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.isEnabled = false
        button.alpha = 0.5
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 3, right: 10)
        button.clipsToBounds = true
        return button
    }()
}
