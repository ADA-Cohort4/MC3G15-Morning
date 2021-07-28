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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
