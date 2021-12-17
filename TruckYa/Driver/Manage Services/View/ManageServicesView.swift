//
//  ManageServicesView.swift
//  TruckYa
//
//  Created by Digit Bazar on 19/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class ManageServicesView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        setupTextFieldsBottomLayer()
        saveButton.layoutIfNeeded()
        saveButton.layer.cornerRadius = saveButton.frame.width / 2
    }
    fileprivate func initViews() {
        setupViews()
//        setupConstraints()
        setupTextFields()
//        setupTextFieldsBottomLayer()
    }
    internal func setupViews() {
        addSubview(viewSpinner)
        addSubview(backButton)
        addSubview(headingLabel)
        addSubview(optionOneLabel)
        addSubview(optionOneTextField)
        addSubview(optionTwoLabel)
        addSubview(optionTwoTextField)
        addSubview(optionThreeLabel)
        addSubview(optionThreeTextField)
        addSubview(optionFourLabel)
        addSubview(optionFourTextField)
        addSubview(optionFiveLabel)
        addSubview(optionFiveTextField)
        saveButton.addSubview(spinner)
        addSubview(saveButton)
    }
    lazy var saveButtonSize:CGFloat = {
        let expectedTextSize = (saveButton.titleLabel!.text! as NSString).size(withAttributes: [.font: saveButton.titleLabel!.font!])
        let leftInset = saveButton.contentEdgeInsets.left
        let rightInset = saveButton.contentEdgeInsets.right
        let buttonSize = expectedTextSize.width + leftInset + rightInset + 10
        return buttonSize
    }()
    internal func setupConstraints() {
        viewSpinner.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        viewSpinner.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        let interLabelSpacing:CGFloat = 45
        let tfHeight:CGFloat = 40
        let tfWidth:CGFloat = frame.width / 3.5
        
        optionOneLabel.anchor(top: headingLabel.bottomAnchor, left: backButton.leftAnchor, bottom: nil, right: optionOneTextField.leftAnchor, topConstant: 60, leftConstant: 10, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        optionOneTextField.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: tfHeight)
        optionOneTextField.widthAnchor.constraint(equalToConstant: tfWidth).withPriority(999).activate()
        optionOneTextField.centerYAnchor.constraint(equalTo: optionOneLabel.centerYAnchor).activate()
        
        optionTwoLabel.anchor(top: optionOneLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        optionTwoTextField.anchor(top: nil, left: nil, bottom: nil, right: optionOneTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: tfHeight)
        optionTwoTextField.centerYAnchor.constraint(equalTo: optionTwoLabel.centerYAnchor).activate()
    
        
        optionThreeLabel.anchor(top: optionTwoLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        optionThreeTextField.anchor(top: nil, left: nil, bottom: nil, right: optionOneTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: tfHeight)
        optionThreeTextField.centerYAnchor.constraint(equalTo: optionThreeLabel.centerYAnchor).activate()
        
        optionFourLabel.anchor(top: optionThreeLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        optionFourTextField.anchor(top: nil, left: nil, bottom: nil, right: optionOneTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: tfHeight)
        optionFourTextField.centerYAnchor.constraint(equalTo: optionFourLabel.centerYAnchor).activate()
        
        optionFiveLabel.anchor(top: optionFourLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        optionFiveTextField.anchor(top: nil, left: nil, bottom: nil, right: optionOneTextField.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: tfWidth, heightConstant: tfHeight)
        optionFiveTextField.centerYAnchor.constraint(equalTo: optionFiveLabel.centerYAnchor).activate()
        
//        let expectedTextSize = (saveButton.titleLabel!.text! as NSString).size(withAttributes: [.font: saveButton.titleLabel!.font!])
//        let leftInset = saveButton.contentEdgeInsets.left
//        let rightInset = saveButton.contentEdgeInsets.right
//        let buttonSize = expectedTextSize.width + leftInset + rightInset + 10
//
        saveButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 24, rightConstant: 0, widthConstant: saveButtonSize, heightConstant: saveButtonSize)
        saveButton.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        spinner.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor).activate()
        spinner.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor).activate()
    }
    let viewSpinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        aiView.backgroundColor = .black
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.white
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
    let backButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    let headingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MANAGE SERVICES"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
        return label
    }()
    let optionOneLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "STOP AND DROP"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    let optionTwoLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ONE DRIVER HELPS UNLOAD"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    let optionThreeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 DRIVERS HELP UNLOAD"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    let optionFourLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TRAILER HITCH MOVES"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    let optionFiveLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FOR HAULING TO DUMPS OR DIRTY JOBS"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    lazy var optionOneTextField = createTextField(placeholder: "0.00")
    lazy var optionTwoTextField = createTextField(placeholder: "0.00")
    lazy var optionThreeTextField = createTextField(placeholder: "0.00")
    lazy var optionFourTextField = createTextField(placeholder: "0.00")
    lazy var optionFiveTextField = createTextField(placeholder: "0.00")
    
    func setupTextFields() {
        optionOneTextField.keyboardType = .decimalPad
        optionTwoTextField.keyboardType = .decimalPad
        optionThreeTextField.keyboardType = .decimalPad
        optionFourTextField.keyboardType = .decimalPad
        optionFiveTextField.keyboardType = .decimalPad
        
        let fontSize:CGFloat = 22.0
        optionOneTextField.setDefault(string: "$", withFont: UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: fontSize)!, withColor: .white, at: .Left)
        optionOneTextField.setDefault(string: "/mile", withFont: UIFont(name: CustomFonts.gilroyLight.rawValue, size: 14)!, withColor: .white, at: .Right)
        optionTwoTextField.setDefault(string: "$", withFont: UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: fontSize)!, withColor: .white, at: .Left)
        optionTwoTextField.setDefault(string: "/mile", withFont: UIFont(name: CustomFonts.gilroyLight.rawValue, size: 14)!, withColor: .white, at: .Right)
        optionThreeTextField.setDefault(string: "$", withFont: UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: fontSize)!, withColor: .white, at: .Left)
        optionThreeTextField.setDefault(string: "/mile", withFont: UIFont(name: CustomFonts.gilroyLight.rawValue, size: 14)!, withColor: .white, at: .Right)
        optionFourTextField.setDefault(string: "$", withFont: UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: fontSize)!, withColor: .white, at: .Left)
        optionFourTextField.setDefault(string: "/mile", withFont: UIFont(name: CustomFonts.gilroyLight.rawValue, size: 14)!, withColor: .white, at: .Right)
        optionFiveTextField.setDefault(string: "$", withFont: UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: fontSize)!, withColor: .white, at: .Left)
        optionFiveTextField.setDefault(string: "/mile", withFont: UIFont(name: CustomFonts.gilroyLight.rawValue, size: 14)!, withColor: .white, at: .Right)
    }
    func setupTextFieldsBottomLayer() {
        let spaceY:CGFloat = -4
//        let spaceX:CGFloat = 8
//        optionOneTextField.blendBottomLine(spaceX: spaceX, spaceY: spaceY, lineWidthFactor: 1.1)
        optionOneTextField.blendBottomLine(spaceY: spaceY)
        optionTwoTextField.blendBottomLine(spaceY: spaceY)
        optionThreeTextField.blendBottomLine(spaceY: spaceY)
        optionFourTextField.blendBottomLine(spaceY: spaceY)
        optionFiveTextField.blendBottomLine(spaceY: spaceY)
    }
    func createTextField(placeholder:String? = nil) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 20.0)
        if let placeholderText = placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.gray])
        }
        textField.textColor = UIColor.white
        textField.textAlignment = .left
        textField.keyboardAppearance = .dark
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        return textField
    }
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
//        button.titleLabel?.adjustsFontSizeToFitWidth = true
//        button.titleLabel?.sizeToFit()
//        button.sizeToFit()
        return button
    }()
    let spinner: UIActivityIndicatorView = {
        let aiView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        aiView.backgroundColor = .red
        aiView.hidesWhenStopped = true
        aiView.color = UIColor.white
        aiView.clipsToBounds = true
        aiView.translatesAutoresizingMaskIntoConstraints = false
        return aiView
    }()
}
