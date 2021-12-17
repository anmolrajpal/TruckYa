//
//  MenuTableViewHeaderCell.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class MenuTableViewHeaderCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    internal func configureCell(item: MenuItem) {
        profileImageView.image = item.image
        nameLabel.text = ""
    }
    fileprivate func setupViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
    }
    fileprivate func setupConstraints() {
        let imageSize:CGFloat = self.contentView.frame.width / 2.1
        profileImageView.anchor(top: contentView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: imageSize, heightConstant: imageSize)
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).activate()
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 20, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).withPriority(999).activate()
    }
    let profileImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "football")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let nameLabel :UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Allen Cooper"
        label.textColor = UIColor.white
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 18.0)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
}
