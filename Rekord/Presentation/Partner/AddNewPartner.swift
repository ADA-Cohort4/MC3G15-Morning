//
//  AddNewPartner.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 31/07/21.
//

import UIKit

class AddNewPartnerViewControlelr: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var businessPartnerName: String?
    var partnerOwnerName: String?
    var partnerEmail: String?
    var partnerPhone: String?
    var partnerAddress: String?
    var partnerType: PartnerType?
    var partner_id: String?
    var business_id: String?
    var user_id: String?
    
    @IBOutlet weak var AddPartnerTableView: UITableView!
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
    
    @IBOutlet weak var savePartnerButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        AddPartnerTableView.register(UINib.init(nibName: "SelectFromContactCell", bundle: nil), forCellReuseIdentifier: "SelectFromContactCell")
        AddPartnerTableView.register(UINib.init(nibName: "PartnerTypeCell", bundle: nil), forCellReuseIdentifier: "PartnerTypeCell")
        AddPartnerTableView.reloadData()
        partnerBusinessCell.layer.cornerRadius = 10
        partnerOwnerCell.layer.cornerRadius = 10
        partnerEmailCell.layer.cornerRadius = 10
        partnerPhoneCell.layer.cornerRadius = 10
        partnerAddressCell.layer.cornerRadius = 10
        
        self.navigationController?.navigationBar.isHidden = false
        businessPartnerName = businessNameTextField.text
        partnerPhone = partnerPhoneTextField.text
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = AddPartnerTableView.dequeueReusableCell(withIdentifier: "SelectFromContactCell", for: indexPath)as! SelectFromContactCell
            return cell
        }else{
            let cell = AddPartnerTableView.dequeueReusableCell(withIdentifier: "PartnerTypeCell", for: indexPath)as! PartnerTypeCell
            cell.partnerType.text = self.partnerType?.rawValue
            return cell

        }
    }
    @IBAction func saveNewPartner(_ sender: Any) {
        let user_id = UUID().uuidString
        let newPartner = PartnerModel(idPartner: partner_id!, idUser: user_id, type: partnerType ?? .customer , name: businessPartnerName!, phone: partnerPhone!, status: .active, airtableId: "")
        PartnerRepository.shared.savePartner(partner: newPartner){ (result) in
            if result.airtableId != "" || result.airtableId != nil {
                DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("error save")
            }
        }
        
    }
    
}
