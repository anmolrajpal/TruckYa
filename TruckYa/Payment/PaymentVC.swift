//
//  PaymentVC.swift
//  TruckYa
//
//  Created by Vishal Raj on 09/12/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
import Stripe
import SwiftyJSON
import JSSAlertView
protocol PaymentDelegate {
    func didCompletePayment()
}
class PaymentVC: UIViewController {
    var delegate:PaymentDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var overlay: UIView!
    var addCard: AddCard!
    
    var payments = [PaymentModel]()
    var isCardShowing = false
    var isPaymentMode = false
    var customerId = ""
    var amount: Float = 0.0{
        didSet{
            isPaymentMode = true
        }
    }
    var bookingId = ""
    var sender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCards()
        initViews()
    }
    
    func initViews(){
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay.alpha = 0
        overlay.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func handleBack(_ sender: Any) {
        if(self.sender == "MapViewController"){
            dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleAddCard(_ sender: Any) {
        if(!isCardShowing){
            isCardShowing = true
            overlay.alpha = 1
            overlay.isHidden = false
            addCard = AddCard.instanceFromNib() as? AddCard
            addCard.cardNoTF.delegate = self
            addCard.monthTF.delegate = self
            addCard.yearTF.delegate = self
            addCard.cardCVV.delegate = self
            addCard.delegate = self
            addCard.center = view.center
//            if(UIScreen.main.nativeBounds.height == 1136){
//                addCard.center.y = view.center.y + 48
//            }else{
//                addCard.center.y = view.center.y + 80
//            }
            view.addSubview(addCard)
            view.bringSubviewToFront(addCard)
        }
    }
    
    func getAllCards(){
        let userid = UserDefaults.standard.userID!
        let params = ["userid": userid]
        print(Endpoint.getAllCards)
        print(params)
        showLoading()
        HTTPClient().post(urlString: Endpoint.getAllCards, params: params, token: nil) { [weak self](data, error) in
            self?.hideLoading()
            if(error != nil){
                print(error!.localizedDescription)
                return
                }
            if(error == nil && data != nil){
                let json = JSON(data!)
                print(json)
                let status = json["status"].stringValue
                if(status == "error"){
                    self?.showAlert(message: json["message"].stringValue)
                    return
                }
                self?.payments = []
                json["data"].array?.forEach({ (subJson) in
                    let customerid = subJson["customer_id"].stringValue
                    self?.customerId = customerid
                    UserDefaults.standard.set(customerid, forKey: "customerid")
                    subJson["cards"]["data"].array?.forEach({ (cardJson) in
                        var pm = PaymentModel()
                        pm.id = cardJson["id"].stringValue
                        pm.exp_month = cardJson["exp_month"].intValue.description
                        pm.exp_year = cardJson["exp_year"].intValue.description
                        pm.customer = cardJson["customer"].stringValue
                        pm.last4 = cardJson["last4"].stringValue
                        pm.address_line1 = cardJson["address_line1"].stringValue
                        pm.address_line2 = cardJson["address_line2"].stringValue
                        pm.address_city = cardJson["address_city"].stringValue
                        pm.address_state = cardJson["address_state"].stringValue
                        pm.address_country = cardJson["address_country"].stringValue
                        pm.address_zip = cardJson["address_zip"].stringValue
                        pm.brand = cardJson["brand"].stringValue
                        pm.country = cardJson["country"].stringValue
                        self?.payments.append(pm)
                    })
                })
                self?.tableView.reloadData()
            }
        }
    }
    
    func addPaymentCard(card_token: String){
        if(customerId == ""){
            showAlert(message: "Unable to find customer id")
            return
        }
        let params = ["userid":UserDefaults.standard.userID!,
                      "customer_id":customerId,
                      "card_token":card_token]
        
        print(Endpoint.saveCard)
        print(params)
        
        HTTPClient().post(urlString: Endpoint.saveCard, params: params, token: nil) { [weak self](data, error) in
            if(error != nil){
                print(error!.localizedDescription)
                return
                }
            if(error == nil && data != nil){
                let json = JSON(data!)
                print(json)
                let status = json["status"].stringValue
                if(status == "error"){
                    self?.showAlert(message: json["message"].stringValue)
                    return
                }
                self?.getAllCards()
                self?.isCardShowing = false
                self?.overlay.alpha = 0
                self?.overlay.isHidden = true
                self?.addCard.delegate = nil
                self?.addCard.removeFromSuperview()
            }
        }
    }
    
    func payNow(payment: PaymentModel){
        if(customerId == ""){
            showAlert(message: "Unable to find customer id")
            return
        }
        let params = ["userid":UserDefaults.standard.userID!,
                      "customer_id":customerId,
                      "cardid":payment.id,
                      "bookingid":bookingId,
                      "description":"test"]
        print(Endpoint.payNow)
        print(params)
        
        HTTPClient().post(urlString: Endpoint.payNow, params: params, token: nil) { [weak self](data, error) in
            if(error != nil){
                print(error!.localizedDescription)
                return
                }
            if(error == nil && data != nil){
                let json = JSON(data!)
                print(json)
                let status = json["status"].stringValue
                if(status == "error"){
                    self?.showAlert(message: json["message"].stringValue)
                    return
                }
                let alertview = JSSAlertView().show(self!,
                                                    title: "Payment Successfull",
                                                    text: "",
                                                    buttonText: "OK",
                                                    color: UIColorFromHex(0xE6131E, alpha: 1))
                alertview.setTextTheme(.light)
                alertview.addAction {
                    print("Dismissing Payment VC")
                    self?.delegate?.didCompletePayment()
                }
            }
        }
    }
}

extension PaymentVC: AddCardDelegate{
    
    func addCardAction(cardNo: String, month: String, year: String, cvv: String, holderName: String) {
        print("addCardAction")
        let cNo = cardNo.replacingOccurrences(of: "-", with: "")
        let cardParams = STPCardParams()
        cardParams.number = cNo
        cardParams.expMonth = UInt(month)!
        cardParams.expYear = UInt(year)!
        cardParams.cvc = cvv
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            print("createToken")
            print(error)
            if(error == nil){
                if let token = token{
                    print(token)
                    self.addPaymentCard(card_token: token.tokenId)
                }
            }
        }
    }
    
    func cancelAction() {
        isCardShowing = false
        overlay.alpha = 0
        overlay.isHidden = true
        addCard.delegate = nil
        addCard.removeFromSuperview()
    }
}

extension PaymentVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (payments.count == 0) {
            tableView.setEmptyMessage("Add card to make payment.")
        } else {
            tableView.restore()
        }
        return payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cardNoL.text = "XXXX-XXXX-XXXX-\(payments[indexPath.row].last4)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isPaymentMode){
            payNow(payment: payments[indexPath.row])
        }
    }
}

extension PaymentVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == addCard.cardNoTF){
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let count = text.count
            if string != "" {
                if count > 19{
                    return false
                }
                if count % 5 == 0{
                    textField.text?.insert("-", at: String.Index.init(encodedOffset: count - 1))
                }
                return true
            }
        }else if(textField == addCard.monthTF){
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let count = text.count
            if string != "" {
                if count > 2{
                    return false
                }
            }
        }else if(textField == addCard.yearTF){
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let count = text.count
            if string != "" {
                if count > 4{
                    return false
                }
            }
        }else if(textField == addCard.cardCVV){
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let count = text.count
            if string != "" {
                if count > 3{
                    return false
                }
            }
        }
        return true
    }
}
