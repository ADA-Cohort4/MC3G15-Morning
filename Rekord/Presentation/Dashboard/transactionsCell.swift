//
//  transactionsCell.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 27/07/21.
//

import UIKit

class transactionsCell: UITableViewCell{
    
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var TRIDLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var nextPaymentLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var dueAlertIcon: UIImageView!
    @IBOutlet weak var baseView: UIView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: baseView)
        // Initialization code
       
        
    }

    

}
