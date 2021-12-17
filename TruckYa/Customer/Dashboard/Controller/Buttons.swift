//
//  Buttons.swift
//  Basic Integration
//
//  Created by Ben Guo on 4/25/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import UIKit
import Stripe

class HighlightingButton: UIButton {
    var highlightColor = UIColor(white: 0, alpha: 0.05)

    convenience init(highlightColor: UIColor) {
        self.init()
        self.highlightColor = highlightColor
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = self.highlightColor
            } else {
                self.backgroundColor = .clear
            }
        }
    }
}

class BuyButton: UIButton {
    static let defaultHeight = CGFloat(52)
    static let defaultFont = UIFont.boldSystemFont(ofSize: 20)
    var disabledColor = UIColor.lightGray
    var enabledColor = UIColor.stripeBrightGreen

    override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? enabledColor : disabledColor
            setTitleColor(.white, for: UIControl.State())
            backgroundColor = color
        }
    }

    init(enabled: Bool, title: String) {
        super.init(frame: .zero)
        // Shadow
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 7
        layer.shadowOffset = CGSize(width: 0, height: 7)
        
        setTitle(title, for: UIControl.State())
        titleLabel!.font = type(of: self).defaultFont
        isEnabled = enabled
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BrowseBuyButton: BuyButton {
    let priceLabel = UILabel()
    
    init(enabled: Bool) {
        super.init(enabled: enabled, title: "Buy Now")
        priceLabel.textColor = .white
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = type(of: self).defaultFont
        priceLabel.textAlignment = .right
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIColor {
    // Swift unfortunately doesn't yet have a clean way of checking for iOS 13 at compile-time, so we attempt to import CryptoKit, a framework that only exists on iOS 13.
    // We can delete all of these awful #if canImport() blocks once the iOS 13 SDK is required for App Store submissions, probably ~March 2020.
    static let stripeBrightGreen : UIColor = {
        var color = UIColor(red: 33/255, green: 180/255, blue: 126/255, alpha: 1.0)
        #if canImport(CryptoKit)
        if #available(iOS 13.0, *) {
            color = UIColor.init(dynamicProvider: { (tc) -> UIColor in
                return (tc.userInterfaceStyle == .light) ?
                    UIColor(red: 33/255, green: 180/255, blue: 126/255, alpha: 1.0) :
                    UIColor(red: 39/255, green: 213/255, blue: 149/255, alpha: 1.0)
            })
        }
        #endif
        return color
    }()
    static let stripeDarkBlue : UIColor = {
        var color = UIColor(red: 80/255, green: 95/255, blue: 127/255, alpha: 1.0)
        #if canImport(CryptoKit)
        if #available(iOS 13.0, *) {
            color = UIColor.init(dynamicProvider: { (tc) -> UIColor in
                return (tc.userInterfaceStyle == .light) ?
                    UIColor(red: 80/255, green: 95/255, blue: 127/255, alpha: 1.0) :
                    UIColor(red: 121/255, green: 142/255, blue: 188/255, alpha: 1.0)
            })
        }
        #endif
        return color
    }()
}
