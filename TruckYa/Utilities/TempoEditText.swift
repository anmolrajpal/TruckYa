//
//  TempoEditText.swift
//  Tempo
//
//  Created by Anshul on 19/08/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class TempoEditText: UITextField {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
