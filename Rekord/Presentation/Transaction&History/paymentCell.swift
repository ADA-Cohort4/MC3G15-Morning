//
//  paymentCell.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 02/08/21.
//

import UIKit

class paymentCell: UITableViewCell {

    @IBOutlet weak var paymentCountLabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
