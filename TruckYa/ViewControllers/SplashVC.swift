//
//  ViewController.swift
//  TruckYa
//
//  Created by Anshul on 16/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         navigate()
    }
    func navigate(){
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            
            let vc = UIStoryboard(
                name: "Main", bundle: nil
            ).instantiateViewController(withIdentifier: "RootVC") as? UINavigationController
            if #available(iOS 13.0, *) {
                vc?.modalPresentationStyle = .fullScreen
            }
            
            self.present(vc!, animated: false, completion: nil)
        })
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .darkContent
//    }
}

