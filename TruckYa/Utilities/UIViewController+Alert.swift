//
//  UIViewController+Alert.swift
//  Tempo
//
//  Created by Vishal Raj on 17/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import ProgressHUD
import JSSAlertView

extension UIViewController {
    func showAlert(message: String){
        let customIcon = UIImage(named: "oho")
        let alertview = JSSAlertView().show(self,
                                            title: "TrucYa",
                                            text: "\(message)",
            buttonText: "OK",
            color: UIColorFromHex(0xFF2600, alpha: 1),
            iconImage: customIcon)
        alertview.setTextTheme(.light)
    }
    
    func showLoading(){
        ProgressHUD.spinnerColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        ProgressHUD.backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        ProgressHUD.hudColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        ProgressHUD.show()
    }
    
    func showProgress(progress: String){
        ProgressHUD.spinnerColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        ProgressHUD.backgroundColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        ProgressHUD.hudColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        ProgressHUD.show(progress)
    }
    
    func hideLoading(){
        ProgressHUD.dismiss()
    }
}
