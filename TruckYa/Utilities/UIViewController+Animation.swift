//
//  UIViewController+Animation.swift
//  Tempo
//
//  Created by Vishal Raj on 17/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

extension UIViewController {
    func animateView(view: UIView){
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: [],
                       animations: {
                        view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },completion: { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform.identity
            }
        })
    }
}
