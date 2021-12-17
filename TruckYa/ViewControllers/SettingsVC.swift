//
//  SettingsVC.swift
//  TruckYa
//
//  Created by Saurabh on 05/10/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var paids = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
        
    func initViews(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (paids.count == 0) {
            tableView.setEmptyMessage("Settings will be added soon!")
        } else {
            tableView.restore()
        }
        return paids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
}
