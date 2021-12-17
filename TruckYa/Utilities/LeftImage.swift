//
//  LeftImage.swift
//  Tempo
//
//  Created by Anshul on 19/08/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftIcon(_ icon: UIImage) {
        let padding = 16
        let size = 16
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size + (padding * 2), height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        iconView.contentMode = .scaleAspectFit
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }
    
    func setLeftPadding(padding: Int) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
        leftView = outerView
        leftViewMode = .always
    }
}
