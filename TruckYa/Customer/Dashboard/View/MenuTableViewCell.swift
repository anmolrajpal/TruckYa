//
//  MenuTableViewCell.swift
//  TruckYa
//
//  Created by Digit Bazar on 12/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
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
        
    }
    internal func configureCell(item: MenuItem) {
        menuItemImageView.image = item.image
        menuItemLabel.text = item.title
    }
    fileprivate func setupViews() {
        contentView.addSubview(menuItemImageView)
        contentView.addSubview(menuItemLabel)
    }
    fileprivate func setupConstraints() {
        menuItemImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 15, leftConstant: 24, bottomConstant: 15, rightConstant: 0)
        menuItemImageView.widthAnchor.constraint(equalToConstant: 28).withPriority(999).activate()
        menuItemImageView.heightAnchor.constraint(equalToConstant: 28).withPriority(999).activate()
        menuItemLabel.anchor(top: nil, left: menuItemImageView.rightAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        menuItemLabel.centerYAnchor.constraint(equalTo: menuItemImageView.centerYAnchor).activate()
    }
    let menuItemImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFill
        view.image = #imageLiteral(resourceName: "edit_img")
        view.clipsToBounds = true
        return view
    }()
    let menuItemLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Home"
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 12.0)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
}
