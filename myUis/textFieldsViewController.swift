//
//  textFieldsViewController.swift
//  myUis
//
//  Created by user on 10/09/2019.
//  Copyright © 2019 Qodehub. All rights reserved.
//

import UIKit
import Foundation

class textFieldsViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var usaView: UIView!
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var ghView: UIView!
    @IBOutlet weak var textfield1: ExpFloatingLabelTextField!
    @IBOutlet weak var textfield2: ExpFloatingLabelTextField!
//    let usLocale = Locale(identifier: "en_US")
    var typedValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextfields(textField: textfield1)
        setupTextfields(textField: textfield2)
        textfield1.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
        textfield2.addTarget(self, action: #selector(myTextFieldDidChange(_:)), for: .editingChanged)
        textfield1.addTarget(self, action: #selector(calculateUSD(_:)), for: .editingChanged)
        textfield2.addTarget(self, action: #selector(calculateGHS(_:)), for: .editingChanged)
        rateLabel.layer.cornerRadius = 5
        parentView.layer.cornerRadius = 5
//         textfield2.layer.cornerRadius = 5
////        textfield1.roundBottomBorderLeft()
////        textfield2.roundBottomBorderRight()
//         ghView.layer.cornerRadius = 5
//         usaView.layer.cornerRadius = 5


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
//        formatter.numberStyle = .currencyAccounting
//        formatter.currencySymbol = "$"
        
        formatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
//        guard number != 0 as NSNumber else {
//            return ""
//        }

        return formatter.string(from: number)!
    }
}
