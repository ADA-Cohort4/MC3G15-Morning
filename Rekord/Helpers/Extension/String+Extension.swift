//
//  String+Extension.swift
//  Rekord
//
//  Created by Maritia Pangaribuan on 05/08/21.
//
import UIKit

extension String {
    
   func currencyInputFormatting() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.decimalSeparator = ""
    numberFormatter.currencySymbol = "Rp "
    numberFormatter.numberStyle = .currency
    numberFormatter.minimumFractionDigits = 0
    numberFormatter.maximumFractionDigits = 0
    numberFormatter.locale = Locale.init(identifier: "id_ID")
    var amountWithPrefix = self
    // remove from String: "$", ".", ","
    let regex = CommonFunction.shared.getRegexForAmount()
    amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
    let amount = (amountWithPrefix as NSString).doubleValue
    let saldo = (numberFormatter.string(from: NSNumber(value: amount))!).replacingOccurrences(of: ",", with: "")
    return saldo
  }
    
    func getOriginalAmount(pattern: NSRegularExpression) -> String {
        let amountWithPrefix = pattern.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        return amountWithPrefix
    }
}
