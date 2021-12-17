//
//  AssertionModalController.swift
//  TruckYa
//
//  Created by Digit Bazar on 16/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

final class AssertionModalController: UIViewController {
    static let shared = AssertionModalController()
    let modalTitle:String
    init() {
        self.modalTitle = "Saved"
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = modalTitle
    }
    init(title:String) {
        self.modalTitle = title
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    func show(on vc: UIViewController? = UIApplication.currentViewController(), completion: (() -> Void)? = nil) {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        rootViewController?.transitioningDelegate = self
        vc?.present(self, animated: false, completion: {
            self.animate(completion: completion)
        })
        
    }
    fileprivate func animate(completion: (() -> Void)? = nil) {
        self.fadeIn { _ in
            self.fadeOut { _ in
                self.dismiss(animated: false, completion: completion)
            }
        }
    }
    fileprivate func fadeIn(_ duration: TimeInterval = 0.2, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.containerView.alpha = 1.0
        }, completion: completion)
    }
    
    fileprivate func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.containerView.alpha = 0.1
        }, completion: completion)
    }
    override func loadView() {
        super.loadView()
        setupViews()
        setupConstraints()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = self.containerView.frame
    }
    fileprivate func setupViews() {
        view.backgroundColor = .clear
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        view.addSubview(containerView)
    }
    fileprivate func setupConstraints() {
        imageView.anchor(top: containerView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 60)
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).activate()
        titleLabel.anchor(top: imageView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 15, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()
        containerView.layoutIfNeeded()
        containerView.widthAnchor.constraint(equalToConstant: containerView.frame.height).activate()
    }
    fileprivate let imageView:UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "checkmark").withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        view.tintColor = UIColor.white
        view.backgroundColor = .clear
        return view
    }()
    fileprivate let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.sizeToFit()
        label.font = UIFont(name: CustomFonts.gilroyRegular.rawValue, size: 16)
        label.textColor = UIColor.white
        return label
    }()
    fileprivate let containerView:UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        view.layer.cornerRadius = 15
        view.alpha = 0.5
        return view
    }()
}
