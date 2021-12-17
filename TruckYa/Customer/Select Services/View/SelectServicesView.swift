//
//  SelectServicesView.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
class SelectServicesView:UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupCheckBoxes()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    func getModifiedString(price:Float) -> String {
        return "$ \(String(price))"
    }
    internal func configureView(with serviceDetails:ServicesCodable.Datum.Userservice) {
        let font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15)!
        let color = UIColor.darkGray
        
        if let stopAndDropServicePrice = serviceDetails.stopanddrop {
            print("Stop And Drop Price => \(stopAndDropServicePrice)")
            optionOneLabel.appendString(text: getModifiedString(price: stopAndDropServicePrice), font: font, textColor: color, newLineCount: 1)
        }
        if let oneDriverServicePrice = serviceDetails.onedriverhelpsupload {
            print("One Driver Price => \(oneDriverServicePrice)")
            optionTwoLabel.appendString(text: getModifiedString(price: oneDriverServicePrice), font: font, textColor: color, newLineCount: 1)
        }
        if let twoDriversServicePrice = serviceDetails.twodriverhelpsupload {
            print("Two Price => \(twoDriversServicePrice)")
            optionThreeLabel.appendString(text: getModifiedString(price: twoDriversServicePrice), font: font, textColor: color, newLineCount: 1)
        }
        if let trailerHitchServicePrice = serviceDetails.trailerhitchmove {
            print("Trailer Hitch Service Price => \(trailerHitchServicePrice)")
            optionFourLabel.appendString(text: getModifiedString(price: trailerHitchServicePrice), font: font, textColor: color, newLineCount: 1)
        }
        if let dirtyJobsServicePrice = serviceDetails.hultingtodumpsdirtyjob {
            print("Dirty JObs Price => \(dirtyJobsServicePrice)")
            //            optionFiveLabel.appendString(text: getModifiedString(price: dirtyJobsServicePrice), font: font, textColor: color, newLineCount: 1)
            optionFivePriceLabel.text = getModifiedString(price: dirtyJobsServicePrice)
        }
    }
    
    
    
    fileprivate func initViews() {
        setupViews()
        setupConstraints()
    }
    internal func setupViews() {
        addSubview(viewSpinner)
        addSubview(backButton)
        addSubview(headingLabel)
        addSubview(optionOneLabel)
        addSubview(stopAndDropCheckBox)
        addSubview(optionTwoLabel)
        addSubview(oneDriverCheckBox)
        addSubview(optionThreeLabel)
        addSubview(twoDriversCheckBox)
        addSubview(optionFourLabel)
        addSubview(trailerCheckBox)
        addSubview(optionFiveLabel)
        addSubview(optionFivePriceLabel)
        addSubview(haulingCheckBox)
        addSubview(notesLabel)
        commentsTextView.addSubview(placeholderLabel)
        addSubview(commentsTextView)
        addSubview(hireButton)
    }
    internal func setupConstraints() {
        viewSpinner.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
        viewSpinner.centerYAnchor.constraint(equalTo: centerYAnchor).activate()
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        let checkboxSize:CGFloat = 23.0
        let interLabelSpacing:CGFloat = 25
        optionOneLabel.anchor(top: headingLabel.bottomAnchor, left: backButton.leftAnchor, bottom: nil, right: stopAndDropCheckBox.leftAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        stopAndDropCheckBox.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: checkboxSize, heightConstant: checkboxSize)
        stopAndDropCheckBox.centerYAnchor.constraint(equalTo: optionOneLabel.centerYAnchor).activate()
        
        optionTwoLabel.anchor(top: optionOneLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        oneDriverCheckBox.anchor(top: nil, left: nil, bottom: nil, right: stopAndDropCheckBox.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: checkboxSize, heightConstant: checkboxSize)
        oneDriverCheckBox.centerYAnchor.constraint(equalTo: optionTwoLabel.centerYAnchor).activate()
        
        optionThreeLabel.anchor(top: optionTwoLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        twoDriversCheckBox.anchor(top: nil, left: nil, bottom: nil, right: stopAndDropCheckBox.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: checkboxSize, heightConstant: checkboxSize)
        twoDriversCheckBox.centerYAnchor.constraint(equalTo: optionThreeLabel.centerYAnchor).activate()
        
        optionFourLabel.anchor(top: optionThreeLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        trailerCheckBox.anchor(top: nil, left: nil, bottom: nil, right: stopAndDropCheckBox.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: checkboxSize, heightConstant: checkboxSize)
        trailerCheckBox.centerYAnchor.constraint(equalTo: optionFourLabel.centerYAnchor).activate()
        
        optionFiveLabel.anchor(top: optionFourLabel.bottomAnchor, left: optionOneLabel.leftAnchor, bottom: nil, right: optionOneLabel.rightAnchor, topConstant: interLabelSpacing, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        optionFivePriceLabel.anchor(top: optionFiveLabel.bottomAnchor, left: optionFiveLabel.leftAnchor, bottom: nil, right: optionFiveLabel.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        haulingCheckBox.anchor(top: nil, left: nil, bottom: nil, right: stopAndDropCheckBox.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: checkboxSize, heightConstant: checkboxSize)
        haulingCheckBox.centerYAnchor.constraint(equalTo: optionFiveLabel.centerYAnchor).activate()
        
        notesLabel.anchor(top: optionFivePriceLabel.bottomAnchor, left: optionFiveLabel.leftAnchor, bottom: nil, right: optionFiveLabel.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        commentsTextView.anchor(top: notesLabel.bottomAnchor, left: notesLabel.leftAnchor, bottom: nil, right: haulingCheckBox.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 140)
        hireButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 24, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        hireButton.centerXAnchor.constraint(equalTo: centerXAnchor).activate()
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
    lazy var backButton:UIButton = {
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
        label.text = "SELECT SERVICES"
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
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    lazy var stopAndDropCheckBox:Checkbox = {
        let checkbox = Checkbox(type: .custom)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.tintColor = UIColor.red
        checkbox.backgroundColor = UIColor.white
        let inset:CGFloat = 15
        checkbox.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.isChecked = false
        checkbox.layer.cornerRadius = 3
        return checkbox
    }()
    let optionTwoLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ONE DRIVER HELPS UNLOAD"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    lazy var oneDriverCheckBox:Checkbox = {
        let checkbox = Checkbox(type: .custom)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.tintColor = UIColor.red
        checkbox.backgroundColor = UIColor.white
        let inset:CGFloat = 15
        checkbox.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.isChecked = false
        checkbox.layer.cornerRadius = 3
        return checkbox
    }()
    let optionThreeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 DRIVERS HELP UNLOAD"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    lazy var twoDriversCheckBox:Checkbox = {
        let checkbox = Checkbox(type: .custom)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.tintColor = UIColor.red
        checkbox.backgroundColor = UIColor.white
        let inset:CGFloat = 15
        checkbox.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.isChecked = false
        checkbox.layer.cornerRadius = 3
        return checkbox
    }()
    let optionFourLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TRAILER HITCH MOVES"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    lazy var trailerCheckBox:Checkbox = {
        let checkbox = Checkbox(type: .custom)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.tintColor = UIColor.red
        checkbox.backgroundColor = UIColor.white
        let inset:CGFloat = 15
        checkbox.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.isChecked = false
        checkbox.layer.cornerRadius = 3
        return checkbox
    }()
    let optionFiveLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FOR HAULING TO DUMPS OR DIRTY JOBS"
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 18.0)
        return label
    }()
    let optionFivePriceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 15)!
        return label
    }()
    lazy var haulingCheckBox:Checkbox = {
        let checkbox = Checkbox(type: .custom)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.tintColor = UIColor.red
        checkbox.backgroundColor = UIColor.white
        let inset:CGFloat = 15
        checkbox.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        checkbox.isChecked = false
        checkbox.layer.cornerRadius = 3
        return checkbox
    }()
    let notesLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Additional Notes"
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: CustomFonts.gilroyRegular.rawValue, size: 16.0)
        return label
    }()
    let placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "Add your comments..."
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        return label
    }()
    let commentsTextView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = true
        textView.textAlignment = .left
        textView.isSelectable = true
        textView.tintColor = UIColor.lightGray
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 0, right: 10)
        textView.backgroundColor = UIColor.red
        textView.font = UIFont(name: CustomFonts.gilroyRegular.rawValue, size: 14)
        textView.textColor = UIColor.white
        textView.sizeToFit()
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = .all
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton));
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 14)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        toolbar.setItems([spaceButton,doneButton], animated: false)
        textView.inputAccessoryView = toolbar
        textView.keyboardAppearance = .default
        textView.layer.cornerRadius = 15
        return textView
    }()
    @objc func didTapDoneButton() {
        endEditing(true)
    }
    let hireButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("HIRE", for: UIControl.State.normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28)
        button.isEnabled = false
        button.alpha = 0.4
        //            button.addTarget(self, action: #selector(hireButtonTapped), for: .touchUpInside)
        return button
    }()
    func setupCheckBoxes() {
        stopAndDropCheckBox.addTarget(self, action: #selector(didChangeCheckBoxValue(checkBox:)), for: .touchUpInside)
        oneDriverCheckBox.addTarget(self, action: #selector(didChangeCheckBoxValue(checkBox:)), for: .touchUpInside)
        twoDriversCheckBox.addTarget(self, action: #selector(didChangeCheckBoxValue(checkBox:)), for: .touchUpInside)
        trailerCheckBox.addTarget(self, action: #selector(didChangeCheckBoxValue(checkBox:)), for: .touchUpInside)
        haulingCheckBox.addTarget(self, action: #selector(didChangeCheckBoxValue(checkBox:)), for: .touchUpInside)
    }
    @objc fileprivate func didChangeCheckBoxValue(checkBox:Checkbox) {
        self.validateFields()
    }
    fileprivate func isDataValid() -> Bool {
        guard oneDriverCheckBox.isChecked || twoDriversCheckBox.isChecked || trailerCheckBox.isChecked || haulingCheckBox.isChecked || stopAndDropCheckBox.isChecked else {
            return false
        }
        return true
    }
    internal func validateFields() {
        isDataValid() ? enableHireButton() : disableHireButton()
    }
    internal func enableHireButton() {
        DispatchQueue.main.async {
            self.hireButton.isEnabled = true
            UIView.animate(withDuration: 0.4) {
                self.hireButton.alpha = 1.0
            }
        }
    }
    internal func disableHireButton() {
        DispatchQueue.main.async {
            self.hireButton.isEnabled = false
            UIView.animate(withDuration: 0.4) {
                self.hireButton.alpha = 0.5
            }
        }
    }
}
extension UILabel {
    func appendString(text:String, font:UIFont, textColor:UIColor, newLineCount:Int = 0) {
        self.numberOfLines = newLineCount + 1
        let attributedString = NSAttributedString(string: text, attributes: [
            .font : font,
            .foregroundColor: textColor
        ])
        let labelAttributedString = NSAttributedString(string: self.text ?? "", attributes: [
            .font : self.font!,
            .foregroundColor: self.textColor!
        ])
        let mutableAttributedString = NSMutableAttributedString()
        //        let labelText = self.text
        mutableAttributedString.append(labelAttributedString)
        for _ in 0..<newLineCount {
            mutableAttributedString.append(NSAttributedString(string: "\n"))
        }
        mutableAttributedString.append(attributedString)
        self.attributedText = mutableAttributedString
    }
}
