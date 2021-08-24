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
    @IBOutlet weak var filterBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        startDateView.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: startDateView)
        
        
        endDateView.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: endDateView)
        
        filterBtn.layer.cornerRadius = 10
        CommonFunction.shared.addShadow(view: filterBtn)
        
        // Initialization code
        startDatePicker.addTarget(self, action: #selector(onStartDateEdit), for: .editingDidEnd)
        endDatePicker.addTarget(self, action: #selector(onEndDateEdit), for: .editingDidEnd)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onStartDateEdit(){
        Dashboard.startDate = startDatePicker.date
    }
    @IBAction func onEndDateEdit(){
        Dashboard.endDate = endDatePicker.date
    }
    

}
