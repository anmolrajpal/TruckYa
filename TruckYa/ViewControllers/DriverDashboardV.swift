//
//  DriverDashboardVC.swift
//  TruckYa
//
//  Created by Anshul on 04/10/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView

class DriverDashboardV: UIViewController {

    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var navLeading: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoOverlay: UIView!
    @IBOutlet weak var infoViewBottom: NSLayoutConstraint!
    @IBOutlet weak var navIV: UIImageView!
    
    var isNavShowing = false
    var isInfoShowing = false
    var navItems = [NavModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavData()
        initViews()
    }
    
    func initViews(){
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        overlay.isHidden = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DriverDashboardV.didTap))
        overlay.addGestureRecognizer(recognizer)
        navIV.layer.cornerRadius = 60
        navIV.clipsToBounds = true
//        tableView.delegate = self
//        tableView.dataSource = self
        let bgView = UIView()
        bgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tableView.backgroundView = bgView
        tableView.tableFooterView = UIView()
    }
    
    func setupNavData(){
        var item = NavModel()
        item.name = "PROFILE"
        item.image = "driver"
        navItems.append(item)
        item.name = "RIDE HISTORY"
        item.image = "ride_history"
        navItems.append(item)
        item.name = "PAYMENT METHODS"
        item.image = "payment"
        navItems.append(item)
        item.name = "NOTIFICATION"
        item.image = "notification"
        navItems.append(item)
        item.name = "SETTINGS"
        item.image = "setting"
        navItems.append(item)
        item.name = "HELP & SUPPORT"
        item.image = "help"
        navItems.append(item)
        item.name = "LOGOUT"
        item.image = "logout"
        navItems.append(item)
        tableView.reloadData()
    }
    
    @IBAction func handleInfo(_ sender: Any) {
        if(isInfoShowing){
            isInfoShowing = false
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.infoViewBottom.constant = -188
                self.infoOverlay.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
            isInfoShowing = true
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.infoViewBottom.constant = 0
                self.infoOverlay.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @objc func didTap() {
        if(isNavShowing){
            isNavShowing = false
            UIView.animate(withDuration: 1,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.navLeading.constant = -280
                            self.overlay.alpha = 0
                            self.overlay.isHidden = true
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @IBAction func handleMenu(_ sender: Any) {
        if(isNavShowing){
            isNavShowing = false
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.navLeading.constant = -280
                self.overlay.alpha = 0
                self.overlay.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        }else{
            isNavShowing = true
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.navLeading.constant = 0
                self.overlay.alpha = 1
                self.overlay.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

//extension DriverDashboardVC: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return navItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NavCell", for: indexPath) as UITableViewCell
//        cell.selectionStyle = .none
//        cell.backgroundColor = .clear
//        let label = cell.viewWithTag(100) as! UILabel
//        let imageView = cell.viewWithTag(111) as! UIImageView
//        label.text = navItems[indexPath.row].name
//        imageView.image = UIImage(named: navItems[indexPath.row].image)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        isNavShowing = false
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            self.navLeading.constant = -280
//            self.overlay.alpha = 0
//            self.overlay.isHidden = true
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//
//        switch indexPath.row {
//            case 0:
//                let vc = UIStoryboard(
//                    name: "Main", bundle: nil
//                    ).instantiateViewController(withIdentifier: "DriverProfileVC") as? DriverProfileVC
//                navigationController?.pushViewController(vc!, animated: true)
//            case 1:
//                let vc = UIStoryboard(
//                    name: "Main", bundle: nil
//                    ).instantiateViewController(withIdentifier: "RideHistoryVC") as? RideHistoryVC
//                navigationController?.pushViewController(vc!, animated: true)
//            case 2:
//                let vc = UIStoryboard(
//                    name: "Main", bundle: nil
//                    ).instantiateViewController(withIdentifier: "PaymentHistoryVC") as? PaymentHistoryVC
//                navigationController?.pushViewController(vc!, animated: true)
//            case 3:
//                let vc = UIStoryboard(
//                    name: "Main", bundle: nil
//                    ).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
//                navigationController?.pushViewController(vc!, animated: true)
//            case 4:
//                let vc = UIStoryboard(
//                    name: "Main", bundle: nil
//                    ).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC
//                navigationController?.pushViewController(vc!, animated: true)
//            case 5:
//                let vc = UIStoryboard(
//                    name: "Main", bundle: nil
//                    ).instantiateViewController(withIdentifier: "HelpVC") as? HelpVC
//                navigationController?.pushViewController(vc!, animated: true)
//            case 6:
//                let customIcon = UIImage(named: "oho")
//                let alertview = JSSAlertView().show(self,
//                                                    title: "TrucYa",
//                                                    text: "Are you sure, want to logout?",
//                                                    buttonText: "OK",
//                                                    cancelButtonText: "Cancel",
//                                                    color: UIColorFromHex(0xE6131E, alpha: 1),
//                                                    iconImage: customIcon)
//                alertview.setTextTheme(.light)
//                alertview.addAction({
//                    UserDefaults.standard.isLoggedIn = false
//                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavController") as? UINavigationController
//                    if #available(iOS 13.0, *) {
//                        vc?.modalPresentationStyle = .fullScreen
//                    }
//                    self.present(vc!, animated: true, completion: nil)
//                })
//            default: break
//        }
//    }
//}
