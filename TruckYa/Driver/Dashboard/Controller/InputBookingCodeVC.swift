//
//  InputBookingCodeVC.swift
//  TruckYa
//
//  Created by Digit Bazar on 02/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
protocol InputBookingCodeDelegate {
    func doneButtonTapped(with bookingCode:String)
}
class InputBookingCodeVC: UIViewController, UIScrollViewDelegate {
    var subView = InputBookingCodeView()
    var delegate:InputBookingCodeDelegate?
    
    //    func configureView(totalPricePerMile:Float, totalPrice:Float, totalDistance:Double, servicesCount:Int) {
    //        subView.flatRateValueLabel.text = "$ \(Double(totalPricePerMile).getString(withMaximumFractionDigits: 2) ?? "--") / MILE  (\(servicesCount) Services)"
    //        subView.distanceAndPriceLabel.text = "\(totalDistance.getString(withMaximumFractionDigits: 1) ?? "--") MILES | $\(Double(totalPrice).getString(withMaximumFractionDigits: 2) ?? "--")"
    //    }
    
    override func loadView() {
        super.loadView()
        view = subView
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCrossButtonLayout()
        subView.blendBottomLine(below: subView.bookingCodeTextField)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initAnimations()
        setupTargetActions()
        subView.bookingCodeTextField.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeViewNotifications()
        observeKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeViewNotificationsObservers()
        removeKeyboardNotificationsObservers()
    }
    fileprivate func removeKeyboardNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    fileprivate func observeViewNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    fileprivate func removeViewNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    //    func setupNotificationObservers() {
    //        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    //    }
    @objc private func handleEnterForeground() {
        initAnimations()
    }
    fileprivate func initAnimations() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            self.subView.alpha = 0.1
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                            self.subView.alpha = 1.0
                            self.subView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
                            self.subView.cancelButton.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.subView.containerImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        })
    }
    fileprivate func deinitAnimations(callback: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.subView.alpha = 0
            self.subView.cancelButton.transform = CGAffineTransform(translationX: 0, y: self.subView.frame.height)
            self.subView.containerImageView.transform = CGAffineTransform(translationX: 0, y: self.subView.frame.height)
        }, completion: { _ in
            self.dismiss(animated: false, completion: callback)
        })
    }
    fileprivate func setupTargetActions() {
//        self.subView.bookingCodeTextField.addTarget(self, action: #selector(didChangeTextField(textField:)), for: .editingChanged)
        self.subView.crossButton.addTarget(self, action: #selector(didTapCrossButton), for: UIControl.Event.touchUpInside)
        self.subView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: UIControl.Event.touchUpInside)
        self.subView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: UIControl.Event.touchUpInside)
    }
    fileprivate func setupCrossButtonLayout() {
        subView.crossButton.layoutIfNeeded()
        self.subView.crossButton.layer.cornerRadius = self.subView.crossButton.frame.width / 2
    }
    
    @objc func didTapCrossButton() {
        print("Did Tap cross Button")
        deinitAnimations()
    }
    
    @objc fileprivate func cancelButtonTapped() {
        print("Cancel Button Tapped")
        deinitAnimations()
    }
    @objc fileprivate func doneButtonTapped() {
        print("Done Button Tapped")
        guard let bookingCode = subView.bookingCodeTextField.text, bookingCode.count == 6 else { return }
        deinitAnimations {
            self.delegate?.doneButtonTapped(with: bookingCode)
        }
    }
    internal func enableDoneButton() {
        DispatchQueue.main.async {
            self.subView.doneButton.isEnabled = true
            //            UIView.animate(withDuration: 0.4) {
            //                self.subView.doneButton.alpha = 1.0
            //            }
        }
    }
    internal func disableDoneButton() {
        DispatchQueue.main.async {
            self.subView.doneButton.isEnabled = false
            //            UIView.animate(withDuration: 0.4) {
            //                self.subView.doneButton.alpha = 0.5
            //            }
        }
    }
    @objc fileprivate func didChangeTextField(textField:UITextField) {
        if let text = textField.text {
            if text.isEmpty {
                self.disableDoneButton()
            } else {
                self.validateFields()
            }
        } else { self.disableDoneButton() }
    }
    fileprivate func isDataValid() -> Bool {
        guard let booking_code = self.subView.bookingCodeTextField.text, !booking_code.isEmpty, booking_code.count == 6 else { return false }
        return true
    }
    fileprivate func validateFields() {
        isDataValid() ? enableDoneButton() : disableDoneButton()
    }
    
    
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardShow(notification:NSNotification) {
     
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight:CGFloat = keyboardSize?.height ?? 280.0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = -keyboardHeight
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
extension InputBookingCodeVC: UITextFieldDelegate {
    
}
