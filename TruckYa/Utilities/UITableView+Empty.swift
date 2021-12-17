//
//  UITableView+Empty.swift
//  TempoPartner
//
//  Created by Saurabh on 01/10/19.
//  Copyright © 2019 SUR ENTERTAINMENT GROUP INC. All rights reserved.
//

import UIKit

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        messageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
