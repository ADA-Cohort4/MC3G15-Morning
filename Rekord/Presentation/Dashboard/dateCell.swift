//
//  dateCell.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 27/07/21.
//

import UIKit

class dateCell: UITableViewCell {
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        startDateView.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: startDateView)
        
        
        endDateView.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: endDateView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
