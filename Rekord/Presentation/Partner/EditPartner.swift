//
//  EditPartner.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 31/07/21.
//

import UIKit

class EditPartnerViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    // Unused code (Belum di connect)
    
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
    
    var updatePartner: PartnerModel!
    var partnerType: PartnerType!
    var partnerId: String?
    var partnerTypeDescription: String?
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
    
    override func viewWillAppear(_ animated: Bool) {
        //Partner ID perlu diganti kalau mau coba akses
        PartnerRepository.shared.getAllPartner { partnerList, partner in
            for updatePartner in partnerList{
                if updatePartner.idPartner == self.partnerId{
                    self.OwnerNameTextField.text = updatePartner.ownerName
                    self.businessNameTextField.text = updatePartner.name
                    self.partnerAddressTextView.text = updatePartner.address
                    self.partnerEmailTextField.text = updatePartner.email
                    self.partnerPhoneTextField.text = updatePartner.phone
                    self.partnerType = updatePartner.type
                    switch self.partnerType {
                    case .customer:
                        self.partnerTypeDescription = "Customer"
                        break
                    case .suplier:
                        self.partnerTypeDescription = "Supplier"
                        break
                    default:
                        print("error")
                    }
                }
            }
        }
        editPartnerTableView.reloadData()
    }
    
    @IBAction func saveUpdatedPartner(_ sender: Any) {
        updatePartner.type = self.partnerType
        updatePartner.address = self.partnerAddressTextView.text
        updatePartner.email = self.partnerEmailTextField.text
        updatePartner.phone = self.partnerPhoneTextField.text
        updatePartner.ownerName = self.OwnerNameTextField.text
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editPartnerTableView.dequeueReusableCell(withIdentifier: "PartnerTypeCell", for: indexPath)as! PartnerTypeCell
        cell.partnerType.text = partnerTypeDescription
        return cell
    }
}
