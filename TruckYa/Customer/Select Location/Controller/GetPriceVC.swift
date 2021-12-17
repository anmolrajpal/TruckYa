//
//  GetPriceVC.swift
//  TruckYa
//
//  Created by Digit Bazar on 11/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
protocol RequestBookingDelegate {
    func hireButtonTapped()
}
class GetPriceVC:UIViewController {
    var subView = GetPriceView()
    var delegate:RequestBookingDelegate?
    
    func configureView(totalPrice:Float, totalDistance:Double, servicesCount:Int, combinedServicePrices:Float) {
        subView.flatRateValueLabel.text = "$ 4.5 / MILE"
        subView.longerHaulsTitleLabel.text = "\(servicesCount) Services"
        subView.longerHaulsValueLabel.text = "$ \(Double(combinedServicePrices).getString(withMaximumFractionDigits: 2) ?? "--")"
        subView.distanceAndPriceLabel.text = "\(totalDistance.getString(withMaximumFractionDigits: 1) ?? "--") MILES | $\(Double(totalPrice).getString(withMaximumFractionDigits: 2) ?? "--")"
    }
    
    override func loadView() {
        super.loadView()
        view = subView
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCancelButtonLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initAnimations()
        setupButtonActions()
//        setupNotificationObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeViewNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeViewNotificationsObservers()
    }
    fileprivate func observeViewNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    fileprivate func removeViewNotificationsObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
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
    fileprivate func setupButtonActions() {
        subView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: UIControl.Event.touchUpInside)
        self.subView.hireNowButton.addTarget(self, action: #selector(hireNowButtonTapped), for: UIControl.Event.touchUpInside)
    }
    fileprivate func setupCancelButtonLayout() {
        subView.cancelButton.layoutIfNeeded()
        self.subView.cancelButton.layer.cornerRadius = self.subView.cancelButton.frame.width / 2
    }
    
    @objc func didTapCancelButton() {
        print("Did Tap Cancel Button")
        deinitAnimations()
    }
    
    @objc fileprivate func hireNowButtonTapped() {
        print("Hire Now Button Tapped")
        deinitAnimations {
            self.delegate?.hireButtonTapped()
        }
    }
}
