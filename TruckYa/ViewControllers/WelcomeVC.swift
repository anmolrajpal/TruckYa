//
//  WelcomeVC.swift
//  TruckYa
//
//  Created by Anshul on 04/10/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    
    
    @IBOutlet weak var topContainerView: UIView!
    override func loadView() {
        super.loadView()
//        setupViews()
//        setupConstraints()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    @IBAction func driverButtonTapped(_ sender: Any) {
        navigate(userType: .Driver)
    }
    
    @IBAction func customerButtonTapped(_ sender: Any) {
        navigate(userType: .Customer)
    }
    
    @IBAction func handleBackButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    let signupLabel:UILabel = {
        let label = UILabel()
        label.text = "SIGN UP"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.rajdhaniBold.rawValue, size: 28.0)
        label.textColor = UIColor.white
        label.transform = CGAffineTransform(rotationAngle: -.pi / 2)
        return label
    }()
    let verticalLine = Line(color: .white, opacity: 1.0)
    func setupViews() {
        topContainerView.addSubview(signupLabel)
        topContainerView.addSubview(verticalLine)
    }
    func setupConstraints() {
        signupLabel.anchor(top: topContainerView.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: -20, widthConstant: 0, heightConstant: 0)
        signupLabel.layoutIfNeeded()
        verticalLine.anchor(top: signupLabel.bottomAnchor, left: nil, bottom: topContainerView.bottomAnchor, right: nil, topConstant: signupLabel.frame.width, leftConstant: 0, bottomConstant: topContainerView.frame.height / 5, rightConstant: 0, widthConstant: 0.8, heightConstant: 0)
        verticalLine.centerXAnchor.constraint(equalTo: signupLabel.centerXAnchor).activate()
    }
    func navigate(userType: UserType) {
        switch userType {
        case .Driver:
            let vc = DriverSignupVC()
            navigationController?.pushViewController(vc, animated: true)
        case .Customer:
            let vc = CustomerSignupVC()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
}
