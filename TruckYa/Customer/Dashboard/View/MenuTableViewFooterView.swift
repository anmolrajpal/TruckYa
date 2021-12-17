//
//  MenuTableViewFooterView.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class MenuTableViewFooterView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        //        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        contentView.addSubview(privacyPolicyButton)
        contentView.addSubview(tncButton)
    }
    fileprivate func setupConstraints() {
        privacyPolicyButton.anchor(top: nil, left: contentView.leftAnchor, bottom: nil, right: nil, topConstant: 39, leftConstant: 24, bottomConstant: -20, rightConstant: 0)
        privacyPolicyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).withPriority(999).activate()
        tncButton.centerYAnchor.constraint(equalTo: privacyPolicyButton.centerYAnchor).activate()
        tncButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).activate()
    }
    let privacyPolicyButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 11.0)
        return button
    }()
    let tncButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Terms & Conditions", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 11.0)
        return button
    }()
}
