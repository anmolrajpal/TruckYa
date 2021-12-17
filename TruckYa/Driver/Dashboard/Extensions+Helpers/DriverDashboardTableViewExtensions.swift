//
//  DriverDashboardTableViewExtensions.swift
//  TruckYa
//
//  Created by Anmol Rajpal on 13/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import JSSAlertView
import SafariServices
extension DriverDashboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            let imageSize = MenuTableViewHeaderCell().contentView.frame.width / 2.1
            let cellHeight:CGFloat = imageSize + 24 + 20 + 10
            return cellHeight
        } else {
            return 68.0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}
extension DriverDashboardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.menuItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MenuTableViewHeaderCell.self), for: indexPath) as! MenuTableViewHeaderCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.profileImageView.loadImageUsingCacheWithURLString(self.profileImageURL, placeHolder: #imageLiteral(resourceName: "driver"))
            cell.nameLabel.text = self.name
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MenuTableViewCell.self), for: indexPath) as! MenuTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            let menuItem = self.menuItems[indexPath.row - 1]
            cell.configureCell(item: menuItem)
            cell.layoutIfNeeded()
            return cell
        }
        
        
        
    }
    func dismissMenu(with completion: ((Bool) -> Void)? = nil) {
        let menuTableViewWidth:CGFloat = self.subView.menuTableView.frame.width
        isMenuShowing = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.subView.menuTableView.transform = CGAffineTransform(translationX: -menuTableViewWidth, y: 0)
                self.subView.overlay.alpha = 0
                self.subView.overlay.isHidden = true
            }, completion: completion)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        switch indexPath.row {
            case 1:
                //MARK: HOME
                dismissMenu()
            case 2:
                //MARK: PROFILE
                let vc = DriverProfileViewController()
                dismissMenu { _ in self.navigationController?.pushViewController(vc, animated: true) }
            case 3:
                //MARK: MANAGE SERVICES
                print("MANAGE SERVICES")
                let vc = ManageServicesViewController()
                dismissMenu { _ in self.navigationController?.pushViewController(vc, animated: true) }
                
            case 4:
                //MARK: RIDE HISTORY
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RideHistoryVC") as! RideHistoryVC
                dismissMenu { _ in self.navigationController?.pushViewController(vc, animated: true) }
            
//            case 5:
//                //MARK: PAYMENT METHODS
//                print("Payment Methods")
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentHistoryVC") as! PaymentHistoryVC
//                dismissMenu { _ in self.navigationController?.pushViewController(vc, animated: true) }
                
            case 5:
            //MARK: HELP & SUPPORT
            print("HELP AND SUPPORT")
            guard let url = URLSession.shared.constructURL(host: "trucya.com", port: nil, path: .HelpAndSupport) else {
                print("Error Log: Unable to Construct URL")
                return
            }
            let safariVC = SFSafariViewController(url: url)
            if #available(iOS 13.0, *) {
                safariVC.modalPresentationStyle = .popover
                safariVC.isModalInPopover = false
            } else {
                safariVC.modalPresentationStyle = .overFullScreen
            }
            dismissMenu { _ in self.navigationController?.present(safariVC, animated: true, completion: nil) }
            case 6:
                //MARK: LOG OUT
                print("Log Out")
                dismissMenu { _ in
                    let alertview = JSSAlertView().show(self,
                                                        title: "Confirm Logout?",
                                                        text: "Are you sure you want to logout?",
                                                        buttonText: "OK",
                                                        cancelButtonText: "Cancel",
                                                        color: UIColorFromHex(0xE6131E, alpha: 1),
                                                        iconImage: nil)
                    alertview.setTextTheme(.light)
                    alertview.addAction({
                        
                        
                        PushNotificationManager.shared.deleteFCMToken { (fcmError) in
                            if let fcm_error = fcmError {
                                print("Error deleting FCM Token: \(fcm_error.localizedDescription)")
                                let alertview = JSSAlertView().show(self,
                                                                    title: "Error",
                                                                    text: fcm_error.localizedDescription,
                                                                    buttonText: "OK",
                                                                    cancelButtonText: "Cancel",
                                                                    color: UIColorFromHex(0xE6131E, alpha: 1),
                                                                    iconImage: nil)
                                alertview.setTextTheme(.light)
                            } else {
                                print("FCM Logout successful")
                                self.subView.menuTableView.isHidden = true
                                UserDefaults.clearUserDefaults()
                                UserDefaults.standard.isLoggedIn = false
                                DispatchQueue.main.async {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                            
                        }
                        
                        
//                        self.subView.menuTableView.isHidden = true
//                        UserDefaults.clearUserDefaults()
//                        UserDefaults.standard.isLoggedIn = false
//                        DispatchQueue.main.async {
//                            self.navigationController?.popToRootViewController(animated: true)
//                        }
                        
                    })
                }
            default: break
        }
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    func showPrivacyPolicy() {
        guard let url = URLSession.shared.constructURL(host: "trucya.com", port: nil, path: .PrivacyPolicy) else {
            print("Error Log: Unable to Construct URL")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        //        safariVC.preferredControlTintColor = UIColor.white
        //        safariVC.preferredBarTintColor = UIColor.red.withAlphaComponent(0.1)
        if #available(iOS 13.0, *) {
            safariVC.modalPresentationStyle = .popover
            safariVC.isModalInPopover = false
        } else {
            safariVC.modalPresentationStyle = .overFullScreen
        }
        present(safariVC, animated: true, completion: nil)
    }
    func showTermsAndConditions() {
        guard let url = URLSession.shared.constructURL(host: "trucya.com", port: nil, path: .TermsAndConditions) else {
            print("Error Log: Unable to Construct URL")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        if #available(iOS 13.0, *) {
            safariVC.modalPresentationStyle = .popover
            safariVC.isModalInPopover = false
        } else {
            safariVC.modalPresentationStyle = .overFullScreen
        }
        present(safariVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(MenuTableViewFooterView.self)) as! MenuTableViewFooterView
        footerView.privacyPolicyButton.addTarget(self, action: #selector(didTapPrivacyPolicyButton), for: .touchUpInside)
        footerView.tncButton.addTarget(self, action: #selector(didTapTnCButton), for: .touchUpInside)
        return footerView
    }
    @objc fileprivate func didTapPrivacyPolicyButton() {
        print("Privacy Policy Tapped")
        dismissMenu { _ in self.showPrivacyPolicy() }
    }
    @objc fileprivate func didTapTnCButton() {
        print("Terms & Conditions Tapped")
        dismissMenu { _ in self.showTermsAndConditions() }
    }
}
