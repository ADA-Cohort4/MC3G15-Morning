//
//  EditPartner.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 31/07/21.
//

import UIKit

class EditPartnerViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var editPartnerTableView: UITableView!
    
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var OwnerNameTextField: UITextField!
    @IBOutlet weak var partnerEmailTextField: UITextField!
    @IBOutlet weak var partnerPhoneTextField: UITextField!
    @IBOutlet weak var partnerAddressTextView: UITextView!
    
    @IBOutlet weak var partnerBusinessCell: UIView!
    @IBOutlet weak var partnerOwnerCell: UIView!
    @IBOutlet weak var partnerEmailCell: UIView!
    @IBOutlet weak var partnerPhoneCell: UIView!
    @IBOutlet weak var partnerAddressCell: UIView!
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var deletePartnerButton: UIButton!
    
    override func viewDidLoad() {
        editPartnerTableView.register(UINib.init(nibName: "PartnerTypeCell", bundle: nil), forCellReuseIdentifier: "PartnerTypeCell")
        editPartnerTableView.reloadData()
        partnerBusinessCell.layer.cornerRadius = 10
        partnerOwnerCell.layer.cornerRadius = 10
        partnerEmailCell.layer.cornerRadius = 10
        partnerPhoneCell.layer.cornerRadius = 10
        partnerAddressCell.layer.cornerRadius = 10
        SaveButton.layer.cornerRadius = 10
        deletePartnerButton.layer.cornerRadius = 10
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editPartnerTableView.dequeueReusableCell(withIdentifier: "PartnerTypeCell", for: indexPath)as! PartnerTypeCell
        return cell
    }
}
