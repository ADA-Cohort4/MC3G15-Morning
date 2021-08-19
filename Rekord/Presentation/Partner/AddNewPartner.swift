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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var partnerTypeView: FilterView!
    
    let partnerTypes = ["Customer", "Supplier"]
    var selectedType = ""
    var selectedPartnerType = ""
    var selectedData = ""
    
    override func viewDidLoad() {
        AddPartnerTableView.register(UINib.init(nibName: "SelectFromContactCell", bundle: nil), forCellReuseIdentifier: "SelectFromContactCell")
//        AddPartnerTableView.register(UINib.init(nibName: "PartnerTypeCell", bundle: nil), forCellReuseIdentifier: "PartnerTypeCell")
        AddPartnerTableView.reloadData()
        
        partnerBusinessCell.layer.cornerRadius = 10
        partnerOwnerCell.layer.cornerRadius = 10
        partnerEmailCell.layer.cornerRadius = 10
        partnerPhoneCell.layer.cornerRadius = 10
        partnerAddressCell.layer.cornerRadius = 10
        partnerTypeView.layer.cornerRadius = 10
        partnerAddressTextView.layer.borderColor = #colorLiteral(red: 0.9140917659, green: 0.9183221459, blue: 0.9286623597, alpha: 1)
        partnerAddressTextView.layer.borderWidth = 1
        partnerAddressTextView.layer.cornerRadius = 8
        businessNameTextField.placeholder = "Input business name"
        OwnerNameTextField.placeholder = "Input partner owner name"
        partnerEmailTextField.placeholder = "Input partner email"
        partnerPhoneTextField.placeholder = "Input phone number"
            
        partnerEmailTextField.keyboardType = UIKeyboardType.emailAddress
        partnerPhoneTextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "Add Partner"
        partnerTypeView.isHidden = true
        
        partnerTypeView.doneBtn.addTarget(self, action: #selector(self.onDoneButtonClicked), for: .touchUpInside)
        

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddPartnerTableView.dequeueReusableCell(withIdentifier: "SelectFromContactCell", for: indexPath)as! SelectFromContactCell
        return cell
//        if indexPath.section == 0 {
//            let cell = AddPartnerTableView.dequeueReusableCell(withIdentifier: "SelectFromContactCell", for: indexPath)as! SelectFromContactCell
//            return cell
//        }
//        else{
//            let cell = AddPartnerTableView.dequeueReusableCell(withIdentifier: "PartnerTypeCell", for: indexPath)as! PartnerTypeCell
//            cell.partnerType.text! = selectedData
//            return cell
//        }
//
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            selectedType = "partner"
            partnerTypeView.viewMode = selectedType
            partnerTypeView.cellData = partnerTypes
            partnerTypeView.optionsTableView.reloadData()
            partnerTypeView.filterTitle.text = "Select Partner Type"
            if partnerTypeView.isHidden == true {
                partnerTypeView.isHidden = false
            }else{
                partnerTypeView.isHidden = true
            }
        }
    }
    
    func validateEmail(emailToValidate: String)-> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: emailToValidate)
    }
    
    @IBAction func onDoneButtonClicked(){
        if partnerTypeView.selectedOption != "" {
            selectedData = partnerTypeView.selectedOption
            switch selectedData{
            case "Customer":
                partnerType = .customer
                selectedPartnerType = "Customer"
                break
            case "Supplier":
                partnerType = .suplier
                selectedPartnerType = "Supplier"
                break
            default:
                print("Error")
            }
        }
        partnerTypeView.isHidden = true
        AddPartnerTableView.reloadData()
    }
    
    @IBAction func saveNewPartner(_ sender: Any) {
        
        let user_id = UserDefaults.standard.string(forKey: "userID")
        let business_id = UserDefaults.standard.string(forKey: "businessID")
        partner_id = CommonFunction.shared.randomString(length: 8)
        businessPartnerName = businessNameTextField.text
        partnerPhone = partnerPhoneTextField.text
        partnerEmail = partnerEmailTextField.text
        partnerOwnerName = OwnerNameTextField.text
        partnerAddress = partnerAddressTextView.text
        
        if validateEmail(emailToValidate: partnerEmail ?? "Email is empty") == true {
            let newPartner = PartnerModel(idPartner: partner_id!, idUser: user_id ?? "errorID", idBusiness: business_id ?? "errorID", type: partnerType ?? .customer
                                          , name: businessPartnerName!, phone: partnerPhone!, status: .active, airtableId: "", address: partnerAddress!, email: partnerEmail!, ownerName: partnerOwnerName!)
            let alert = UIAlertController(title: "Saving Partner...", message: "Please wait while we save your partner.", preferredStyle: .alert)
            self.present(alert, animated: true)
            
            PartnerRepository.shared.savePartner(partner: newPartner){ (result) in
                if result.airtableId != "" || result.airtableId != nil {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil) //finished alert
                    self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    alert.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "Error", message: "There was an error in saving your partner. Try checking your internet connection or restarting the app.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                    print("error save partner")
                }
            }
        }else{
            let alert = UIAlertController(title: "Invalid Email", message: "Please input a valid email address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The alert has been dismissed.")
            }))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
}
