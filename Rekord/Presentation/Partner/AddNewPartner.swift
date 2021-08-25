//
//  AddNewPartner.swift
//  Rekord
//
//  Created by Audrey Aurelia Chang on 31/07/21.
//

import UIKit
import Contacts
import ContactsUI

class AddNewPartnerViewControlelr: UIViewController, UITableViewDelegate, UITableViewDataSource , CNContactPickerDelegate{
    
    var businessPartnerName: String?
    var partnerOwnerName: String?
    var partnerEmail: String?
    var partnerPhone: String?
    var partnerAddress: String?
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
    
    
    let partnerTypes = ["Customer", "Supplier"]
    var selectedType = ""
    var selectedPartnerType = ""
    var selectedData = ""
    
    override func viewDidLoad() {
        AddPartnerTableView.register(UINib.init(nibName: "SelectFromContactCell", bundle: nil), forCellReuseIdentifier: "SelectFromContactCell")
        AddPartnerTableView.reloadData()
        
        partnerBusinessCell.layer.cornerRadius = 10
        partnerOwnerCell.layer.cornerRadius = 10
        partnerEmailCell.layer.cornerRadius = 10
        partnerPhoneCell.layer.cornerRadius = 10
        partnerAddressCell.layer.cornerRadius = 10
        partnerAddressTextView.layer.borderColor = #colorLiteral(red: 0.9140917659, green: 0.9183221459, blue: 0.9286623597, alpha: 1)
        partnerAddressTextView.layer.borderWidth = 1
        partnerAddressTextView.layer.cornerRadius = 8
        businessNameTextField.placeholder = "Your partner's business"
        OwnerNameTextField.placeholder = "Your partner's owner"
        partnerEmailTextField.placeholder = "Your partner's email"
        partnerPhoneTextField.placeholder = "Your partner's phone"
            
        partnerEmailTextField.keyboardType = UIKeyboardType.emailAddress
        partnerPhoneTextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "Add Partner"
        
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectContact()
        }
    }
    
    func validateEmail(emailToValidate: String)-> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: emailToValidate)
    }
    
    func validateFormInput()->Bool{
        if businessNameTextField.text?.isEmpty == true{
            return false
        }else if OwnerNameTextField.text?.isEmpty == true{
            return false
        }else if partnerPhoneTextField.text?.isEmpty == true{
            return false
        }else if partnerAddressTextView.text?.isEmpty == true{
            return false
        }else{
            return true
        }
    }
    
    @objc func selectContact(){
        let contactVC = CNContactPickerViewController()
        contactVC.delegate = self
        present(contactVC, animated: true)
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        OwnerNameTextField.text = contact.givenName + " " + contact.familyName
        businessNameTextField.text = contact.organizationName
        if contact.emailAddresses.isEmpty != true {
            partnerEmailTextField.text = contact.emailAddresses[0].value.description
        }
        if contact.postalAddresses.isEmpty != true {
            if contact.postalAddresses[0].value.street.isEmpty != true {
                partnerAddressTextView.text = contact.postalAddresses[0].value.street
            }
            if contact.postalAddresses[0].value.city.isEmpty != true{
                partnerAddressTextView.text = partnerAddressTextView.text + "\n" + contact.postalAddresses[0].value.city
            }
            if contact.postalAddresses[0].value.state.isEmpty != true {
                partnerAddressTextView.text = partnerAddressTextView.text + ", " + contact.postalAddresses[0].value.state
            }
            if contact.postalAddresses[0].value.postalCode.isEmpty != true {
                partnerAddressTextView.text = partnerAddressTextView.text + "\n" + contact.postalAddresses[0].value.postalCode
            }
        }
        
        if contact.phoneNumbers.isEmpty != true {
            partnerPhoneTextField.text = contact.phoneNumbers[0].value.stringValue
        }
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
            let newPartner = PartnerModel(idPartner: partner_id!, idUser: user_id ?? "errorID", idBusiness: business_id ?? "errorID"
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
