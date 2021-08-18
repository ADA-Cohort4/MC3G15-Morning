//
//  profileCell.swift
//  Rekord
//
//  Created by Ivan Valentino Sigit on 12/08/21.
//

import Foundation
import UIKit

class profileCell: UITableViewCell{
    
    @IBOutlet var baseView: [UIView]!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet var edit: [UIButton]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0..<4 {
            baseView[i].layer.cornerRadius = 10
            CommonFunction.shared.addShadow(view: baseView[i])
        }
    }

}
