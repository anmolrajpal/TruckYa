//
//  UITextField+Validation.swift
//  Tempo
//
//  Created by Vishal Raj on 17/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

extension UITextField{
    func setError(){
//        self.layer.cornerRadius = 8
//        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        self.clipsToBounds = true
//        attributedPlaceholder = NSAttributedString(string: placeHolder,
//                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        resignFirstResponder()
    }
    
    func setNormal(){
//        self.layer.cornerRadius = 8
//        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
//        attributedPlaceholder = NSAttributedString(string: placeHolder,
//                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}
