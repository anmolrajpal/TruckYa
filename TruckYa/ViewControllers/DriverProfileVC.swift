//
//  DriverProfileVC.swift
//  TruckYa
//
//  Created by Anshul on 04/10/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class DriverProfileVC: UIViewController {

    @IBOutlet weak var driverIV: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        driverIV.layer.cornerRadius = 45
        driverIV.clipsToBounds = true
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
