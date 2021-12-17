//
//  CreditCardVC.swift
//  TruckYa
//
//  Created by Digit Bazar on 14/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
class CreditCardVC: UIViewController {
    var expiryMonth:Int?
    var expiryYear:Int?
    override func loadView() {
        super.loadView()
        setupViews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTextFields()
        setupTextFieldsDelegates()
        scrollView.delegate = self
        scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y), animated: true)
        expDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            self.expDateTextField.text = string
            self.expiryMonth = month
            self.expiryYear = year
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotificationsObservers()
    }
    fileprivate func setupTextFieldsDelegates() {
        nameTextField.delegate = self
        cardNumberTextField.delegate = self
        expDateTextField.delegate = self
        cardTypeTextField.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
        cardContainerView.layer.cornerRadius = 20
        nextButton.layoutIfNeeded()
        nextButton.layer.cornerRadius = nextButton.frame.size.width / 2.0
        setupTextFieldsBottomLayer()
    }
    func initViews(){
        setupViews()
        setupConstraints()
    }
    internal func setupViews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.isUserInteractionEnabled = true
        setupScrollViewSubviews()
        backgroundImageView.addSubview(scrollView)
    }
    internal func setupConstraints() {
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        scrollView.anchor(top: backgroundImageView.topAnchor, left: backgroundImageView.leftAnchor, bottom: backgroundImageView.bottomAnchor, right: backgroundImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        setupScrollViewSubviewsConstraints()
    }
    
    
    
    func setupScrollViewSubviews() {
        setupTextFields()
        scrollView.addSubview(backButton)
        scrollView.addSubview(headingLabel)
        scrollView.addSubview(pageCountLabel)
        scrollView.addSubview(customerImageView)
        scrollView.addSubview(subHeadingLabel)
        cardContainerView.addSubview(nameTextField)
        cardContainerView.addSubview(cardNumberTextField)
        cardContainerView.addSubview(expDateTextField)
        cardContainerView.addSubview(cardTypeTextField)
        scrollView.addSubview(cardContainerView)
        scrollView.addSubview(skipButton)
        scrollView.addSubview(nextButton)
        
    }
    func setupScrollViewSubviewsConstraints() {
        backButton.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, topConstant: 44, leftConstant: 24, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 24)
        headingLabel.anchor(top: nil, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        headingLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).activate()
        
        customerImageView.anchor(top: headingLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width / 7, heightConstant: view.frame.width / 7)
        customerImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).activate()
        
        pageCountLabel.anchor(top: nil, left: nil, bottom: nil, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        pageCountLabel.centerYAnchor.constraint(equalTo: customerImageView.centerYAnchor).activate()
        
        
        let padding = view.frame.width / 11
        let width = view.frame.width - (padding * 2)
        let height:CGFloat = 40
        subHeadingLabel.anchor(top: customerImageView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, topConstant: padding * 2, leftConstant: padding, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        cardContainerView.anchor(top: subHeadingLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, topConstant: 22, leftConstant: padding, bottomConstant: 0, rightConstant: padding, widthConstant: width, heightConstant: 0)
        nameTextField.anchor(top: cardContainerView.topAnchor, left: cardContainerView.leftAnchor, bottom: nil, right: cardContainerView.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 25, widthConstant: 0, heightConstant: height)
        cardNumberTextField.anchor(top: nameTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: nil, right: nameTextField.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        expDateTextField.anchor(top: cardNumberTextField.bottomAnchor, left: nameTextField.leftAnchor, bottom: cardContainerView.bottomAnchor, right: cardContainerView.centerXAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 20, rightConstant: 10, widthConstant: 0, heightConstant: height)
        cardTypeTextField.anchor(top: nil, left: cardContainerView.centerXAnchor, bottom: nil, right: nameTextField.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: height)
        cardTypeTextField.centerYAnchor.constraint(equalTo: expDateTextField.centerYAnchor).activate()
        
        nextButton.anchor(top: cardContainerView.bottomAnchor, left: nil, bottom: scrollView.bottomAnchor, right: cardContainerView.rightAnchor, topConstant: 80, leftConstant: 0, bottomConstant: 30, rightConstant: 0, widthConstant: 72, heightConstant: 72)
        skipButton.anchor(top: nil, left: cardContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        skipButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor).activate()
    }
    
    
    
    
    let backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "customer_bg")
        return imageView
    }()
    let scrollView:UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.indicatorStyle = UIScrollView.IndicatorStyle.white
        view.isDirectionalLockEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    lazy var backButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    @objc fileprivate func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    let headingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "CUSTOMER"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
        return label
    }()
    let customerImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "customer")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let pageCountLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2/2"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    let subHeadingLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PAYMENT INFORMATION"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 24.0)
        return label
    }()
    let cardContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameTextField = createTextField(placeholder: "Name on Card")
    lazy var cardNumberTextField = createTextField(placeholder: "Card Number")
    lazy var expDateTextField = createTextField(placeholder: "Exp Date")
    lazy var cardTypeTextField = createTextField(placeholder: "Card Type")
    
    func createTextField(placeholder:String? = nil) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: CustomFonts.rajdhaniRegular.rawValue, size: 18.0)
        if let placeholderText = placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.lightGray])
        }
        textField.textColor = UIColor.white
        textField.textAlignment = .left
        textField.keyboardAppearance = .dark
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        return textField
    }
    
    let skipButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: CustomFonts.rajdhaniLight.rawValue, size: 20.0)!,
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue]
           //.double.rawValue, .thick.rawValue
        let attributeString = NSMutableAttributedString(string: "SKIP",
                                                        attributes: attributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func didTapSkipButton() {
        print("Skip Button Tapped")
    }
    let nextButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "red_arrow"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let inset:CGFloat = 20
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.backgroundColor = UIColor.white
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    @objc func nextButtonTapped() {
        print("Next Button Tapped")
        let vc = CustomerDashboardVC()
//        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTextFieldsBottomLayer() {
        let spaceY:CGFloat = -4
        nameTextField.blendBottomLine(spaceY: spaceY)
        cardNumberTextField.blendBottomLine(spaceY: spaceY)
        expDateTextField.blendBottomLine(spaceY: spaceY)
        cardTypeTextField.blendBottomLine(spaceY: spaceY)
    }
    func setupTextFields() {
        nameTextField.textContentType = .name
        nameTextField.keyboardType = .namePhonePad
        
        cardNumberTextField.keyboardType = .numberPad
        cardNumberTextField.textContentType = .creditCardNumber
        setupExpDatePickerTextField()
    }
    
    
    //Expiry Date Picker
    let expDatePicker = MonthYearPickerView()
    fileprivate func setupExpDatePickerTextField() {
        expDateTextField.keyboardAppearance = .default
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(expDatePickerDidTapCancel));
        
        cancelButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        cancelButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 14)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(expDatePickerDidTapDone));
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 15)!,
            .foregroundColor: UIColor.white
        ], for: .normal)
        doneButton.setTitleTextAttributes([
            .font: UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 14)!,
            .foregroundColor: UIColor.white
        ], for: .selected)
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        expDateTextField.inputAccessoryView = toolbar
        expDateTextField.inputView = expDatePicker
    }
    @objc func expDatePickerDidTapDone() {
        self.expDateTextField.resignFirstResponder()
    }
    @objc func expDatePickerDidTapCancel(){
        self.view.endEditing(true)
    }
    @objc func expDatePickerValueChanged(sender:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = CustomDateFormat.dateType1.rawValue
        expDateTextField.text = formatter.string(from: sender.date)
    }
    
    
    
    
    var activeField:UITextField?
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    fileprivate func removeKeyboardNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let contentInsets: UIEdgeInsets = .zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }, completion: nil)
    }
    @objc func keyboardShow(notification:NSNotification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight:CGFloat = keyboardSize?.height ?? 280.0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight + 50.0, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }, completion: nil)
    }
}
extension CreditCardVC: UIScrollViewDelegate {

}
extension CreditCardVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        activeField = nil
        
    }
}
