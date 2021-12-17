//
//  DriverProfileCell.swift
//  TruckYa
//
//  Created by Digit Bazar on 07/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
protocol DriverProfileCellDelegate {
    func didTapHireButton(driverId:String)
}
class DriverProfileCell: UICollectionViewCell {
    var delegate:DriverProfileCellDelegate?
    var driverId:String!
    var vehicleImage:UIImage?
    var profileImage:UIImage?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setupViews()
        contentView.isUserInteractionEnabled = true
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        setupConstraints()
        driverProfileImageView.layoutIfNeeded()
        driverProfileImageView.layer.cornerRadius = driverProfileImageView.frame.width / 2
        driverProfileImageContainerView.layoutIfNeeded()
        driverProfileImageContainerView.layer.cornerRadius = driverProfileImageContainerView.frame.width / 2
    }
    internal func configureCell(details: NearbyDriversCodable.Datum.Driver) {
        if let id = details.driverdetails?.id, !id.isEmpty {
            self.driverId = id
        }
        numJobsLabel.text = String(details.jobdone ?? 0)
        ratingsLabel.text = details.rating
//        distanceLabel.text = (details.distance?.getString(withMaximumFractionDigits: 1) ?? "") + " MILES AWAY"
        distanceLabel.text = "\(details.distance ?? "--") MILES AWAY"
        if let driverDetails = details.driverdetails {
            nameLabel.text = driverDetails.fullname?.capitalized
            locationLabel.text = driverDetails.city
            descriptionLabel.text = driverDetails.about
            if let fullName = driverDetails.fullname {
                let group = fullName.split(separator: " ")
                let firstName = String(group[0])
                aboutLabel.text = "ABOUT \(firstName.uppercased())"
                
            }
            if let profileImagePath = driverDetails.profilepic {
                let profileImageURL = Config.EndpointConfig.baseURL + "/" + profileImagePath
                if let fullName = driverDetails.fullname {
                    let group = fullName.split(separator: " ")
                    if group.count == 2 {
                        let firstName = String(group[0])
                        let lastName = String(group[1])
                        let initialsText = (firstName.first?.uppercased() ?? "T") + (lastName.first?.uppercased() ?? "Y")
                        if let image = self.profileImage {
                            driverProfileImageView.image = image
                        } else {
                            driverProfileImageView.loadImageUsingCacheWithURLString(profileImageURL, placeHolder: UIImage.placeholderInitialsImage(text: initialsText))
                            self.profileImage = driverProfileImageView.image
                        }
                    } else if group.count == 1 {
                        let firstName = String(group[0])
                        let initialsText = (firstName.first?.uppercased() ?? "T")
                        if let image = self.profileImage {
                            driverProfileImageView.image = image
                        } else {
                            driverProfileImageView.loadImageUsingCacheWithURLString(profileImageURL, placeHolder: UIImage.placeholderInitialsImage(text: initialsText))
                            self.profileImage = driverProfileImageView.image
                        }
                    }
                } else {
                    if let image = self.profileImage {
                        driverProfileImageView.image = image
                    } else {
                        driverProfileImageView.loadImageUsingCacheWithURLString(profileImageURL, placeHolder: #imageLiteral(resourceName: "driver"))
                        self.profileImage = driverProfileImageView.image
                    }
                }
            }
            
            if let vehicleImagePath = driverDetails.vehicle?.first?.vehicleimage {
                let vehicleImageURL = Config.EndpointConfig.baseURL + "/" + vehicleImagePath
                if let image = self.vehicleImage {
                    backgroundImageView.image = image
                } else {
                    backgroundImageView.loadImageUsingCacheWithURLString(vehicleImageURL, placeHolder: #imageLiteral(resourceName: "red_hollow"))
                    self.vehicleImage = backgroundImageView.image
                }
                
            }
        }
    }
    fileprivate func setupViews() {
        contentView.addSubview(backgroundImageView)
//        contentView.addSubview(vehicleImageView)
        setupMetaContainerSubviews()
        contentView.addSubview(metaContainerView)
        contentView.addSubview(driverProfileImageContainerView)
        contentView.addSubview(driverProfileImageView)
        descriptionContainerImageView.addSubview(aboutLabel)
        descriptionContainerImageView.addSubview(descriptionLabel)
        descriptionContainerImageView.addSubview(descriptionBottomLine)
        descriptionContainerImageView.addSubview(distanceLabel)
        descriptionContainerImageView.addSubview(hireNowButton)
        contentView.addSubview(descriptionContainerImageView)
    }
    fileprivate func setupConstraints() {
        //        let bgSize:CGFloat = contentView.frame.width / 1.3
        let frameWidth:CGFloat = contentView.frame.width
        let calculatedWidth:CGFloat = frameWidth / 5
//        let bgHeight:CGFloat = frameWidth - (frameWidth / 2.2)
        let bgHeight:CGFloat = contentView.frame.height / 3.13
        backgroundImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: -10, leftConstant: 0, bottomConstant: 0, rightConstant: calculatedWidth, widthConstant: 0, heightConstant: bgHeight)
        
//        vehicleImageView.anchor(top: backgroundImageView.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: contentView.frame.width / 2.5, heightConstant: contentView.frame.width / 2.5)
//        vehicleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).activate()
//        vehicleImageView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).activate()
        //        let a:CGFloat = contentView.frame.height / 9.5
        metaContainerView.anchor(top: backgroundImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: driverProfileImageView.leftAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        setupMetaContainerSubviewsConstraints()
        let imageSize:CGFloat = contentView.frame.width / 2.8
        driverProfileImageContainerView.anchor(top: nil, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: imageSize - 5, heightConstant: imageSize - 5)
        driverProfileImageContainerView.centerYAnchor.constraint(equalTo: metaContainerView.centerYAnchor, constant: 0).activate()
        driverProfileImageView.anchor(top: nil, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: imageSize, heightConstant: imageSize)
        driverProfileImageView.centerYAnchor.constraint(equalTo: metaContainerView.centerYAnchor, constant: 0).activate()
        driverProfileImageContainerView.transform = CGAffineTransform(translationX: 4, y: 8)
        
        
        descriptionContainerImageView.anchor(top: nil, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 24, rightConstant: 24, widthConstant: 0, heightConstant: 0)
        setupDescriptionContainerSubviewsConstraints()
    }
    
    fileprivate func setupMetaContainerSubviews() {
        metaContainerView.addSubview(nameLabel)
//        metaContainerView.addSubview(designationLabel)
        metaContainerView.addSubview(locationButton)
        metaContainerView.addSubview(locationLabel)
        metaContainerView.addSubview(topHorizontalLine)
        metaContainerView.addSubview(numJobsLabel)
        metaContainerView.addSubview(jobsTitleLabel)
        metaContainerView.addSubview(verticalLine)
        metaContainerView.addSubview(ratingsLabel)
        metaContainerView.addSubview(ratingsTitleLabel)
        metaContainerView.addSubview(bottomHorizontalLine)
    }
    fileprivate func setupMetaContainerSubviewsConstraints() {
        nameLabel.anchor(top: metaContainerView.topAnchor, left: metaContainerView.leftAnchor, bottom: nil, right: metaContainerView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
//        designationLabel.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nameLabel.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        locationButton.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, topConstant: 15, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        locationLabel.anchor(top: nil, left: locationButton.rightAnchor, bottom: nil, right: nameLabel.rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        locationLabel.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor).activate()
        topHorizontalLine.anchor(top: locationButton.bottomAnchor, left: locationButton.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.8)
        numJobsLabel.anchor(top: topHorizontalLine.bottomAnchor, left: topHorizontalLine.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        jobsTitleLabel.anchor(top: numJobsLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        jobsTitleLabel.centerXAnchor.constraint(equalTo: numJobsLabel.centerXAnchor).activate()
        verticalLine.anchor(top: topHorizontalLine.bottomAnchor, left: numJobsLabel.rightAnchor, bottom: bottomHorizontalLine.topAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0.9, heightConstant: 0)
        ratingsLabel.anchor(top: numJobsLabel.topAnchor, left: verticalLine.rightAnchor, bottom: nil, right: topHorizontalLine.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        ratingsTitleLabel.anchor(top: ratingsLabel.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        ratingsTitleLabel.centerXAnchor.constraint(equalTo: ratingsLabel.centerXAnchor).activate()
        bottomHorizontalLine.anchor(top: jobsTitleLabel.bottomAnchor, left: topHorizontalLine.leftAnchor, bottom: metaContainerView.bottomAnchor, right: topHorizontalLine.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.8)
    }
    fileprivate func setupDescriptionContainerSubviewsConstraints() {
        aboutLabel.anchor(top: descriptionContainerImageView.topAnchor, left: descriptionContainerImageView.leftAnchor, bottom: nil, right: descriptionContainerImageView.rightAnchor, topConstant: 15, leftConstant: 25, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        descriptionLabel.anchor(top: aboutLabel.bottomAnchor, left: aboutLabel.leftAnchor, bottom: nil, right: aboutLabel.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        descriptionBottomLine.anchor(top: hireNowButton.topAnchor, left: aboutLabel.leftAnchor, bottom: nil, right: hireNowButton.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0.5)
        distanceLabel.anchor(top: nil, left: descriptionBottomLine.leftAnchor, bottom: descriptionContainerImageView.bottomAnchor, right: descriptionBottomLine.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        distanceLabel.centerYAnchor.constraint(equalTo: hireNowButton.centerYAnchor).activate()
        hireNowButton.layoutIfNeeded()
        let width:CGFloat = hireNowButton.frame.width + hireNowButton.contentEdgeInsets.left + hireNowButton.contentEdgeInsets.right
        let height:CGFloat = hireNowButton.frame.height + hireNowButton.contentEdgeInsets.top + hireNowButton.contentEdgeInsets.bottom
        hireNowButton.anchor(top: nil, left: nil, bottom: descriptionContainerImageView.bottomAnchor, right: descriptionContainerImageView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        hireNowButton.widthAnchor.constraint(equalToConstant: width).withPriority(999).activate()
        hireNowButton.heightAnchor.constraint(equalToConstant: height).withPriority(999).activate()
    }
    let backgroundImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = #imageLiteral(resourceName: "red_hollow")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let vehicleImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = #imageLiteral(resourceName: "truck")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    let metaContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    let nameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        //        label.backgroundColor = .blue
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 30.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let designationLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Delivery Services"
        label.font = UIFont(name: CustomFonts.gilroyRegular.rawValue, size: 18.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let locationButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "Location"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func locationButtonTapped() {
        print("Location Button Tapped")
    }
    let locationLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "California"
        label.font = UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 17.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let topHorizontalLine = Line(color: .black, opacity: 0.9)
    let verticalLine = Line(color: .black, opacity: 1.0)
    let bottomHorizontalLine = Line(color: .black, opacity: 1.0)
    let numJobsLabel:InsetLabel = {
        let label = InsetLabel(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.text = "22"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    let jobsTitleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Jobs"
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 15.0)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    let ratingsLabel:InsetLabel = {
        let label = InsetLabel(insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.text = "4.5"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    let ratingsTitleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Ratings"
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 15.0)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    let driverProfileImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "football")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let driverProfileImageContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        return view
    }()
    let descriptionContainerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.blendCorner(corner: .TopLeft)
        //        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    let descriptionContainerImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "description_container")
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    let aboutLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "ABOUT ANDREAS"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 26.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let descriptionLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "This is a boilerplate description of the driver. You can book this driver with the Hire Now button below. Real data will be fetched from the Internet as soon as the APIs are successfully developed and available. Hiring a driver comes at a cost. Follow further instructions on next screen. T&C Apply!"
        label.font = UIFont(name: CustomFonts.gilroyLight.rawValue, size: 14.0)
        label.numberOfLines = 4
        label.textAlignment = .left
        return label
    }()
    let descriptionBottomLine = Line(color: .white, opacity: 0.9)
    let distanceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "2.5 MILES AWAY"
        label.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    lazy var hireNowButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("HIRE NOW", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.bebasNeueBold.rawValue, size: 28.0)
        button.backgroundColor = .red
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 3, right: 10)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(hireNowButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    @objc fileprivate func hireNowButtonTapped() {
        print("Hire Now Button Tapped")
        delegate?.didTapHireButton(driverId: driverId)
    }
}
