//
//  Checkbox.swift
//  TruckYa
//
//  Created by Digit Bazar on 08/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
class Checkbox: UIButton {
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(#imageLiteral(resourceName: "checked_checkbox").withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
            } else {
                self.setImage(#imageLiteral(resourceName: "unchecked_checkbox").withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
