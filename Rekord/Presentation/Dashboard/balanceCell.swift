//
//  balanceCell.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 27/07/21.
//

import UIKit

class balanceCell: UITableViewCell {
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var ARLabel: UILabel!
    @IBOutlet weak var APLabel: UILabel!
    @IBOutlet weak var cashFlowLabel: UILabel!
    @IBOutlet weak var addTransactionBtn: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        balanceView.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: balanceView)
        addTransactionBtn.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: addTransactionBtn)
 
    }
    func configBalance(data : [[Double]]){// receive payment dari query
        
        //MARK: Ubah value AR/PR dan cashflow sesuai dengan total dan tanggal
        let ARTotal  : [Double] = data[0]
        let APTotal : [Double] = data[1]
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "Rp"
        
        let ARValue = ARTotal.reduce(0, +)
        let APValue = APTotal.reduce(0, +)
      
        formatter.currencyCode = "ID"
        ARLabel.text = formatter.string(from: NSNumber(value: ARValue))
        APLabel.text = formatter.string(from: NSNumber(value: APValue))
        
        //MARK: Ubah label cashflow color tergantung plus ama minus
        cashFlowLabel.text = formatter.string(from: NSNumber(value: ARValue - APValue))
        cashFlowLabel.textColor = UIColor.systemGreen
        if ARValue < APValue{
            cashFlowLabel.textColor = UIColor.systemRed
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
