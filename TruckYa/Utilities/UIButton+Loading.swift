//
//  UIButton+Loading.swift
//  Tempo
//
//  Created by Vishal Raj on 17/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

extension UIButton {
    func loadingIndicator(_ show: Bool, _ title: String) {
        let tag = 808404
        if show {
            self.isEnabled = false
            //self.alpha = 0.5
            setTitle("Please wait", for: .normal)
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth - 24, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                setTitle(title, for: .normal)
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
