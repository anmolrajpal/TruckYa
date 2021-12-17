//
//  AddCard.swift
//  Pedicab
//
//  Created by Saurabh on 25/09/19.
//  Copyright © 2019 com.seg. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol AddCardDelegate: class {
    func addCardAction(cardNo: String, month: String, year: String, cvv: String, holderName: String)
    func cancelAction()
}

class AddCard: UIView {
    
    @IBOutlet weak var cardNoTF: SkyFloatingLabelTextField!
    @IBOutlet weak var monthTF: SkyFloatingLabelTextField!
    @IBOutlet weak var yearTF: SkyFloatingLabelTextField!
    @IBOutlet weak var cardHolderNameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var cardCVV: SkyFloatingLabelTextField!
    
    weak var delegate: AddCardDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AddCard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func handleAddCard(_ sender: Any) {
        guard let cardNo = cardNoTF.text, !cardNo.isEmpty else{
            cardNoTF.shake()
            return
        }
        guard let month = monthTF.text, !month.isEmpty else{
            monthTF.shake()
            return
        }
        guard let year = yearTF.text, !year.isEmpty else{
            yearTF.shake()
            return
        }
        guard let cvv = cardCVV.text, !cvv.isEmpty else{
            cardCVV.shake()
            return
        }
        guard let cardHolderName = cardHolderNameTF.text, !cardHolderName.isEmpty else{
            cardHolderNameTF.shake()
            return
        }
        delegate?.addCardAction(cardNo: cardNo, month: month, year: year, cvv: cvv, holderName: cardHolderName)
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        delegate?.cancelAction()
    }
}
