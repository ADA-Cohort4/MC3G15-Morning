//
//  DatePickerCell.swift
//  Rekord
//
//  Created by Aqshal Wibisono on 06/08/21.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var pickerCell: UIDatePicker!
    @IBOutlet weak var dateTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerCell.addTarget(self, action: #selector(self.onPickerDone), for: .editingDidEnd)
                // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction public func onPickerDone(){
        if dateTitle.text == FilterView.picker[0]{
            FilterView.dates[0] = pickerCell.date
        } else if dateTitle.text == FilterView.picker[1]{
            FilterView.dates[1] = pickerCell.date
        }
    }
    
    
}

