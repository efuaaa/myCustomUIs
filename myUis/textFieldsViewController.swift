//
//  textFieldsViewController.swift
//  myUis
//
//  Created by user on 10/09/2019.
//  Copyright © 2019 Qodehub. All rights reserved.
//

import UIKit
import Foundation
import iOSDropDown


class textFieldsViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var dropDown: DropDown!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var usaView: UIView!
    @IBOutlet weak var dropdownImageView: UIImageView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var ghView: UIView!
    @IBOutlet weak var dropDownLabel: UILabel!
    @IBOutlet weak var textfield1: ExpFloatingLabelTextField!
    @IBOutlet weak var textfield2: ExpFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        dropdownImageView.layer.cornerRadius = dropdownImageView.frame.size.width/2
        dropdownImageView.clipsToBounds = true

        setupTextfields(textField: textfield1)
        setupTextfields(textField: textfield2)
        textfield1.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
        textfield2.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
        textfield1.addTarget(self, action: #selector(calculateUSD(_:)), for: .editingChanged)
        textfield2.addTarget(self, action: #selector(calculateGHS(_:)), for: .editingChanged)
        rateLabel.layer.cornerRadius = 12
        parentView.layer.cornerRadius = 5
      
        rateLabel.layer.masksToBounds = true
        setupDropDownTextField(dropDown: dropDown)
        
    }
    
    
    
    
    
    
    
    
    
    func setupDropDownTextField(dropDown: DropDown )
    {
        dropDown.optionArray = ["PerfectMoney USD", "Bitcoin USD", "Skrill USD", "Ether USD", "Litecoin USD","Bitcoin Cash USD", "Dogecoin"]
        dropDown.isSearchEnable = false
        dropDown.rowHeight = 50
        dropDown.selectedRowColor = .white
        dropDown.listHeight = 300
        dropDown.optionIds = [1,2,3,4,5,6,7,8]
        dropDown.optionImageArray = ["filled-circle", "filled-circleq2",  "user-female-circle", "filled-circle", "filled-circleq2", "user-female-circle"]
        dropdownImageView.image = UIImage(named: "user-female-circle")
        
        
        // The the Closure returns Selected Index and String
        dropDown.didSelect{(selectedText , index ,id) in
            self.dropDownLabel.text = "\(selectedText)"
        }
        
        dropDown.didSelect{(selectedImage , index ,id) in
            self.dropdownImageView.image =  UIImage(named: "\(selectedImage)")
        }
    }
    
    
    

    func setupTextfields(textField:ExpFloatingLabelTextField){
        
        textField.delegate = self
        textField.textColor = UIColor.white
        textField.font = UIFont(name:"Roboto-Medium", size: 12)
        textField.titleColor = UIColor.white
        textField.selectedTitleColor = UIColor.blue
        textField.lineHeight = 0
        textField.placeholderColor = UIColor.lightGray
        textField.selectedLineHeight = 0
        
    }
    
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString

        }

    }
    
    @objc func calculateUSD(_ textField: UITextField) {
   
        if textfield1.text != nil {
            let convertedString1 = convertCurrencyToDouble(input: textfield1.text!)
            var convertedString2 = convertCurrencyToDouble(input: textfield2.text!)
    
            if convertedString1 != nil{
                convertedString2 = convertedString1! * 3.95
                let y = Double(round(100*convertedString2!)/100)
    
                textfield2.text = "\(y)"
            }
    
            else{
                print("boom crashed")
            }
        }
    }
    
   @objc func calculateGHS(_ textField: UITextField) {
        if textfield1.text != nil {
            var convertedString1 = convertCurrencyToDouble(input: textfield1.text!)
            let convertedString2 = convertCurrencyToDouble(input: textfield2.text!)
            
            if convertedString2 != nil{
                convertedString1 = convertedString2! / 3.95
                let y = Double(round(100*convertedString1!)/100)
                
                textfield1.text = "\(y)"
            }
                
            else{
                print("boom")
            }
        }
    }
    
    func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
       numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: input)?.doubleValue
    }
    
  
   


}


extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        
        var amountWithPrefix = self
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        return formatter.string(from: number)!
    }
}
