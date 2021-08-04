//
//  historyCell.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 02/08/21.
//

import UIKit

class historyCell: UITableViewCell {

    @IBOutlet weak var transactionIDLabel: UILabel!
    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: baseView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
