//
//  UiviewRound.swift
//  Tempo
//
//  Created by Anshul on 20/08/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class roundUIView: UIView {
    
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
